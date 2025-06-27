import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wishes_social_media_app/Constants/Button.dart';
import 'package:wishes_social_media_app/Screens/Home/Home.dart';


class Verifyphone extends StatefulWidget {
  final String verificationId;
  const Verifyphone({super.key, required this.verificationId});

  @override
  State<Verifyphone> createState() => _VerifyphoneState();
}

class _VerifyphoneState extends State<Verifyphone> {
  TextEditingController otpcontollor = TextEditingController();
  String entercode = "";
  void _verifycode() async{
    if (entercode.length == 6) {
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpcontollor.text.toString(),
      );
      try{
      await FirebaseAuth.instance.signInWithCredential(credential);
          Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
      } catch(e){
                  ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error $e")));
      }
  
    } else {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Inavlid number"),
              content: Text("enter valid 6 digit digit"),

              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("ok"),
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
        // leading: IconButton(onPressed: (

        //     ){
        //   Navigator.pop(context);
        // }, icon:Image.asset("assets/pic/Icon.png")
        // ),
        title: Center(child: Image(image: AssetImage("Images/Logo.png"))),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Verify Phone",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            PinCodeTextField(
              controller: otpcontollor,
              keyboardType: TextInputType.number,
              appContext: context,
              length: 6,
              onChanged: (value) {
                entercode = value;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                activeColor: Colors.white,
                selectedColor: Colors.black,
                inactiveColor: Colors.grey,
                borderWidth: 1,
              ),
            ),
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                otpcontollor.clear();
                setState(() {
                  entercode = "";
                });
              },
              label: Text("Refresh"),
              icon: Icon(Icons.refresh, color: Color(0xff000000)),
            ),
            SizedBox(height: 450),
            Button(
              txt: "VERIFY",
              onTap: () {
                _verifycode();
              },
            ),
          ],
        ),
      ),
    );
  }
}
