class Catalog {
  final String id;
  final String name;

  Catalog({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}