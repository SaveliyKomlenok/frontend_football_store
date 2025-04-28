class ClothSizeResponse {
  final int id;
  final String size;

  ClothSizeResponse({
    required this.id,
    required this.size,
  });

  factory ClothSizeResponse.fromMap(Map<String, dynamic> json) {
    return ClothSizeResponse(
      id: json['id'],
      size: json['size'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'size': size,
    };
  }
}