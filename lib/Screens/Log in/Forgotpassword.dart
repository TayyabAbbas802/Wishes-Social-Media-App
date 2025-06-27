import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wishes_social_media_app/Constants/Button.dart';
import 'package:wishes_social_media_app/Constants/CustomTextField.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: SizedBox(height: 150)),
              Image(image: AssetImage('Images/Group 1.png')),
              SizedBox(height: 120),
              Center(
                child: Text(
                  "Forgot Password?",
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
              SizedBox(height: 60),
              Button(
                txt: "RESET PASSWORD",
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    try{
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: _emailController.text.trim(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please check your email")));
                    } on FirebaseAuthException catch (e){
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error $e")));
                    } catch (e){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error $e")));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
