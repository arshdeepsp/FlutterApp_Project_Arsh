import 'package:tripd_travel_app/models/offering.dart';

import 'member.dart';

class PlanInfo {
  List<dynamic>? offerings;
  List<dynamic>? members;

  var image;

  String? name;
  Member? creator;
  String? description;
  String? fromDate;
  String? toDate;
  String? id;

  bool? canInvite;
  bool? privateGroup;

  PlanInfo(
      {this.creator,
      this.name,
      this.description,
      this.fromDate,
      this.toDate,
      this.canInvite,
      this.privateGroup,
      this.id,
      this.offerings,
      this.image,
      this.members});

  factory PlanInfo.fromJson(Map<String, dynamic> json) {
    return PlanInfo(
        creator: Member.fromJson(json['creator']),
        canInvite: json['canInvite'],
        privateGroup: json['privateGroup'],
        members: json['members'].map((item) {
          return Member.fromJson(item);
        }).toList(),
        name: json['name'],
        id: json['id'],
        description: json['description'],
        image: json['planImage'],
        offerings: json['offerings'].map((offering) {
          return Offering.fromJson(offering);
        }).toList(),
        fromDate: json['fromDate'],
        toDate: json['toDate']);
  }
}
