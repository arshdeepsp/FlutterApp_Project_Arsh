import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatDateSeperator extends StatelessWidget {
  const ChatDateSeperator({Key? key, required this.date}) : super(key: key);
  final DateTime date;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 2, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(DateFormat.yMMMEd().format(date)),
          ),
          Expanded(child: Divider(thickness: 2, color: Colors.grey)),
        ],
      ),
    );
  }
}
