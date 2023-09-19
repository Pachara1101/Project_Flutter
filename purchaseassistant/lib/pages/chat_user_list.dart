import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ListUserchat extends StatefulWidget {
  const ListUserchat({super.key});

  @override
  State<ListUserchat> createState() => _ListUserchatState();
}

class _ListUserchatState extends State<ListUserchat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestrore = FirebaseFirestore.instance;
  String uid = "";

  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายการผู้ใช้งาน"),
      ),
      body: _buildShowUser(),
    );
  }

  Widget _buildShowUser() {
    return StreamBuilder(
      stream: _firestrore.collection('userProfile').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Center(
            child: Text("${snapshot.error}"),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((docs) => _listUser(docs)).toList(),
        );
      },
    );
  }

  Widget _listUser(DocumentSnapshot docs){
    Map<String, dynamic> data = docs.data() as Map<String, dynamic>;
    print("id: ${docs.id}");
    print("uid: ${uid}");
    if(uid != docs.id){
      return ListTile(
        title: Text(data['name']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(reciveuid: docs.id, name: data["name"],
                
              )
            )
          );
        },
      );
    }
    else {
      return Container(child: Text("No user online"),);
    }

  }
}