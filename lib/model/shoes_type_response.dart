class ShoesTypeResponse {
  final int id;
  final String name;

  ShoesTypeResponse({
    required this.id,
    required this.name,
  });

  factory ShoesTypeResponse.fromMap(Map<String, dynamic> json) {
    return ShoesTypeResponse(
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