import 'package:frontend_football_store/model/shoes_response.dart';

class ShoesListResponse {
  final List<ShoesResponse> items;

  ShoesListResponse({required this.items});

  factory ShoesListResponse.fromMap(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List<dynamic>?)
        ?.map((item) => ShoesResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return ShoesListResponse(items: itemsList);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}