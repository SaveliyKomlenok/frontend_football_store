import 'package:frontend_football_store/model/order_clothing_response.dart';
import 'package:frontend_football_store/model/order_shoes_response.dart';
import 'package:frontend_football_store/model/user_response.dart';

class OrderResponse {
  final int id;
  final DateTime dateOfCreation;
  final String address;
  final UserResponse user;
  final List<OrderClothingResponse> orderClothingList;
  final List<OrderShoesResponse> orderShoesList;
  final double totalPrice;

  OrderResponse({
    required this.id,
    required this.dateOfCreation,
    required this.address,
    required this.user,
    required this.orderClothingList,
    required this.orderShoesList,
    required this.totalPrice
  });

  factory OrderResponse.fromMap(Map<String, dynamic> json) {
    var clothingList = (json['orderClothingList'] as List<dynamic>?)
        ?.map((item) => OrderClothingResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    var shoesList = (json['orderShoesList'] as List<dynamic>?)
        ?.map((item) => OrderShoesResponse.fromMap(item as Map<String, dynamic>))
        .toList() ?? [];

    return OrderResponse(
      id: json['id'],
      dateOfCreation: DateTime.parse(json['dateOfCreation']),
      address: json['address'],
      totalPrice: json['totalPrice'],
      user: UserResponse.fromMap(json['user']),
      orderClothingList: clothingList,
      orderShoesList: shoesList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateOfCreation': dateOfCreation.toIso8601String(),
      'address': address,
      'totalPrice': totalPrice,
      'user': user.toMap(),
      'orderClothingList': orderClothingList.map((item) => item.toMap()).toList(),
      'orderShoesList': orderShoesList.map((item) => item.toMap()).toList(),
    };
  }
}