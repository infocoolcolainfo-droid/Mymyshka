import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final DateTime? timestamp;
  MessageBubble({required this.text, required this.isMe, this.timestamp});

  @override
  Widget build(BuildContext context) {
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isMe ? Colors.indigoAccent : Colors.grey[300];
    final textColor = isMe ? Colors.white : Colors.black87;
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
          child: Text(text, style: TextStyle(color: textColor)),
        ),
        if (timestamp != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              '${timestamp!.hour.toString().padLeft(2, '0')}:${timestamp!.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          )
      ],
    );
  }
}
