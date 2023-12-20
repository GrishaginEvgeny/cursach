class Product {
  final String id;
  final String name;
  final String catalogId;

  Product({required this.id, required this.name, required this.catalogId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'catalogId': catalogId,
    };
  }
}