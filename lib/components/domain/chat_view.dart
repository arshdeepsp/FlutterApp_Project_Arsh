import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/components/widgets/chat_date_seperator.dart';
import 'package:tripd_travel_app/components/widgets/message.dart';
import 'package:tripd_travel_app/services/auth_service.dart';
import 'package:tripd_travel_app/services/socket_service.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';
import 'package:tripd_travel_app/theme/resources/custom_scroll_behaviour.dart';
import 'package:tripd_travel_app/theme/resources/layout_contants.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key, required this.groupId}) : super(key: key);
  final String groupId;
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController msgController = TextEditingController();

  getAllGroupMessages() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    final socketService = Provider.of<SocketService>(context, listen: false);
    await socketService.getAllMessages(token: idToken, groupId: widget.groupId);
  }

  markAsRead() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    final socketService = Provider.of<SocketService>(context, listen: false);
    await socketService.markAsRead(token: idToken, groupId: widget.groupId);
  }

  void sendMessage() async {
    final socket = Provider.of<SocketService>(context, listen: false);
    var message = msgController.text;
    if (message.isEmpty) return;
    final auth = Provider.of<AuthService>(context, listen: false);
    var idToken = await auth.currentUser!.getIdToken();
    socket.sendMessage(msg: message, groupId: widget.groupId, token: idToken);
    msgController.clear();
  }

  @override
  void initState() {
    getAllGroupMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Consumer<SocketService>(
            builder: (_, socketNotifier, __) {
              markAsRead();
              print("Rerenderinggggggggggggggggg");
              if (!socketNotifier.fetchedGroupChats
                  .containsKey(widget.groupId)) {
                return Container();
              }
              var validMessages = socketNotifier
                  .fetchedGroupChats[widget.groupId]
                  .where((message) =>
                      message.groupId == widget.groupId && message.text != null)
                  .toList();

              // print("all messages");
              // print(socketNotifier.fetchedGroupChats[widget.groupId].length);
              // print("new valid messages");
              // print(validMessages.length);
              if (validMessages.length == 0) return Container();

              DateTime lastDate = DateTime.fromMillisecondsSinceEpoch(
                  validMessages[0].createdAt);

              return ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    // print(validMessages[index].createdAt.toString());
                    if (index == validMessages.length - 1) {
                      return ChatDateSeperator(date: lastDate);
                    }
                    DateTime date = DateTime.fromMillisecondsSinceEpoch(
                        validMessages[index].createdAt);
                    if (!isSameDate(lastDate, date)) {
                      lastDate = date;
                      return ChatDateSeperator(date: lastDate);
                    }
                    return SizedBox();
                  },
                  reverse: true,
                  padding: EdgeInsets.fromLTRB(
                      defaultPadding, 15, defaultPadding, 15),
                  itemCount: validMessages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == validMessages.length) {
                      return SizedBox();
                    }
                    return Message(
                        key: Key(validMessages[index].isSender
                            ? validMessages[index].id + index.toString()
                            : validMessages[index].id),
                        message: validMessages[index]);
                  },
                ),
              );
            },
          ),
        )),
        const Divider(
          height: 0,
          thickness: 1,
        ),
        ChatInputField(msgController: msgController),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
          child: Container(
            height: 30,
            width: 75,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: color1,
              child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: sendMessage,
                  child: Container(
                    alignment: Alignment.center,
                    child: CenturyGothicText(
                      data: 'Send',
                      fontSize: 15,
                      textColor: Colors.white,
                    ),
                  )),
            ),
          ),
        ),
      ]),
    );
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({Key? key, required this.msgController})
      : super(key: key);
  final TextEditingController msgController;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding / 2,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Icon(Icons.mic, color: kPrimaryColor),
            // SizedBox(width: defaultPadding),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    TextField(
                      minLines: 4,
                      maxLines: 20,
                      controller: msgController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        hintText: "Type message",
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool isSameDate(DateTime compareWith, DateTime compareTo) {
  return compareWith.year == compareTo.year &&
      compareWith.month == compareTo.month &&
      compareWith.day == compareTo.day;
}
