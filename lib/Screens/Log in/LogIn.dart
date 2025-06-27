import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wishes_social_media_app/Constants/Button.dart';
import 'package:wishes_social_media_app/Screens/Log in/Forgotpassword.dart';
import 'package:wishes_social_media_app/Screens/Home/Home.dart';

import 'package:wishes_social_media_app/Screens/Sign up/SignUp.dart';
import 'package:wishes_social_media_app/Constants/CustomTextField.dart';
import 'LoginButton.dart';

class Loginoptions extends StatefulWidget {
  const Loginoptions({super.key});

  @override
  State<Loginoptions> createState() => _LoginoptionsState();
}

class _LoginoptionsState extends State<Loginoptions> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: SizedBox(height: 100)),
              Image(image: AssetImage('Images/Group 1.png')),
              SizedBox(height: 50),
              Center(
                child: Text(
                  "Welcome to Wishes",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                  ),
                ),
              ),

              SizedBox(height: 10),
              CustomInputField(
                icon: Icons.email_outlined,
                hintText: "Email",
                controller: _emailController,
                fieldType: 'email',
              ),
              CustomInputField(
                icon: Icons.password_outlined,
                hintText: "Password",
                obscureText: true,
                controller: _passwordController,
                fieldType: 'password',
              ),
              Row(
                children: [
                  SizedBox(width: 200),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPassword(),
                        ),
                      );
                    },
                    child: Text(
                      "Forget Password ?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              Text(
                "OR",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 5),
              Loginbutton(
                imagePath: 'Images/Group 2618.png',
                buttonText: "Log in using Google",
                btn: "google",
              ),
              Loginbutton(
                imagePath: 'Images/Vector.png',
                buttonText: "Log in using Phone",
                btn: "phone",
              ),
              SizedBox(height: 100),
              Button(
                txt: "LOG IN",
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Log in Succesful")),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error $e")));
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error $e")));
                    }
                  }
                },
              ),
              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: const TextStyle(
                        color: Color(0xFF3BA7FF),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Handle navigation or logic
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                              // For example: Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
