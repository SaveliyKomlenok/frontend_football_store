class OrderRequest {
  final String address;

  OrderRequest({
    required this.address,
  });

  factory OrderRequest.fromMap(Map<String, dynamic> json) {
    return OrderRequest(
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
    };
  }
}