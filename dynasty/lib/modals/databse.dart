import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService({this.uid});
  final String uid;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future updateUserData(String firstName, String lastName, String email) async {
    var documentReference = firestore.collection("users").doc(uid);
    firestore.runTransaction((transaction) async {
      transaction.set(documentReference, {
        'first name': firstName,
        'last name': lastName,
        'Email': email,
      });
    });
  }
}
