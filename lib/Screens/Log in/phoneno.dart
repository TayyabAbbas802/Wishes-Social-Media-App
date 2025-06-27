import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:wishes_social_media_app/Constants/Button.dart';

import 'verify phone no.dart';

class Phonenumber extends StatefulWidget {

  const Phonenumber({super.key});

  @override
  State<Phonenumber> createState() => _PhonenumberState();
}

class _PhonenumberState extends State<Phonenumber> {
  String fullPhoneNumber = '';
  final TextEditingController _phoneController = TextEditingController();
  void _sendCode() {
    String digitsOnly = fullPhoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check for international number length (10 to 15 digits is common)
    if (digitsOnly.length >= 10 && digitsOnly.length <= 15) {
      FirebaseAuth.instance.verifyPhoneNumber(
       phoneNumber: fullPhoneNumber,

        verificationCompleted: (_) {},

        verificationFailed: (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error $e")));
        },
        codeSent: (String verificationID, int? token) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Verifyphone(verificationId: verificationID),
            ),
          );
        },
        codeAutoRetrievalTimeout: (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error $e")));
        },
      );
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Invalid Number"),
              content: Text("Please enter a valid phone number."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: Image.asset("Images/Logo.png"),
        // ),
        title: Center(child: Image.asset("Images/Logo.png")),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Phone Number",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            IntlPhoneField(
              controller: _phoneController,
              initialCountryCode: 'PK', // or your preferred default
              decoration: InputDecoration(
                labelText: "Phone",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              onChanged: (phone) {
                setState(() {
                  fullPhoneNumber =
                      phone.completeNumber; // includes +countryCode
                });
              },
            ),
            Spacer(),
            Button(
              txt: "SEND CODE",
              onTap: () {
                _sendCode();
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
