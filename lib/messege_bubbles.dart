import 'package:flutter/material.dart';

class MessegeBubbles extends StatelessWidget {
  const MessegeBubbles(this.messege, this.username, this.isMe, this.userImage,
      {super.key, required this.keyy});

  final String messege;
  final String username;
  final bool isMe;
  final Key keyy;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.amber : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(14),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(14),
                ),
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    messege,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned(
          top: -10,
          left: isMe ? 310 : null,
          right: !isMe ? 310 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],
    );
  }
}
