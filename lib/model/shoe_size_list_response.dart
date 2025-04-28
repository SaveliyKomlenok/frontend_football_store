import 'package:frontend_football_store/model/shoe_size_response.dart';

class ShoeSizeListResponse {
  final List<ShoeSizeResponse> items;

  ShoeSizeListResponse({required this.items});

  factory ShoeSizeListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ShoeSizeResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ShoeSizeListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}