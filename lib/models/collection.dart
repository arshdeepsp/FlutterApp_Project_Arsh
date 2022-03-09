class Collection {
  Collection({
    required this.id,
    required this.name,
    required this.userId,
    required this.collectionImage,
    required this.offerings,
    this.isPrivate,
  });

  late final String id;
  late final String name;
  late final String userId;
  late final String? collectionImage;
  late final List<dynamic> offerings;
  bool? isPrivate;

  Collection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['userId'];
    collectionImage = json["collectionImage"];
    offerings = List.castFrom<dynamic, dynamic>(json['offerings']);
    if (json['isPrivate'] != null) {
      isPrivate = json['isPrivate'] ?? false;
    } else if (json['private'] != null) {
      isPrivate = json['private'] ?? false;
    } else {
      isPrivate = false;
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['userId'] = userId;
    _data['collectionImage'] = collectionImage;
    _data['offerings'] = offerings;
    _data['private'] = isPrivate;
    return _data;
  }
}
