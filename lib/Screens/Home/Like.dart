import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool isliked;
  final int likecount;
  final VoidCallback? onTap;

  const LikeButton({
    Key? key,
    this.isliked = false,
    this.likecount = 0,
    this.onTap,
  }) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isliked;
    _likeCount = widget.likecount;
  }

  void _handleTap() {
    setState(() {
      if (_isLiked) {
        _isLiked = false;
        _likeCount--;
      } else {
        _isLiked = true;
        _likeCount++;
      }
    });
    if (widget.onTap != null) widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : Colors.grey,
          ),
          onPressed: _handleTap,
        ),
        Text('$_likeCount'),
      ],
    );
  }
}