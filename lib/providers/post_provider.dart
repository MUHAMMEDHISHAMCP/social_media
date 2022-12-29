import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

Future<void> postImage(
    Uint8List file,
    String uid,
    String profileUrl,
    String userName,
    String decription
  ) async {

    isLoading = true;
    notifyListeners();
    try {
      String res = await uploadPost(file, decription, uid, userName, profileUrl);

      if (res == 'Success') {
        isLoading = false;
        notifyListeners();
        ShowDialogs.popUp('Posted',subColor.withOpacity(0.6));
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ShowDialogs.popUp(e.toString());
    }
  }
}
