import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMesseges extends StatefulWidget {
  const NewMesseges({super.key});

  @override
  State<NewMesseges> createState() => _NewMessegesState();
}

class _NewMessegesState extends State<NewMesseges> {
  final controller = TextEditingController();
  String enteredMessege = '';

  sendMesseg() async {
    FocusScope.of(context).unfocus();
    //Sending Messeges Logic
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessege,
      'sentAt': Timestamp.now().toString(),
      'username': userData['username'],
      'userId': user.uid,
      'userImage': userData['image_url'],
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Send Messege...',
              ),
              controller: controller,
              onChanged: (val) {
                setState(() {
                  enteredMessege = val;
                });
              },
            ),
          ),
          IconButton(
              onPressed: enteredMessege.trim().isEmpty ? null : sendMesseg,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
