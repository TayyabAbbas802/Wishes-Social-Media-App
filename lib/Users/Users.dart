import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wishes_social_media_app/Screens/Home/ChatScreen.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});
  String getChatId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    return ids.join('_');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Image(image: AssetImage('Images/Inbox.png'), width: 50),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs
              .where((doc) => doc.id != user?.uid)
              .toList();
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    (data['name'] ?? 'N')
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),
                  ),
                ),
                title: Text(data['name'] ?? 'No Name'),
                subtitle: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(getChatId(user!.uid, data.id))
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .limit(1)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No messages yet');
                    }
                    final doc = snapshot.data!.docs.first;
                    final messageData = doc.data() as Map<String, dynamic>;
                    String lastMsg = '';
                    bool isSentByMe = messageData['sender'] == user.uid;
                    if (messageData.containsKey('message') &&
                        (messageData['message'] as String).trim().isNotEmpty) {
                      lastMsg = messageData['message'];
                    } else if (messageData.containsKey('imageUrl')) {
                      lastMsg = '📷 Image';
                    } else if (messageData.containsKey('videoUrl')) {
                      lastMsg = '🎥 Video';
                    } else {
                      lastMsg = 'Unsupported message';
                    }
                    return Text(
                      isSentByMe ? 'You: $lastMsg' : lastMsg,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        peerId: data.id,
                        peerName: data['name'] ?? 'No Name',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
