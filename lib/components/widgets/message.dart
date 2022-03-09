import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripd_travel_app/models/chat_message.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';
import 'package:tripd_travel_app/theme/resources/layout_contants.dart';

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.message,
  }) : super(key: key);
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    print(message);
    return Padding(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(message.isSender
                  ? "Me"
                  : "@${message.username ?? "Anonymous"}:"),
              Text(DateFormat('hh:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(message.createdAt!)))
              //   Text(DateFormat('MM/dd/yyyy, hh:mm a').format(
              // DateTime.fromMillisecondsSinceEpoch(message.createdAt!)))
            ],
          ),
          SizedBox(height: defaultPadding / 3),
          Row(
            mainAxisAlignment: message.isSender
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: [
              if (!message.isSender) ...[
                CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("${message.profilePic}")),
                SizedBox(width: defaultPadding / 3),
                Expanded(
                    child: message.messageType == ChatMessageType.text
                        ? TextMessage(message: message)
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: color1.withOpacity(0.07),
                            ),
                            child: Row(
                              children: [
                                ContentMessage(message: message),
                                Spacer()
                              ],
                            ),
                          )),
              ],
              if (message.isSender) ...[
                Expanded(
                    child: message.messageType == ChatMessageType.text
                        ? TextMessage(message: message)
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: color1.withOpacity(0.07),
                            ),
                            child: Row(
                              children: [
                                Spacer(),
                                ContentMessage(message: message),
                              ],
                            ),
                          )),
                SizedBox(width: defaultPadding / 3),
                CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("${message.profilePic}"))
              ]
              // if (message.isSender) MessageStatusDot(status: message.messageStatus)
            ],
          )
        ],
      ),
    );
  }
}

class ContentMessage extends StatelessWidget {
  const ContentMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
              "${message!.isSender ? 'You' : message!.username} shared a ${message!.text}"),
          SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
                // "${validFeeds.elementAt(index)["object"]["${validFeeds!.elementAt(index)["feedType"]}Image"]}",
                message!.image ?? "",
                height: 100,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                      height: 100,
                      width: 150,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: Text('No image',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'CenturyGothic')),
                    )),
            // child: InkWell(onTap: onClicked),
          ),
        ],
      ),
    );
  }
}

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding * 0.75,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        message!.text,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_sent:
          return errorColor;
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return primaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: defaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        status == MessageStatus.not_sent ? Icons.close : Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
