import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynasty/modals/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService({this.uid});
  final String uid;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  Future setUserData(String firstName, String lastName, String email, File image) async {
    String imageFileName;
    if (image == null) {
      imageFileName = 'default';
    } else {
      imageFileName = basename(image.path);
      final firebaseStorage = FirebaseStorage.instance.ref().child(imageFileName);
      final uploadTask = firebaseStorage.putFile(image);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      imageFileName = imageUrl.toString();
      print(imageFileName);
    }
    var userReference = firestore.collection("users").doc(uid);
    firestore.runTransaction((transaction) async {
      transaction.set(userReference, {
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'profile pic' : imageFileName,
      });
    });
  }

  Future updateUserData(String firstName, String lastName, File image) async {
    String imageFileName;
    imageFileName = basename(image.path);
    final firebaseStorage = FirebaseStorage.instance.ref().child(imageFileName);
    final uploadTask = firebaseStorage.putFile(image);
    var imageUrl = await (await uploadTask).ref.getDownloadURL();
    String url = imageUrl.toString();
    var userReference = firestore.collection("users").doc(uid);
    firestore.runTransaction((transaction) async {
      transaction.update(userReference, {
        'first name': firstName,
        'last name': lastName,
        'profile pic' : imageFileName,
      });
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      firstName: snapshot.data()['first name'],
      lastName: snapshot.data()['last name'],
      email: snapshot.data()['email'],
      profilePic: snapshot.data()['profile pic']
    );
  }

  Stream <UserData> get userData {
    return userCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

  Future getImageURL(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child(imageName);
    var imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

}
