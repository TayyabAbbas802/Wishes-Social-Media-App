import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:wishes_social_media_app/Constants/Button.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  File? _mediaFile;
  String? _mediaType;
  bool _isLoading = false;

  Future<void> pickMedia(ImageSource source, String type) async {
    final picker = ImagePicker();
    final picked = await (type == 'image'
        ? picker.pickImage(source: source)
        : picker.pickVideo(source: source));

    if (picked != null) {
      setState(() {
        _mediaFile = File(picked.path);
        _mediaType = type;
      });
    }
  }

  Future<void> uploadPost() async {
    if (_textController.text.trim().isEmpty && _mediaFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser!;
      String? mediaUrl;

      // 🔽 Fetch user's name from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final username = userDoc.data()?['name'] ?? 'Anonymous';

      if (_mediaFile != null) {
        final fileName = const Uuid().v4();
        final ref = FirebaseStorage.instance
            .ref()
            .child('post_media')
            .child('$fileName.${_mediaType == 'image' ? 'jpg' : 'mp4'}');

        await ref.putFile(_mediaFile!);
        mediaUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('posts').add({
        'userId': user.uid,
        'username': username, // ✅ Using Firestore name
        'text': _textController.text.trim(),
        'mediaUrl': mediaUrl,
        'mediaType': _mediaType,
        'timestamp': FieldValue.serverTimestamp(),
        'likes': [],
        'comments': [],
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload post: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Create Post",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              fontSize: 20,
            ),
          ),
        ),
        leading: Image.asset(
          'Images/Vector (1).png',
          width: 50,
          height: 50,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'What\'s on your mind?',
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_mediaFile != null)
                      _mediaType == 'image'
                          ? Image.file(_mediaFile!, height: 150)
                          : const Text('Video Selected'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.image),
                          label: const Text('Image'),
                          onPressed: () =>
                              pickMedia(ImageSource.gallery, 'image'),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.videocam),
                          label: const Text('Video'),
                          onPressed: () =>
                              pickMedia(ImageSource.gallery, 'video'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 300),
                    Button(txt: "POST", onTap: uploadPost),
                  ],
                ),
              ),
            ),
    );
  }
}
