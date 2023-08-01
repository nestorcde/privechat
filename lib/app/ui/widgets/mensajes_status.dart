

import 'package:flutter/material.dart';
import 'package:privechat/app/utils/constants.dart';



class MessageStatusDot extends StatelessWidget {
  final int? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(int status) {
      switch (status) {
        case MensajeStatus.enviado:
          return Colors.grey;
        case MensajeStatus.leido:
          return Colors.greenAccent;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 10),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}