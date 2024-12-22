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

  ///sendActiveServices
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
}
