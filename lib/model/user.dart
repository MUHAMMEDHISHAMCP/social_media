import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String userName;
  String email;
  String uid;
  String imageUrl;
  String? about;
  String? place;

  UserData({
    required this.email,
    required this.userName,
    required this.uid,
    required this.imageUrl,
    this.about,
    this.place,
  });

  Map<String, dynamic> toJason() => {
        "userName": userName,
        "uid": uid,
        "email": email,
        "imageUrl": imageUrl,
        "place" : place ??'',
        "about": about??'',
      };

  static UserData fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return UserData(
      email: snap['email'],
      userName: snap['userName'],
      uid: snap['uid'],
      imageUrl: snap['imageUrl'],
      place: snap['place'],
      about: snap['about'],
    );
  }
}
