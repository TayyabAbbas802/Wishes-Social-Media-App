import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment extends StatefulWidget {
  final String postId;
  const Comment({super.key, required this.postId});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  Future<void> _addComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _isSending = true);
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      // Add user info here if available
    });
    _controller.clear();
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: const Color(0xff3BA7FF),
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No comments yet.'));
                }
                final comments = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.person, color: Color(0xff3BA7FF)),
                        backgroundColor: Color(0xffeaf6ff),
                      ),
                      title: Text(
                        comment['text'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: comment['timestamp'] != null
                          ? Text(
                              (comment['timestamp'] as Timestamp)
                                  .toDate()
                                  .toLocal()
                                  .toString()
                                  .substring(0, 16),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      filled: true,
                      fillColor: const Color(0xffeaf6ff),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _isSending
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : IconButton(
                        icon: const Icon(Icons.send, color: Color(0xff3BA7FF)),
                        onPressed: _addComment,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}