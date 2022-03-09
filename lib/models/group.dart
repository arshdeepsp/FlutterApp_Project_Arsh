class Group {
  Group({
    this.id,
    this.name,
    this.admin,
    this.members,
    this.type,
    this.collections,
    this.plans,
    this.invited,
  });
  String? id;
  String? name;
  String? admin;
  List<dynamic>? members;
  String? type;
  List<dynamic>? collections;
  List<dynamic>? plans;
  List<dynamic>? invited;

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    admin = json['admin'];
    members = List.castFrom<dynamic, dynamic>(json['members']);
    type = json['type'];
    collections =json['collections'];
    plans = json['plans'];
    invited = json['invited'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['admin'] = admin;
    _data['members'] = members;
    _data['type'] = type;
    _data['collections'] = collections;
    _data['plans'] = plans;
    _data['invited'] = invited;
    return _data;
  }
}
