import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'messege_bubbles.dart';

class Messeges extends StatelessWidget {
  const Messeges({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('sentAt', descending: true)
          .snapshots(),
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final docs = snapShot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (ctx, index) {
            final user = FirebaseAuth.instance.currentUser;
            return MessegeBubbles(
              docs[index]['text'],
              docs[index]['username'],
              docs[index]['userId'] == user!.uid,
              docs[index]['userImage'],
              keyy: ValueKey(docs[index].id),
            );
          },
        );
      },
    );
  }
}
