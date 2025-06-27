import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:wishes_social_media_app/Screens/Home/Home.dart';

import 'phoneno.dart';

class Loginbutton extends StatefulWidget {
  final String imagePath;
  final String buttonText;
  final String btn;

  const Loginbutton({
    super.key,
    required this.imagePath,
    required this.buttonText,
    required this.btn,
  });

  @override
  State<Loginbutton> createState() => _LoginbuttonState();
}

class _LoginbuttonState extends State<Loginbutton> {
  bool _isLogin = false;
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      throw Exception('Google Sign-In cancelled');
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void handleGoogle() async {
    try {
      UserCredential userCredential = await signInWithGoogle();
      _isLogin = true;
      userCredential.additionalUserInfo;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error $e")));
    }
    if (_isLogin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  void handleApple() {
    print("Handling apple auth");
  }

  void handleFb() {
    print("Handling fb auth");
  }

  void handlePhone() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Phonenumber()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          if (widget.btn == "google") {
            handleGoogle();
          } else if (widget.btn == "fb") {
            handleFb();
          } else if (widget.btn == "apple") {
            handleApple();
          } else {
            handlePhone();
          }
        },
        child: Center(
          child: Container(
            width: 320,
            height: 48,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(width: 2, color: Color(0xFF3BA7FF)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage(widget.imagePath)),
                const SizedBox(width: 15),
                Text(
                  widget.buttonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
