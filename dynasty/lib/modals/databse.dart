import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService({this.uid});
  final String uid;

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String firstName, String lastName, String email) async {
    return await userCollection.doc(uid).set({
      'first name': firstName,
      'last name': lastName,
      'Email': email,
    });
  }

}