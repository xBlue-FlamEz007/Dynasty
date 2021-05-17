import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynasty/modals/property.dart';
import 'package:dynasty/modals/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseService {
  DatabaseService({this.uid});
  final String uid;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference propertyCollection = FirebaseFirestore.instance.collection("properties");
  CollectionReference favouriteCollection;

  //USERS
  Future setUserData(String firstName, String lastName, String email, File image, String phoneNumber) async {
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
        'profile pic': imageFileName,
        'phone number': phoneNumber,
      });
    });
    favouriteCollection = userCollection.doc(uid).collection("favourites");
  }

  Future updateUserData(String firstName, String lastName, File image) async {
    String imageFileName;
    var userReference = firestore.collection("users").doc(uid);
    if (image == null) {
      firestore.runTransaction((transaction) async {
        transaction.update(userReference, {
          'first name': firstName,
          'last name': lastName,
        });
      });
    } else {
      imageFileName = basename(image.path);
      final firebaseStorage = FirebaseStorage.instance.ref().child(imageFileName);
      final uploadTask = firebaseStorage.putFile(image);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      imageFileName = imageUrl.toString();
      firestore.runTransaction((transaction) async {
        transaction.update(userReference, {
          'first name': firstName,
          'last name': lastName,
          'profile pic' : imageFileName,
        });
      });
    }
  }

  Future updateFavourites(List <String>favourites) async {
    var userReference = firestore.collection("users").doc(uid);
    firestore.runTransaction((transaction) async {
      transaction.update(userReference, {
        'favourites': favourites,
      });
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      firstName: snapshot.data()['first name'],
      lastName: snapshot.data()['last name'],
      email: snapshot.data()['email'],
      profilePic: snapshot.data()['profile pic'],
      phoneNumber: snapshot.data()['phone number'],
      favourites: snapshot.data()['favourites'],
    );
  }

  Stream <UserData> get userData {
    return userCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

  //Properties
  Future setPropertyData(File image, String propertyType, String description, String location,
      String address, String dealType, String price, String date) async {
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
    await propertyCollection.add({
      'property pic': imageFileName,
      'property type': propertyType,
      'description': description,
      'location': location,
      'address': address,
      'deal type': dealType,
      'price': price,
      'date': date,
      'user id' : uid
      });
  }

  List<PropertyData> _allPropertyListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) =>
        PropertyData(
          pid: doc.id,
          propertyPic: doc.data()['property pic'],
          propertyType: doc.data()['property type'],
          description: doc.data()['description'],
          location: doc.data()['location'],
          address: doc.data()['address'],
          dealType: doc.data()['deal type'],
          price: doc.data()['price'],
          date: doc.data()['date'],
          uid: doc.data()['user id'],
        )).toList();
  }

  Stream <List<PropertyData>> get allProperties {
    return propertyCollection.where('user id', isNotEqualTo: uid).snapshots()
        .map(_allPropertyListFromSnapshot);
  }

  Stream <List<PropertyData>> get sellProperties {
    return propertyCollection.where('user id', isNotEqualTo: uid).
    where('deal type', isEqualTo: 'Sell').snapshots()
        .map(_allPropertyListFromSnapshot);
  }

  Stream <List<PropertyData>> get rentProperties {
    return propertyCollection.where('user id', isNotEqualTo: uid).
    where('deal type', isEqualTo: 'Rent').snapshots()
        .map(_allPropertyListFromSnapshot);
  }

  Stream <List<PropertyData>> get myProperties {
    return propertyCollection.where('user id', isEqualTo: uid).snapshots()
        .map(_allPropertyListFromSnapshot);
  }

  Future<void> deleteImage(String pic) async {
    var fileUrl = Uri.decodeFull(basename(pic)).replaceAll(new RegExp(r'(\?alt).*'), '');
    print('PICTURE: $fileUrl');
    final firebaseStorageRef =
    FirebaseStorage.instance.ref().child(pic);
    await firebaseStorageRef.delete();
  }

  Future<void> deletePost(String pid, String pic) {
    return propertyCollection.doc(pid).delete();
  }

}
