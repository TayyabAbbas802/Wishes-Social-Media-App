import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wishes_social_media_app/Screens/Home/Settings.dart';
import '../../util/Route_name.dart';
import 'package:wishes_social_media_app/Constants/Like.dart';
import 'package:wishes_social_media_app/Constants/app-assets.dart';
import 'package:wishes_social_media_app/Screens/Home/Edit profile.dart';

class OwnProfile extends StatefulWidget {
  const OwnProfile({super.key});

  @override
  State<OwnProfile> createState() => _OwnProfileState();
}

class _OwnProfileState extends State<OwnProfile> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String userName = "";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    if (currentUser != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .get();

      if (doc.exists && mounted) {
        setState(() {
          // Try both 'name' and 'username' for compatibility
          userName =
              doc.data()!['name'] ?? doc.data()!['username'] ?? "No Name";
        });
      }
    }
  }

  String timeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "Images/Vector (1).png",
            color: const Color(0xff3BA7FF),
          ),
        ),
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Info
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: const Color(0xff3BA7FF),
                        child: Text(
                          userName.isNotEmpty
                              ? userName.substring(0, 1).toUpperCase()
                              : '',
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userName.isNotEmpty ? userName : "No Name",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfile(),
                          ),
                        ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'Joined 25 Oct 2023',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),

            // User Posts Stream
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('posts')
                      .where('userId', isEqualTo: currentUser?.uid)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text('No posts yet.')),
                  );
                }

                final posts = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final text = post['text'] ?? '';
                    final mediaUrl = post['mediaUrl'];
                    final mediaType = post['mediaType'];
                    final postUserName = post['username'] ?? 'Anonymous';
                    final timestamp = post['timestamp'] as Timestamp?;
                    final postTime = timestamp?.toDate();
                    final formattedTime =
                        postTime != null ? timeAgo(postTime) : 'Just now';

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
                            // Post Header
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xff3BA7FF),
                                  radius: 25,
                                  child: Text(
                                    postUserName.isNotEmpty
                                        ? postUserName
                                            .substring(0, 1)
                                            .toUpperCase()
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      postUserName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      formattedTime,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Post Text
                            Text(
                              text,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Post Media
                            if (mediaUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    mediaType == 'image'
                                        ? Image.network(mediaUrl)
                                        : const Text('Video selected'),
                              ),
                            const SizedBox(height: 10),
                            // Post Actions
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
                                    Navigator.pushNamed(
                                      context,
                                      RouteName.Comments,
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
          ],
        ),
      ),
    );
  }
}
