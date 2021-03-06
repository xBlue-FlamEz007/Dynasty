import 'package:dynasty/services/database.dart';
import 'package:dynasty/modals/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

abstract class AuthBase {
  Stream<USER> get onAuthStateChanged;
  Future<USER> currentUser();
  String currentUserID();
  Future<USER> signInWithEmailAndPassword(String email, String password);
  Future<USER> createUserWithEmailAndPassword(String firstName, String lastName, String email, String password, File imageFile);
  Future<USER> signInWithGoogle();
  Future<void> signOut();
}

class Auth implements AuthBase{
  final _firebaseAuth = FirebaseAuth.instance;

  USER _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return USER(uid: user.uid);
  }

  @override
  Stream<USER> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<USER> currentUser() async {
    final user = await _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  String currentUserID() {
    final user = _firebaseAuth.currentUser;
    String uid = user.uid;
    return uid;
  }

  @override
  Future<USER> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<USER> createUserWithEmailAndPassword(String firstName, String lastName, String email, String password, File imageFile) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User user = authResult.user;
    await DatabaseService(uid: user.uid).setUserData(firstName, lastName, email, imageFile);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<USER> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}