import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future updateUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'groups': [],
      'profilePic': "",
      'uid': uid
    });
  }

  ///getUserData
  Future getUserName(String email) async {
    try {
      QuerySnapshot snapshot =
          await userCollection.where("email", isEqualTo: email).get();
      return snapshot;
    } catch (e) {
      e.toString();
    }
  }

  ///deleteUserData
  Future deleteUserData(String userId) async {
    try {
      final collectionRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('sub_collection_name');
      var snapshots = await collectionRef.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      e.toString();
    }
  }

  ///getAllTheGroups

  ///fetchUse
}
