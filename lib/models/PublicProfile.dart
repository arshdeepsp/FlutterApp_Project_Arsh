import 'package:tripd_travel_app/models/collection.dart';
import 'package:tripd_travel_app/models/plan.dart';

class PublicProfile {
  PublicProfile({
    this.username,
    this.profilePic,
    this.firstName,
    this.lastName,
    this.phone,
    this.bio,
    this.following,
    this.followers,
    this.plans,
    this.collections,
  });
  String? username;
  String? profilePic;
  String? firstName;
  String? lastName;
  String? phone;
  String? bio;
  int? following;
  int? followers;
  List<Plan>? plans;
  List<Collection>? collections;

  PublicProfile.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    profilePic = json['profilePic'];
    firstName = json["firstName"];
    lastName = json["lastName"];
    phone = null;
    bio = json['bio'];
    following = json['following'];
    followers = json['followers'];
    plans = List.from(json['plans']).map((e) => Plan.fromJson(e)).toList();
    collections = List.from(json['collections'])
        .map((e) => Collection.fromJson(e))
        .toList();
  }

  // Map<String, dynamic> toJson() {
  //   final _data = <String, dynamic>{};
  //   _data['username'] = username;
  //   _data['profilePic'] = profilePic;
  //   _data['firstName'] = firstName;
  //   _data['lastName'] = lastName;
  //   _data['phone'] = phone;
  //   _data['bio'] = bio;
  //   _data['following'] = following;
  //   _data['followers'] = followers;
  //   if (plans != null) {
  //     _data['plans'] = plans!.map((e) => e!.toJson()).toList();
  //   }
  //   if (collections != null) {
  //     _data['collections'] = collections!.map((e) => e!.toJson()).toList();
  //   }
  //   return _data;
  // }
}

// class Plans {
//   Plans({
//     this.id,
//     this.name,
//     this.planImage,
//     this.description,
//     this.creator,
//     this.groupId,
//     this.offerings,
//     this.fromDate,
//     this.toDate,
//     this.privateGroup,
//     this.canInvite,
//   });
//   String? id;
//   String? name;
//   String? planImage;
//   String? description;
//   String? creator;
//   String? groupId;
//   List<dynamic>? offerings;
//   String? fromDate;
//   String? toDate;
//   bool? privateGroup;
//   bool? canInvite;

//   Plans.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     planImage = json['planImage'];
//     description = json['description'];
//     creator = json['creator'];
//     groupId = json['groupId'];
//     offerings = List.castFrom<dynamic, dynamic>(json['offerings']);
//     fromDate = json['fromDate'];
//     toDate = json['toDate'];
//     privateGroup = json['privateGroup'];
//     canInvite = json['canInvite'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['name'] = name;
//     _data['planImage'] = planImage;
//     _data['description'] = description;
//     _data['creator'] = creator;
//     _data['groupId'] = groupId;
//     _data['offerings'] = offerings;
//     _data['fromDate'] = fromDate;
//     _data['toDate'] = toDate;
//     _data['privateGroup'] = privateGroup;
//     _data['canInvite'] = canInvite;
//     return _data;
//   }
// }

// class Collections {
//   Collections({
//     this.id,
//     this.name,
//     this.userId,
//     this.collectionImage,
//     this.offerings,
//   });
//   String? id;
//   String? name;
//   String? userId;
//   String? collectionImage;
//   List<String>? offerings;

//   Collections.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     userId = json['userId'];
//     collectionImage = json['collectionImage'];
//     offerings = List.castFrom<dynamic, String>(json['offerings']);
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['name'] = name;
//     _data['userId'] = userId;
//     _data['collectionImage'] = collectionImage;
//     _data['offerings'] = offerings;
//     return _data;
//   }
// }
