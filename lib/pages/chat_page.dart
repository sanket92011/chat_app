import 'package:chatapp/constants.dart';
import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/pages/call_page.dart';
import 'package:chatapp/service/chat_services.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.name,
    required this.currentUserUid,
    required this.anotherUserUid,
    required this.isActive,
  });

  final String name;
  final String currentUserUid;
  final String anotherUserUid;
  final bool isActive;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String formattedTime = "";
  Timestamp lastActiveTime = Timestamp(1, 1);
  String currentUserName = '';
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late String roomId;
  bool isEmojiVisible = false;
  final ChatServices _chatServices = ChatServices();

  @override
  void initState() {
    super.initState();
    getUserName();
    roomId = ([widget.currentUserUid, widget.anotherUserUid]..sort()).join('_');
    _chatServices.updateSeenStatus(true, widget.currentUserUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage("https://wallpapercave.com/wp/wp14199731.jpg"),
          ),
        ),
        child: Column(
          children: [
            StreamBuilder(
                builder: (context, snapshot) {
                  Timestamp lastActiveTime =
                      snapshot.data?.data()!['lastActiveTime'] as Timestamp;
                  DateTime parsedDateTime = lastActiveTime.toDate();
                  formattedTime = DateFormat('hh:mm a').format(parsedDateTime);

                  return Container(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Stack(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.arrow_back_ios),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.name,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        snapshot.data!.data()!['isActive'] ==
                                                true
                                            ? "Online"
                                            : "Last seen at $formattedTime",
                                        style: const TextStyle(fontSize: 16),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              kIsWeb
                                  ? SizedBox()
                                  : Positioned(
                                      right: 1,
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CallPage(
                                                    callID: roomId,
                                                    userID:
                                                        widget.currentUserUid,
                                                    userName: currentUserName,
                                                  ),
                                                ));
                                          },
                                          icon: const Icon(Icons.call)),
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.anotherUserUid)
                    .snapshots()),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("chat_rooms")
                    .where('room_id', isEqualTo: roomId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No Chats yet!"));
                  }
                  final messages = snapshot.data!.docs;
                  messages.sort((a, b) {
                    return a['sent'].toDate().compareTo(b['sent'].toDate());
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController
                          .jumpTo(scrollController.position.maxScrollExtent);
                    }
                  });

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var doc = messages[index];
                      String uid = doc['uid'];
                      final messageFromUser = doc['message'];
                      final sentTime = doc['sent']?.toDate();
                      final formattedTime = sentTime != null
                          ? DateFormat('hh:mm a').format(sentTime)
                          : '';
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment:
                              uid == FirebaseAuth.instance.currentUser!.uid
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            ChatBubble(
                              clipper: ChatBubbleClipper5(
                                type: uid ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                              ),
                              alignment:
                                  uid == FirebaseAuth.instance.currentUser!.uid
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              backGroundColor:
                                  uid == FirebaseAuth.instance.currentUser!.uid
                                      ? const Color(0XFF005c4b)
                                      : const Color(0XFF202c33),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messageFromUser,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    formattedTime,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ],
                              ),
                              elevation: 10,
                              shadowColor: Colors.blue.shade50,
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              //dont change this
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Input Field Container
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // White background for the input field
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: TextField(
                        enableSuggestions: true,
                        canRequestFocus: true,
                        maxLines: 1,
                        cursorColor: const Color(0XFFF4770F),
                        controller: messageController,
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor),
                        decoration: InputDecoration(
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEmojiVisible = !isEmojiVisible;
                                });
                              },
                              child: const Icon(
                                Icons.emoji_emotions,
                                color: Color(0XFFF4770F),
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 15),
                          hintText: "Type your message...",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  // Send Button
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (messageController.text.isNotEmpty) {
                        _chatServices.sendMessage(
                          messageController.text.trim(),
                          roomId,
                          widget.currentUserUid,
                          scrollController,
                          DateTime.now(),
                        );
                        messageController.clear();
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Color(0XFFF4770F),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isEmojiVisible)
              EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  messageController.text += emoji.emoji; // Add emoji to text
                },
                textEditingController: messageController,
                config: const Config(),
              ),
          ],
        ),
      ),
    );
  }

  getUserName() async {
    return HelperFunction.getUserName().then((value) {
      setState(() {
        currentUserName = value!;
      });
    });
  }
}
