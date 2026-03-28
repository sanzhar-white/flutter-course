import 'package:flutter/material.dart';
import '../constants.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.text,
    required this.sender,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 4.0, right: 4.0),
            child: Text(
              sender,
              style: AppTextStyles.senderText.copyWith(
                fontSize: 11.0,
              ),
            ),
          ),
          Material(
            elevation: 1.0,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16.0),
              topRight: const Radius.circular(16.0),
              bottomLeft:
                  isMe ? const Radius.circular(16.0) : const Radius.circular(0),
              bottomRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(16.0),
            ),
            color: isMe ? AppColors.myMessageColor : AppColors.otherMessageColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Text(
                text,
                style: AppTextStyles.messageText.copyWith(
                  color: isMe ? AppColors.white : AppColors.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
