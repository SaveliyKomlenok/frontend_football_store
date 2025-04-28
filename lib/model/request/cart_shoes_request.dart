class CartShoesRequest {
  final int amount;
  final int shoes; // Use int for Long
  final int size; // Use int for Long

  CartShoesRequest({
    required this.amount,
    required this.shoes,
    required this.size,
  });

  factory CartShoesRequest.fromMap(Map<String, dynamic> json) {
    return CartShoesRequest(
      amount: json['amount'] ?? 0,
      shoes: json['shoes'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'shoes': shoes,
      'size': size,
    };
  }
}