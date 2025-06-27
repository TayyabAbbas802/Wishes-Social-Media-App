import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wishes_social_media_app/Constants/Button.dart';
import 'package:wishes_social_media_app/Constants/CustomTextField.dart';
import 'package:wishes_social_media_app/Screens/Log in/LogIn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? _selectedGender;
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedGender = null; // This resets the gender selection on hot reload
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  Widget _buildGenderButton(String gender) {
    final bool isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () => _selectGender(gender),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: isSelected ? Color(0xFF3BA7FF) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          gender,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Center(
                      child: Image(
                        image: AssetImage('Images/Logo.png'),
                        width: 52,
                        height: 35,
                        color: Color(0xFF3BA7FF),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          fontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      icon: Icons.person,
                      hintText: "Enter Full Name",
                      controller: _nameController,
                      fieldType: 'text',
                    ),
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
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "What's Your Gender?",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildGenderButton('Male'),
                          _buildGenderButton('Female'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        "Your Date of Birth?",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _dobController,
                            decoration: InputDecoration(
                              hintText: "DD/MM/YYYY",
                              suffixIcon: Icon(Icons.arrow_drop_down),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Button(
                      txt: "SIGN UP",
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedGender == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select your gender"),
                              ),
                            );
                            return;
                          }
        
                          if (_dobController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select your date of birth"),
                              ),
                            );
                            return;
                          }
        
                          try {
                            // 1. Create user with email and password
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
        
                            // 2. Store additional user info in Firestore
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userCredential.user!.uid)
                                .set({
                                  'name': _nameController.text.trim(),
                                  'email': _emailController.text.trim(),
                                  'dob': _dobController.text.trim(),
                                  'gender': _selectedGender,
                                  'createdAt': Timestamp.now(),
                                });
        
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Sign up successful!"),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Loginoptions(),
                              ),
                            );
        
                            // TODO: Navigate to home screen
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${e.message}")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Unexpected error: $e")),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
