import 'package:meta/meta.dart';

import 'category.dart';

@immutable
class SearchResults {
  final bool status;
  final List<Category> categories;
  const SearchResults(this.status, this.categories);
}
