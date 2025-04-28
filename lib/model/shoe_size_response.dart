class ShoeSizeResponse {
  final int id;
  final String size;

  ShoeSizeResponse({
    required this.id,
    required this.size,
  });

  factory ShoeSizeResponse.fromMap(Map<String, dynamic> json) {
    return ShoeSizeResponse(
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