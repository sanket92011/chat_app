import 'dart:math';

import 'package:chatapp/service/chat_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController textEditingController = TextEditingController();
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Users"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ValueListenableBuilder<TextEditingValue>(
        valueListenable: textEditingController,
        builder: (context, value, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: "Search by name",
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('uid',
                          isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "No users",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }

                    final searchQuery =
                        textEditingController.text.toLowerCase();
                    final users = snapshot.data!.docs.where((doc) {
                      final name = (doc['name'] ?? '').toString().toLowerCase();
                      return searchQuery.isEmpty ||
                          name.startsWith(searchQuery);
                    }).toList();

                    if (users.isEmpty) {
                      return const Center(
                        child: Text(
                          "Not found",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final userDoc = users[index];
                        final name = userDoc['name'] ?? 'Unknown User';
                        final userId = userDoc['uid'] ?? '';
                        final profilePic = userDoc['profilePic'] ?? '';

                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUserUid)
                              .snapshots(),
                          builder: (context, groupSnapshot) {
                            final groups = groupSnapshot.data?['groups'] ?? [];
                            final isAdded = groups.contains(userId);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    print(userId);
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        profilePic.isNotEmpty
                                            ? profilePic
                                            : "https://via.placeholder.com/150",
                                      ),
                                      radius: 25,
                                    ),
                                    title: Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed: isAdded
                                          ? () {
                                              ChatServices().removeFromArray(
                                                  currentUserUid,
                                                  userId,
                                                  userId);
                                            }
                                          : () {
                                              print(userId);
                                              ChatServices().addToGroupArray(
                                                  currentUserUid,
                                                  userId,
                                                  userId);
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isAdded
                                            ? Colors.grey
                                            : const Color(0XFFF4770F),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        isAdded ? "Remove" : "Add",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
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
            ],
          );
        },
      ),
    );
  }
}
