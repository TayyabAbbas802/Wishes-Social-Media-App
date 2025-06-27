import 'package:flutter/material.dart';
class LikeButton extends StatelessWidget {
  final bool isliked;
  final int likecount;
  final VoidCallback onTap;
  const LikeButton({super.key,required this.isliked,required this.likecount,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onTap, icon: Icon(isliked?Icons.favorite_outline:Icons.favorite_border,
        color: isliked?Colors.red:Colors.grey)),
        SizedBox(width: 3,),
        Text("$likecount",style: TextStyle(color: isliked ? Colors.red : Colors.grey,
          fontWeight: FontWeight.bold,
        ),),

      ],


    );
    
  }
}

