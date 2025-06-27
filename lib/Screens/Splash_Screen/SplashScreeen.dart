import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wishes_social_media_app/Screens/Home/Home.dart';
import 'package:wishes_social_media_app/Screens/Log%20in/LogIn.dart';
import 'package:flutter/material.dart';

class Splashscreeen extends StatefulWidget {
  const Splashscreeen({super.key});

  @override
  State<Splashscreeen> createState() => _SplashscreeenState();
}

class _SplashscreeenState extends State<Splashscreeen> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Loginoptions()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3BA7FF),
      body: Center(
        child: Image(
          image: AssetImage('Images/Group 1 (1).png'),
          width: 168,
          height: 72.7,
        ),
      ),
    );
  }
}
