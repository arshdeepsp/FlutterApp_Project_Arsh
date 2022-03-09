enum ChatMessageType { text, content }
enum MessageStatus { not_sent, not_view, viewed }

class ChatMessage {
  final String text;
  final String id;
  final String groupId;
  final ChatMessageType messageType;
  final MessageStatus messageStatus;
  final bool isSender;
  final String? username;
  final String? userId;
  final String? profilePic;
  final String? image;
  final int? createdAt;

  ChatMessage(
      {required this.messageType,
      required this.id,
      required this.messageStatus,
      required this.isSender,
      required this.groupId,
      required this.createdAt,
      this.text = '',
      this.username,
      this.userId,
      this.profilePic,
      this.image});
}
