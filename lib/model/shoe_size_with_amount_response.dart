class ShoeSizeWithAmountResponse {
  final int id;
  final String size;
  final int amount;

  ShoeSizeWithAmountResponse({
    required this.id,
    required this.size,
    required this.amount,
  });

  factory ShoeSizeWithAmountResponse.fromMap(Map<String, dynamic> json) {
    return ShoeSizeWithAmountResponse(
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