class Member {
  String? id;
  String? username;
  String? profilePic;
  String? status;

  Member({this.id, this.username, this.profilePic, this.status});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        id: json['id'],
        username: json['username'],
        profilePic: json['profilePic'],
        status: json['status']);
  }
}
