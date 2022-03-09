class Plan {
  List<dynamic>? offerings;
  List<dynamic>? members;
  var file;
  String? name;
  String? creator;
  String? description;
  String? fromDate;
  String? toDate;
  String? groupId;
  String? id;

  bool? canInvite;
  bool? privateGroup;

  Plan(
      {this.creator,
      this.name,
      this.description,
      this.fromDate,
      this.toDate,
      this.canInvite,
      this.privateGroup,
      this.groupId,
      this.id,
      this.offerings,
      this.file,
      this.members});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
        creator: json['creator'],
        name: json['name'],
        description: json['description'],
        fromDate: json['fromDate'],
        toDate: json['toDate'],
        canInvite: json['canInvite'],
        privateGroup: json['privateGroup'],
        id: json['id'],
        groupId: json['groupId'],
        file: json['planImage'],
        offerings: json['offerings'],
        members: json['members']);
  }
}
