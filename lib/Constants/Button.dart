import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String txt;
  final VoidCallback onTap; // <-- Add this

  const Button({
    super.key,
    required this.txt,
    required this.onTap, // <-- Make it required
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: widget.onTap, // <-- Use it here
        child: Container(
          width: 320,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFF3BA7FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              widget.txt,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
