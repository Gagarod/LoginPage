import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

Future<UserCredential> signInWithGoogle(BuildContext context) async {

  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  FirebaseAuth.instance.signInWithCredential(credential).then((result) {
      dbRef.child(result.user.uid).set({
        "email": result.user.email,
        // "age": ageController.text,
        "name": result.user.displayName
      }).then((res) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home(uid: result.user.uid)),
        );
      });
    });

}