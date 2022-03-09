class Offering {
  final String? id;
  final String? name;
  final String? description;
  final String? image;
  final String? price;
  final String? date;
  const Offering(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.price,
      this.date});

  factory Offering.fromJson(Map<String, dynamic> json) {
    return Offering(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        price: json['price'],
        image: json['image'],
        date: json['date']);
    // offerings: json['offerings'],
  }
}
