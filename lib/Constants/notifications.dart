import 'package:flutter/material.dart';

class CustomTile2 extends StatefulWidget {
  final String imageurl;
  final String title;
  final String subtitle;
  final String trailing;
  final bool showicon;

  const CustomTile2({
    super.key,
    required this.imageurl,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.showicon = false,
  });

  @override
  State<CustomTile2> createState() => _CustomTile2State();
}

class _CustomTile2State extends State<CustomTile2> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(widget.imageurl),
            radius: 24,
          ),
          if (widget.showicon)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mail,
                  size: 14,
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        widget.title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        widget.subtitle,
        style: const TextStyle(color: Color(0xff959595), fontSize: 13),
      ),
      trailing: Text(
        widget.trailing,
        style: const TextStyle(color: Color(0xff959595), fontSize: 13),
      ),

    );
  }
}
