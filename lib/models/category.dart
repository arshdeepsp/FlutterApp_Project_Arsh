import 'package:meta/meta.dart';

import 'offering.dart';

@immutable
class Category {
  final String name;
  final String image;
  final String id;
  final List<Offering> offerings;
  const Category(this.name, this.image, this.offerings, this.id);
}
