import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String fieldType;
  const CustomInputField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    required this.fieldType,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validate(String? value) {
  if (value == null || value.isEmpty) {
    return "Enter value in field";
  }

  if (widget.fieldType == 'email') {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
  }

  if (widget.fieldType == 'password') {
    final passRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)');
    if (value.length < 8) {
      return "Enter at least 8 characters";
    }
    if (!passRegex.hasMatch(value)) {
      return "Password must include letters and numbers";
    }
  }

  return null;
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 30, left: 30),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        validator: _validate,
          keyboardType: widget.fieldType == 'email'
      ? TextInputType.emailAddress
      : TextInputType.text,
        decoration: InputDecoration(
          hintText: widget.hintText,
          fillColor: Colors.grey.shade100,
          filled: true,
          prefixIcon: Icon(widget.icon),
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _toggleVisibility,
                  )
                  : null,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade100),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade100),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
