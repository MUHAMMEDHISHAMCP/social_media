import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageMethod{
FirebaseStorage storage = FirebaseStorage.instance;
FirebaseAuth auth = FirebaseAuth.instance;


Future<String> uploadImage(String childName,Uint8List file,bool isPost,String uid) async{

  print(auth.currentUser!.uid);

Reference ref = storage.ref().child(childName).child(uid);

UploadTask uploadTask = ref.putData(file);

TaskSnapshot snapshot = await uploadTask;
String downloadUrl = await snapshot.ref.getDownloadURL();

return downloadUrl;



}




}