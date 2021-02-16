import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService({this.uid});
  final String uid;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future updateUserData(String firstName, String lastName, String email, File image) async {
    String imageFileName;
    if (image == null) {
      imageFileName = 'default_profilepic.png';
    } else {
      imageFileName = basename(image.path);
      final firebaseStorage = FirebaseStorage.instance.ref().child(imageFileName);
      final uploadTask = firebaseStorage.putFile(image);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      String url = imageUrl.toString();
    }
    var documentReference = firestore.collection("users").doc(uid);
    firestore.runTransaction((transaction) async {
      transaction.set(documentReference, {
        'first name': firstName,
        'last name': lastName,
        'Email': email,
        'profile pic' : imageFileName,
      });
    });
  }
}
