import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/model/post.dart';
import 'package:jsc_task2/providers/storage_method.dart';
import 'package:jsc_task2/screens/widgets/snack_bar.dart';
import 'package:jsc_task2/utils/const_color.dart';
import 'package:uuid/uuid.dart';

class PostProvider extends ChangeNotifier {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  bool isLoading = false;

  //##-- Upload post --##

  Future<String> uploadPost(
    Uint8List file,
    String decription,
    String uid,
    String userName,
    String profileImage,
  ) async {
    String msg = "";
    try {
      String postImageUrl = await StorageMethod().uploadImage(
        'posts',
        file,
        true,
      );

      String postId = const Uuid().v1();

      PostDatas post = PostDatas(
        pofileUrl: profileImage,
        userName: userName,
        uid: uid,
        postUrl: postImageUrl,
        postId: postId,
        likes: [],
        decription: decription,
        datePosted: DateTime.now().toString(),
      );

      fireStore.collection('posts').doc(postId).set(post.toJason());

      msg = 'Success';
    } catch (e) {
      msg = e.toString();
    }
    return msg;
  }

  Future<void> postImage(Uint8List file, String uid, String profileUrl,
      String userName, String decription) async {
    isLoading = true;
    notifyListeners();
    try {
      String res =
          await uploadPost(file, decription, uid, userName, profileUrl);

      if (res == 'Success') {
        isLoading = false;
        notifyListeners();
        ShowDialogs.popUp('Posted', subColor.withOpacity(0.6));
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ShowDialogs.popUp(e.toString());
    }
  }

  Future<void> likePost(context, List likes, String postId) async {
    //  UserData userDetails = Provider.of<UserProvider>(context,listen: false).getUser;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      if (likes.contains(auth.currentUser!.uid)) {
        fireStore.collection('posts').doc(postId).update(
          {
            "likes": FieldValue.arrayRemove([auth.currentUser!.uid]),
            // "isLiked":false
          },
        );
      } else {
        fireStore.collection('posts').doc(postId).update(
          {
            "likes": FieldValue.arrayUnion([auth.currentUser!.uid]),
            // "isLiked":true
          },
        );
      }
    } catch (e) {
      log(e.toString());
    }

  }



  //##-- Comment on post --##

  Future<void> postComment(String comment, String userName, String uid,
      String postId, String profilePic) async {
    //  FirebaseAuth auth = FirebaseAuth.instance;
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        await fireStore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          "comment": comment,
          "userName": userName,
          "profile": profilePic,
          "uid": uid,
          "commentId": commentId
        });
      } else {
        return;
      }
    } catch (e) {
      log(e.toString());
    }
  }


                                
}
