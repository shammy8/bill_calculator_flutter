import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> anonLogin() async {
    final UserCredential user = await _auth.signInAnonymously();
    // updateUserData(user)
    return user.user;
  }

  Future<User?> googleSignIn() async {
    // try {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final UserCredential result = await _auth.signInWithCredential(credential);
    final User? user = result.user;
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

  Future<void> signOut() async {
    return _auth.signOut();
  }
}
