

import 'package:flutter/material.dart';
import 'package:wishes_social_media_app/Constants/Button.dart';


import 'package:wishes_social_media_app/Constants/app-assets.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String selectedGender = "Select Gender";
  final GlobalKey _buttonKey = GlobalKey();
  TextEditingController namecontrollor = TextEditingController();
  TextEditingController emailcontoller = TextEditingController();

  DateTime? selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "Images/Vector (1).png",
            color: const Color(0xff3BA7FF),
          ),
        ),
        title: Text("Edit Profile"),
        backgroundColor: Color(0xffFFFFFF),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Divider(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(AppAssets.Profileimage),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Change Photo",
                style: TextStyle(color: Color(0xff3BA7FF)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Your name",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 10,
                bottom: 10,
              ),
              child: TextFormField(
                controller: namecontrollor,

                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: "Jessica Milan",
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Color(0xffdfdfdf)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Color(0xffdfdfdf)),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Email",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 10,
                bottom: 10,
              ),
              child: TextFormField(
                controller: emailcontoller,

                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  hintText: "Jessicamilan@gmail.com",
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Color(0xffdfdfdf)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: Color(0xffdfdfdf)),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Gender",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Center(
              child: SizedBox(
                width: 340,
                height: 59,
                child: ElevatedButton(
                  key: _buttonKey,
                  onPressed: () async {
                    final RenderBox button =
                        _buttonKey.currentContext!.findRenderObject()
                            as RenderBox;
                    final Offset position = button.localToGlobal(Offset.zero);
                    final double left = position.dx;
                    final double top = position.dy + button.size.height;

                    final String? gender = await showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        left,
                        top,
                        left + button.size.width,
                        0,
                      ),
                      items: [
                        PopupMenuItem(value: 'Male', child: Text('Male')),
                        PopupMenuItem(value: 'Female', child: Text('Female')),
                      ],
                    );

                    if (gender != null) {
                      setState(() {
                        selectedGender = gender;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide(color: Color(0xffdfdfdf)),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedGender,
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Date of Birth",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: SizedBox(
                height: 49,
                width: 340,
                child: ElevatedButton(
                  onPressed: () async {
                    ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                    );
                    DateTime today = DateTime.now();
                    DateTime initialDate = DateTime(
                      today.year - 18,
                      today.month,
                      today.day,
                    ); // Fixed
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: today,
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Text(
                    selectedDate == null
                        ? "MM/DD/YYYY"
                        : "${selectedDate!.month.toString().padLeft(2, '0')}/"
                            "${selectedDate!.day.toString().padLeft(2, '0')}/"
                            "${selectedDate!.year}",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Bio",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                right: 30,
                left: 30,
                top: 10,
                bottom: 10,
              ),
              child: Container(
                height: 120, // Adjust height as needed
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter here',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Button(txt: "SAVE", onTap: () {}),
          ],
        ),
      ),
    );
  }
}
