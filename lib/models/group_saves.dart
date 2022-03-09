enum GroupSavesType { Plan, Offering, Collection }

class GroupSave {
  final String id;
  final String groupId;
  final bool isSender;
  final String? username;
  final String? userId;
  final String? profilePic;
  final String? image;
  final int? createdAt;
  final GroupSavesType type;
  final content;

  GroupSave(
      {required this.id,
      required this.isSender,
      required this.groupId,
      required this.createdAt,
      required this.type,
      required this.content,
      this.username,
      this.userId,
      this.profilePic,
      this.image});
}
