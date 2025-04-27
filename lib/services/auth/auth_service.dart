import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // auth instance and firestore

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // sign in

  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      // sign user in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // save user if not already exists, like if we create user in firebase console not through the app

      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out
  Future<void> signout() async {
    await _auth.signOut();
  }

  // errors

  // sign up
  Future<UserCredential> signupWithEmailPassword(String email, password) async {
    try {
      // create user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      // save user in a separate document

      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
