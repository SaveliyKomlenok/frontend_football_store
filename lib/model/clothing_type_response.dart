class ClothingTypeResponse {
  final int id;
  final String name;

  ClothingTypeResponse({
    required this.id,
    required this.name,
  });

  factory ClothingTypeResponse.fromMap(Map<String, dynamic> json) {
    return ClothingTypeResponse(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}