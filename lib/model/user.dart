
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String userName;
  String email;
  String uid;
  String imageUrl;

  UserData(
      {required this.email,
      required this.userName,
      required this.uid,
      required this.imageUrl});

  Map<String, dynamic> toJason() => {
        "userName": userName,
        "uid": uid,
        "email": email,
        "imageUrl": imageUrl,
      };

      static UserData fromSnap(DocumentSnapshot snapshot){
       var snap = snapshot.data() as Map<String,dynamic>;

       return UserData(email: snap['email'], userName: snap['userName'], uid: snap['uid'], imageUrl: snap['imageUrl']);


      }
}
