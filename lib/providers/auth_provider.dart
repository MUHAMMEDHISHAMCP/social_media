import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/model/user.dart';
import 'package:jsc_task2/providers/storage_method.dart';
import 'package:jsc_task2/screens/widgets/bottom_nav.dart';
import 'package:jsc_task2/screens/widgets/snack_bar.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;


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

       
          String imageUrl =
              await StorageMethod().uploadImage('profilePics', file, false,);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNav(),
              ),
              (route) => false);
           UserData userData = UserData(email: email, userName: userName, uid:userDetails.user!.uid, imageUrl: imageUrl);
          // await fireStore.collection('users').doc(userDetails.user!.uid).set(
          //     {"userName": userName, "email": email, "imageUrl": imageUrl});
          await fireStore.collection('users').doc(userDetails.user!.uid).set(userData.toJason());
          msg = 'Success';
        } else {
          notifyListeners();
          ShowDialogs.popUp("Passwords dosen't match");
        }
      }
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        return ShowDialogs.popUp('Enter valid email');
      } else if (e.code == 'network-request-failed') {
        return ShowDialogs.popUp('No Internet');
      } else if (e.code == 'weak-password') {
        return ShowDialogs.popUp('Password too short');
      } else if (e.code == 'email-already-in-use') {
        return ShowDialogs.popUp('Email already exist');
      }
    } catch (e) {
      // print(e.toString());
      log(e.toString());
      msg = e.toString();
    }
    return msg;
  }

  
  Future<void> userSignUp(String email, String password, String confirmpsvd,
      String userName, Uint8List file, context) async {
      isLoading = true;
      notifyListeners();

    String result =  await signUpUser( email,  password,  confirmpsvd,
       userName,  file, context);

    if (result != 'Success') {
      ShowDialogs.popUp("Something went worng");
        isLoading = false;
        notifyListeners();
   
    }else{

      isLoading =false;
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
   
        return ShowDialogs.popUp('Enter valid email');
      } else if (e.code == 'network-request-failed') {
        return ShowDialogs.popUp('No Internet');
      } else if (e.code == 'weak-password') {
        return ShowDialogs.popUp('Password too short');
      } else if (e.code == 'email-already-in-use') {
        return ShowDialogs.popUp('Email already exist');
      }
    } catch (e) {
      print(e.toString());
      msg = e.toString();
    }
    return msg;
  }

    Future<void> userLogIn(    String email,
    String password,
    context,) async {
      isLoading = true;
       notifyListeners();
    String result = await signInUser(email, password, context);

    if (result != "Success") {
      ShowDialogs.popUp("Email and Password dosen't match");
        isLoading = false;
        notifyListeners();
   
    }
  }

  //##-- Get UserDetails --##\\
  
  Future<UserData> getUserDetails() async{
  User currentUser = auth.currentUser!;

   DocumentSnapshot snap = await fireStore.collection('users').doc(currentUser.uid).get();

   return UserData.fromSnap(snap);
  }
}