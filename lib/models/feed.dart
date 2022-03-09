import 'package:tripd_travel_app/models/collection.dart';

class Feed {
  Feed({
    required this.id,
    required this.user,
    required this.verb,
    required this.feedType,
    this.collection,
    this.plan,
    this.offering,
    required this.createdAt,
    required this.public,
  });
  late final String id;
  late final User user;
  late final String verb;
  late final String feedType;
  late final Collection? collection;
  late final Null plan;
  late final Null offering;
  late final int createdAt;
  late final bool public;

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = User.fromJson(json['user']);
    verb = json['verb'];
    feedType = json['feedType'];
    collection = Collection.fromJson(json['collection']);
    plan = null;
    offering = null;
    createdAt = json['createdAt'];
    public = json['public'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user'] = user.toJson();
    _data['verb'] = verb;
    _data['feedType'] = feedType;
    if (collection != null) {
      _data['collection'] = collection!.toJson();
    }
    _data['plan'] = plan;
    _data['offering'] = offering;
    _data['createdAt'] = createdAt;
    _data['public'] = public;
    return _data;
  }
}

class User {
  User({
    required this.id,
    required this.userId,
    required this.username,
    this.email,
    required this.profilePic,
    this.firstName,
    this.lastName,
    this.phone,
    required this.bio,
    this.following,
  });
  late final String id;
  late final String userId;
  late final String username;
  late final Null email;
  late final String profilePic;
  late final Null firstName;
  late final Null lastName;
  late final Null phone;
  late final String bio;
  late final Null following;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    username = json['username'];
    email = null;
    profilePic = json['profilePic'];
    firstName = null;
    lastName = null;
    phone = null;
    bio = json['bio'];
    following = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['username'] = username;
    _data['email'] = email;
    _data['profilePic'] = profilePic;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['phone'] = phone;
    _data['bio'] = bio;
    _data['following'] = following;
    return _data;
  }
}

// class Collection {
//   Collection({
//     required this.id,
//     required this.name,
//     required this.userId,
//     this.collectionImage,
//     required this.offerings,
//     required this.private,
//   });
//   late final String id;
//   late final String name;
//   late final String userId;
//   late final Null collectionImage;
//   late final List<dynamic> offerings;
//   late final bool private;

//   Collection.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     userId = json['userId'];
//     collectionImage = null;
//     offerings = List.castFrom<dynamic, dynamic>(json['offerings']);
//     private = json['private'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['name'] = name;
//     _data['userId'] = userId;
//     _data['collectionImage'] = collectionImage;
//     _data['offerings'] = offerings;
//     _data['private'] = private;
//     return _data;
//   }
// }
