import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 305,
        decoration: BoxDecoration(
          color: const Color(0xff3BA7FF),
          borderRadius: BorderRadius.circular(28),),

        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,

            ),
          ),
        ),
      ),
    );
  }
}


