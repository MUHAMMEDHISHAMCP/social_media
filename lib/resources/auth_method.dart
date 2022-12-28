import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/resources/storage_method.dart';
import 'package:jsc_task2/screens/widgets/bottom_nav.dart';
import 'package:jsc_task2/screens/widgets/snack_bar.dart';

class AuthMethods extends ChangeNotifier {
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<String> signUpUser(String email, String password, String confirmpsvd,
      String userName, Uint8List file, context) async {
    String msg = "";
    isLoading = true;
    notifyListeners();
    try {
      if (email.isNotEmpty || password.isNotEmpty || confirmpsvd.isNotEmpty) {
        if (password == confirmpsvd) {
          final userDetails = await auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          log(auth.currentUser!.uid);
          String imageUrl =
              await StorageMethod().uploadImage('profilePics', file, false, '');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNav(),
              ),
              (route) => false);

          await fireStore.collection('users').doc(userDetails.user!.uid).set(
              {"userName": userName, "email": email, "imageUrl": imageUrl});
          isLoading = false;
          msg = 'SignUp Success';
        } else {
          isLoading = false;
          notifyListeners();
          ShowDialogs.popUp("Passwords dosen't match");
        }
      }
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        isLoading = false;
        return ShowDialogs.popUp('Enter valid email');
      } else if (e.code == 'network-request-failed') {
        isLoading = false;
        return ShowDialogs.popUp('No Internet');
      } else if (e.code == 'weak-password') {
        isLoading = false;
        return ShowDialogs.popUp('Password too short');
      } else if (e.code == 'email-already-in-use') {
        isLoading = false;
        return ShowDialogs.popUp('Email already exist');
      }
    } catch (e) {
      // print(e.toString());
      log(e.toString());
      msg = e.toString();
    }
    return msg;
  }


//##-- SignIn User --##\\
  Future<String> signInUser(
    String email,
    String password,
    context,
  ) async {
    String msg = '';
    isLoading = true;
    notifyListeners();

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
        return ShowDialogs.popUp('Enter valid email');
      } else if (e.code == 'network-request-failed') {
        isLoading = false;
        return ShowDialogs.popUp('No Internet');
      } else if (e.code == 'weak-password') {
        isLoading = false;
        return ShowDialogs.popUp('Password too short');
      } else if (e.code == 'email-already-in-use') {
        isLoading = false;
        return ShowDialogs.popUp('Email already exist');
      }
    } catch (e) {
      msg = e.toString();
     print(e);
    }
    return msg;
  }


}