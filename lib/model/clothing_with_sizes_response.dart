import 'package:frontend_football_store/model/cloth_size_with_amount_response.dart';
import 'package:frontend_football_store/model/clothing_response.dart';

class ClothingWithSizesResponse {
  final ClothingResponse clothing;
  final List<ClothSizeWithAmountResponse> sizes;

  ClothingWithSizesResponse({
    required this.clothing,
    required this.sizes,
  });

  factory ClothingWithSizesResponse.fromMap(Map<String, dynamic> json) {
    var sizesList = (json['sizes'] as List<dynamic>?)
        ?.map((item) => ClothSizeWithAmountResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ClothingWithSizesResponse(
      clothing: ClothingResponse.fromMap(json['clothing']),
      sizes: sizesList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clothing': clothing.toMap(),
      'sizes': sizes.map((item) => item.toMap()).toList(),
    };
  }
}