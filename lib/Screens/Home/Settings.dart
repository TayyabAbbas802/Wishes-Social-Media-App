import 'package:flutter/material.dart';
import 'package:wishes_social_media_app/Constants/Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wishes_social_media_app/Screens/Log in/login.dart'; // Adjust this to your actual login screen import


import 'package:wishes_social_media_app/Constants/app-assets.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool emailNotifications = false;
  bool pushNotifications = true;
  bool commentNotifications = false;
  bool likesNotifications = false;
  bool privateAccount = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Settings'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(AppAssets.Icon),
        ),
      ),
      body: ListView(
        children: [
          Divider(height: 5,),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Notification Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 5,),

          SwitchListTile(
            title: Text('Email Notifications',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600),),
            value: emailNotifications,
            onChanged: (bool value) {
              setState(() {
                emailNotifications = value;
              });
            },
          ),Divider(height: 5,),
          SwitchListTile(
            title: Text('Push Notifications',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600),),
            value: pushNotifications,
            onChanged: (bool value) {
              setState(() {
                pushNotifications = value;
              });
            },
          ),
          Divider(height: 5,),
          SwitchListTile(
            title: Text('Comment Notifications',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700),),
            value: commentNotifications,
            onChanged: (bool value) {
              setState(() {
                commentNotifications = value;
              });
            },
          ),
          Divider(height: 5,),
          SwitchListTile(
            title: Text('Likes Notifications',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700),),
            value: likesNotifications,
            onChanged: (bool value) {
              setState(() {
                likesNotifications = value;
              });
            },
          ),
          Divider(height: 5,),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Privacy Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 5,),
          SwitchListTile(
            title: Text('Private Account',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w700),),
            value: privateAccount,
            onChanged: (bool value) {
              setState(() {
                privateAccount = value;
              });
            },
          ),
          Divider(height: 5,),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Privacy & Terms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 5,),
          ListTile(
            title: Text('Privacy Policy',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600),),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>Privacypolicy()));
            },
          ),
          Divider(height: 5,),
          ListTile(
            title: Text('Terms of Use',style: TextStyle(color: Colors.black,fontWeight:FontWeight.w600),),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
            //  Navigator.push(context, MaterialPageRoute(builder: (context)=>TermofUse()));
            },
          ),

          SizedBox(height: 10),
        Button(
  txt: "LOG OUT",
  onTap: () async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Loginoptions()), // Change to your actual login screen
      (Route<dynamic> route) => false,
    );
  },
),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
