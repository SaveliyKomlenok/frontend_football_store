class CartClothingRequest {
  final int amount;
  final int clothing; // Use int for Long
  final int size; // Use int for Long

  CartClothingRequest({
    required this.amount,
    required this.clothing,
    required this.size,
  });

  factory CartClothingRequest.fromMap(Map<String, dynamic> json) {
    return CartClothingRequest(
      amount: json['amount'] ?? 0,
      clothing: json['clothing'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'clothing': clothing,
      'size': size,
    };
  }
}