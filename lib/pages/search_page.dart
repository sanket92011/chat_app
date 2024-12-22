import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            SizedBox(
              width: 200,
              child: SearchBar(
                controller: textEditingController,
              ),
            )
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: textEditingController,
          builder: (context, value, child) {
            return StreamBuilder<QuerySnapshot>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var name = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    if (textEditingController.text.toString().isEmpty) {
                      return ListTile(
                        title: Text(name['name']),
                      );
                    }
                    if (name['name'].toString().toLowerCase().startsWith(
                        textEditingController.text.toString().toLowerCase())) {
                      return ListTile(
                        title: Text(name['name']),
                      );
                    }
                    return Container();
                  },
                );
              },
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
            );
          },
        ));
  }
}
