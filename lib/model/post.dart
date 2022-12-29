import 'package:cloud_firestore/cloud_firestore.dart';

class PostDatas {
  String userName;
  String uid;
  String postUrl;
  String pofileUrl;
  String? decription;
  String postId;
  String datePosted;
  final likes;

  PostDatas(
      {required this.pofileUrl,
      required this.userName,
      required this.uid,
      required this.postUrl,
      required this.postId,
      this.decription,
      required this.datePosted,
      required this.likes});

  Map<String, dynamic> toJason() => {
        "userName": userName,
        "uid": uid,
        "postImageUrl": postUrl,
        "pofileUrl": pofileUrl,
        "decription": decription,
        "postId": postId,
        "date": datePosted,
        "likes": likes
      };

  static PostDatas fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return PostDatas(
        pofileUrl: snap['pofileUrl'],
        userName: snap['userName'],
        uid: snap['uid'],
        postUrl: snap['postImageUrl'],
        decription: snap['decription'],
        datePosted: snap['date'],
        postId: snap['postId'],
        likes: snap['likes']);
  }
}
