import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/pages/drawer.dart';
import 'package:chatapp/pages/search_page.dart';
import 'package:chatapp/service/chat_services.dart';
import 'package:chatapp/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatServices _chatServices = ChatServices();
  late String roomId;
  String currentUserUid = '';
  String anotherUserUid = '';
  bool isActive = false;

  @override
  void initState() {
    _chatServices.sendActiveStatus(
        FirebaseAuth.instance.currentUser!.uid, true);
    _chatServices.sendLastActiveTime(FirebaseAuth.instance.currentUser!.uid);
    roomId = ([currentUserUid, anotherUserUid]..sort()).join('_');

    super.initState();
  }

  final AdvancedDrawerController drawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      openRatio: kIsWeb ? 0.29 : 0.50,
      openScale: 1,
      rtlOpening: false,
      controller: drawerController,
      backdropColor: const Color(0XFFF4770F),
      drawer: const SideDrawer(),
      animationCurve: Curves.easeInOut,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              drawerController.showDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
          ],
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Chats",
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return Future(
              () {},
            );
          },
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!userSnapshot.hasData || userSnapshot.data == null) {
                return const Center(
                  child: Text(
                    "No Chats Available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              List<String> groups =
                  List<String>.from(userSnapshot.data!['groups'] ?? []);

              if (groups.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchPage(),
                              ));
                        },
                        icon: const Icon(
                          Icons.person_add_alt_1,
                          size: 80,
                          color: Colors.grey,
                        ),
                        tooltip: 'Add People',
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "No people added yet!",
                        style: TextStyle(
                          fontFamily: "Jua-Regular",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Tap the button above to add new connections",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
                // return const Center(child: CircularProgressIndicator());
              }

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('uid',
                        whereIn: groups) // Fetch users whose uid is in groups
                    .snapshots(),
                builder: (context, usersSnapshot) {
                  if (usersSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!usersSnapshot.hasData ||
                      usersSnapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Chats Available",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  final docs = usersSnapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final name = doc['name'];
                      final profileUrl = doc['profilePic'];
                      final isActive = doc['isActive'];
                      final anotherUserUid = doc['uid'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                isActive: isActive,
                                anotherUserUid: anotherUserUid,
                                currentUserUid:
                                    FirebaseAuth.instance.currentUser!.uid,
                                name: name,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        profileUrl.isEmpty
                                            ? "https://images.pexels.com/photos/14653174/pexels-photo-14653174.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
                                            : profileUrl,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 1,
                                      right: 1,
                                      child: CircleAvatar(
                                        backgroundColor: isActive == true
                                            ? Colors.green
                                            : Colors.transparent,
                                        radius: 8,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
