//originally can work
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthService {
//   // instance of auth
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   //sign in
//   Future<UserCredential> signInWithEmailPassword(String email, password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     }
//   }
//
//   //sign up
//   Future<UserCredential> signUpWithEmailPassword(String email, password) async {
//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e);
//     }
//   }
//
//   //sign out
//   Future<void> signOut() async {
//     return await _auth.signOut();
//   }
//
//   //errors
//
//
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign up
  Future<UserCredential> signUpWithEmailPassword(
      String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'displayName': displayName,
        // Add more user data fields as needed
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Method to get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Method to update the username
  Future<void> updateUsername(String newUsername) async {
    try {
      await _auth.currentUser!.updateDisplayName(newUsername);
    } catch (e) {
      // Handle error
      print("Error updating username: $e");
    }
  }
}
