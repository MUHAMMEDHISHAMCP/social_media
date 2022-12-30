import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/model/user.dart';
import 'package:jsc_task2/providers/storage_method.dart';
import 'package:jsc_task2/providers/user_provider.dart';
import 'package:jsc_task2/screens/login_screen.dart';
import 'package:jsc_task2/screens/widgets/bottom_nav.dart';
import 'package:jsc_task2/screens/widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  bool _isObscure = true;

  get isObscure => _isObscure;
  set isObscure(value) {
    _isObscure = value;
    notifyListeners();
  }

//##-- SignUp User --##\\

  Future<String> signUpUser(String email, String password, String confirmpsvd,
      String userName, Uint8List file, context) async {
    String msg = "";

    try {
      if (email.isNotEmpty || password.isNotEmpty || confirmpsvd.isNotEmpty) {
        if (password == confirmpsvd) {
          final userDetails = await auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          String imageUrl = await StorageMethod().uploadImage(
            'profilePics',
            file,
            false,
          );
          isLoading = false;
          notifyListeners();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNav(),
              ),
              (route) => false);
          UserData userData = UserData(
              email: email,
              userName: userName,
              uid: userDetails.user!.uid,
              imageUrl: imageUrl);
          // await fireStore.collection('users').doc(userDetails.user!.uid).set(
          //     {"userName": userName, "email": email, "imageUrl": imageUrl});
          await fireStore
              .collection('users')
              .doc(userDetails.user!.uid)
              .set(userData.toJason());
              isLoading = false;
              notifyListeners();
          msg = 'Success';
        } else {
          isLoading = false;
          notifyListeners();
          ShowDialogs.popUp("Passwords dosen't match");
        }
      }
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        isLoading = false;
        notifyListeners();
        return ShowDialogs.popUp('Enter valid email');
      } else if (e.code == 'network-request-failed') {
        isLoading = false;
        notifyListeners();
        return ShowDialogs.popUp('No Internet');
      } else if (e.code == 'weak-password') {
        isLoading = false;
        notifyListeners();
        return ShowDialogs.popUp('Password too short');
      } else if (e.code == 'email-already-in-use') {
        isLoading = false;
        notifyListeners();
        return ShowDialogs.popUp('Email already exist');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      log(e.toString());
      msg = e.toString();
    }
    return msg;
  }

  Future<void> userSignUp(String email, String password, String confirmpsvd,
      String userName, Uint8List file, context) async {
    isLoading = true;
    notifyListeners();

    String result =
        await signUpUser(email, password, confirmpsvd, userName, file, context);

    if (result != 'Success') {
      isLoading = false;
      notifyListeners();
      ShowDialogs.popUp("Something went worng");
    } else {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('isLoged', true);
      isLoading = false;
      notifyListeners();
    }
  }

//##-- SignIn User --##\\
  Future<String> signInUser(
    String email,
    String password,
    context,
  ) async {
    String msg = '';

    try {
      log('try');
      if (email.isNotEmpty || password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        msg = 'Success';
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const BottomNav(),
            ),
            (route) => false);
      }
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        isLoading = false;
        notifyListeners();
        return ShowDialogs.popUp('Enter valid email');
      } else if (e.code == 'network-request-failed') {
        isLoading = false;
        notifyListeners();
        return ShowDialogs.popUp('No Internet');
      } else if (e.code == 'weak-password') {
        isLoading = false;
        notifyListeners();
        return ShowDialogs.popUp('Password too short');
      } else if (e.code == 'email-already-in-use') {
        isLoading = false;
        notifyListeners();
        return ShowDialogs.popUp('Email already exist');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      msg = e.toString();
    }
    return msg;
  }

  Future<void> userLogIn(
    String email,
    String password,
    context,
  ) async {
    isLoading = true;
    notifyListeners();
    String result = await signInUser(email, password, context);

    if (result != "Success") {
      isLoading = false;
      notifyListeners();
      ShowDialogs.popUp("Email and Password dosen't match");
    } else {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('isLoged', true);
      isLoading = false;
      notifyListeners();
    }
  }

  //##-- Get UserDetails --##\\

  Future<UserData> getUserDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot snap =
        await fireStore.collection('users').doc(currentUser.uid).get();

    return UserData.fromSnap(snap);
  }

//##-- Sign Out --##

  Future<void> signOut(context) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
            'Logout !!',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text('Are you sure to want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text(
                'No',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {}).then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LogInScreen()),
                      (route) => false);
                });
              },
              child: const Text('Yes',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUser(
     String name, String about, String place, String email, String imageUrl,
      [Uint8List? profile]) async {
    String updatedProfUrl;
    isLoading = true;
    notifyListeners();
    try {
      if (profile == null) {
        updatedProfUrl = imageUrl;
        log(updatedProfUrl.toString());
      } else {
        updatedProfUrl = await StorageMethod().uploadImage(
          'profilePics',
          profile,
          false,
        );
        log('updates');
        log(updatedProfUrl.toString());
      }
      if (name.isEmpty && place.isEmpty && about.isEmpty) {
       
        isLoading = false;
        notifyListeners();
        return ShowDialogs.popUp('Please Fill fields');
      }

      UserData user = UserData(
        email: email,
        place: place,
        about: about,
        userName: name,
        imageUrl: updatedProfUrl,
        uid: auth.currentUser!.uid,
      );

      log(user.email.toString());
     await fireStore.collection('users').doc(auth.currentUser!.uid).update(
            user.toJason(),
          );
      isLoading = false;
      notifyListeners();
      ShowDialogs.popUp('Updated Successfully',Colors.transparent);

    } on FirebaseException catch (e) {
    if (e.code == 'network-request-failed') {
        isLoading = false;
        notifyListeners();
        return ShowDialogs.popUp('No Internet');
      }
      isLoading = false;
      notifyListeners();
      log(e.toString());
    } catch (e) {
      isLoading =false;
      notifyListeners();
      print(e.toString());
    }
  }
}
