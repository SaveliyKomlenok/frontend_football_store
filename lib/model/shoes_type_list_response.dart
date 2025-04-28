import 'package:frontend_football_store/model/shoes_type_response.dart';

class ShoesTypeListResponse {
  final List<ShoesTypeResponse> items;

  ShoesTypeListResponse({required this.items});

  factory ShoesTypeListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ShoesTypeResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ShoesTypeListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}