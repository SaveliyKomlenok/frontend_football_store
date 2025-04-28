import 'package:frontend_football_store/model/shoes_response.dart';
import 'package:frontend_football_store/model/shoe_size_with_amount_response.dart';

class ShoesWithSizesResponse {
  final ShoesResponse shoes;
  final List<ShoeSizeWithAmountResponse> sizes;

  ShoesWithSizesResponse({
    required this.shoes,
    required this.sizes,
  });

  factory ShoesWithSizesResponse.fromMap(Map<String, dynamic> json) {
    var sizesList = (json['sizes'] as List<dynamic>?)
        ?.map((item) => ShoeSizeWithAmountResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ShoesWithSizesResponse(
      shoes: ShoesResponse.fromMap(json['shoes']),
      sizes: sizesList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shoes': shoes.toMap(),
      'sizes': sizes.map((item) => item.toMap()).toList(),
    };
  }
}