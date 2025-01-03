import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatServices {
  ///sendLastActiveStatus
  sendLastActiveTime(String userUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .update({'lastActiveTime': DateTime.now()});
  }

  ///sendMessage
  sendMessage(
    String message,
    String roomId,
    String uid,
    ScrollController scrollController,
    DateTime sent,
  ) async {
    if (message.isEmpty) return;
    await FirebaseFirestore.instance.collection("chat_rooms").add({
      "message": message,
      "room_id": roomId,
      'uid': uid,
      "sent": DateTime.now(),
    });
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  ///sendLastMessage
  sendLastMessage(
    String message,
  ) async {
    if (message.isEmpty) return;
    await FirebaseFirestore.instance.collection("chat_rooms").add({
      "lastMessage": message,
      "sent": DateTime.now(),
    });
    return message;
  }

  ///sendActiveStatus
  sendActiveStatus(String uid, bool isActive) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({"isActive": isActive});
  }

  ///updateSeenStatus
  updateSeenStatus(bool isMessageStatus, String currentUserUid) async {
    await FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(currentUserUid)
        .update({'seen': isMessageStatus, "currentUserUid": currentUserUid});
  }

  ///fetchLastSeenMessage
  Future<String> fetchLastSentMessage(String roomId) async {
    try {
      // Query the messages in the chat_rooms collection directly
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('room_id', isEqualTo: roomId)
          .orderBy('sent', descending: true) // Order by timestamp
          .limit(1)
          .get();
      print(querySnapshot);

      // Check if messages exist
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['message'] ?? "No messages yet";
      } else {
        return "No messages yet";
      }
    } catch (e) {
      // Handle errors gracefully
      return "Error fetching message";
    }
  }

  ///addToGroupsArray
  addToGroupArray(String currentUserUid, String userIdToAdd,
      String anotherUserIdToAdd) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .update({
      'groups': FieldValue.arrayUnion([userIdToAdd]),
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(anotherUserIdToAdd)
        .update({
      'groups': FieldValue.arrayUnion([currentUserUid]),
    });
  }

  ///removeUser
  removeFromArray(String currentUserUid, String userIdToRemove,
      String anotherUserIdToRemove) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .update({
      'groups': FieldValue.arrayRemove([userIdToRemove]),
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(anotherUserIdToRemove)
        .update({
      'groups': FieldValue.arrayRemove([currentUserUid]),
    });
  }
}
