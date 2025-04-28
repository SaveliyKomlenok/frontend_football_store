class ClothSizeWithAmountResponse {
  final int id;
  final String size;
  final int amount;

  ClothSizeWithAmountResponse({
    required this.id,
    required this.size,
    required this.amount,
  });

  factory ClothSizeWithAmountResponse.fromMap(Map<String, dynamic> json) {
    return ClothSizeWithAmountResponse(
      id: json['id'],
      size: json['size'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'size': size,
      'amount': amount,
    };
  }
}