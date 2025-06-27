import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wishes_social_media_app/Users/Users.dart';
import 'Like.dart';
import 'profileSCRe.dart';

import 'package:wishes_social_media_app/Constants/Comments.dart';

import 'create_post.dart';
import 'package:wishes_social_media_app/Constants/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedTabBottom = 0;

  final List<Widget> _bottomTabBodies = [
    HomeFeed(),
    UsersListScreen(),
    const CreatePostScreen(),
    OwnProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomTabBodies[selectedTabBottom], // AppBar removed here
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: selectedTabBottom == 0 ? Colors.black : Colors.grey,
              onPressed: () => setState(() => selectedTabBottom = 0),
            ),
            IconButton(
              icon: const Icon(Icons.archive),
              color: selectedTabBottom == 1 ? Colors.black : Colors.grey,
              onPressed: () => setState(() => selectedTabBottom = 1),
            ),
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              color: selectedTabBottom == 2 ? Colors.black : Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePostScreen(),
                  ),
                ).then((_) => setState(() => selectedTabBottom = 0));
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: selectedTabBottom == 3 ? Colors.black : Colors.grey,
              onPressed: () => setState(() => selectedTabBottom = 3),
            ),
          ],
        ),
      ),
    );
  }
}

// HomeFeed now has its own Scaffold and AppBar
class HomeFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "Images/Vector (1).png",
            color: const Color(0xff3BA7FF),
          ),
        ),
        title: Row(
          children: [
            Text(
              "For you",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              "Following",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
        elevation: 1,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Search()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance
                .collection('posts')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts yet.'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final text = post['text'] ?? '';
              final mediaUrl = post['mediaUrl'];
              final mediaType = post['mediaType'];
              final username = post['username'] ?? 'User';

              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(child: Icon(Icons.person)),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                "Just now",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (mediaUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:
                              mediaType == 'image'
                                  ? Image.network(mediaUrl)
                                 : const Text('Video support coming soon'),
                        ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LikeButton(
                            isliked: false,
                            likecount: 0,
                            onTap: () {},
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.comment),
                            label: const Text('Comment'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Comment(
                                        postId: post.id,
                                      ), // pass the postId here
                                ),
                              );
                            },
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
