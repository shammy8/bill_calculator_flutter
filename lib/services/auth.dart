// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User> get user => _auth.authStateChanges();

  Future<User> anonLogin() async {
    UserCredential user = await _auth.signInAnonymously();
    // updateUserData(user)
    return user.user;
  }

  Future<User> googleSignIn() async {
    // try {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential result = await _auth.signInWithCredential(credential);
    User user = result.user;
    // updateUserData(user)
    return user;
    // } catch (error) {
    //   print(error);
    //   return null;
    // }
  }

  Future<void> updateUserPimaryBill(int billId, String userId) {
    return _firestore.doc('users/$userId').update({'primaryBill': billId});
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
