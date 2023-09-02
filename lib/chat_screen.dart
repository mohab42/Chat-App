// ignore_for_file: avoid_unnecessary_containers

import 'package:backend/messeges.dart';
import 'package:backend/new_messeges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const route = 'chat';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
        actions: [
          DropdownButton(
              items: const [
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Text('Logout'),
                      Icon(Icons.exit_to_app),
                    ],
                  ),
                )
              ],
              onChanged: (item) {
                FirebaseAuth.instance.signOut();
              })
        ],
      ),
      body: Container(
        child: const Column(
          children: [
            Expanded(
              child: Messeges(),
            ),
            NewMesseges(),
          ],
        ),
      ),
    );
  }
}
