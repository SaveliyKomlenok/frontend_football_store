import 'package:frontend_football_store/model/manufacturer_response.dart';
import 'package:frontend_football_store/model/shoes_type_response.dart';

class ShoesResponse {
  final int id;
  final String name;
  final double price; // Используем double для цены
  final String color;
  final String material;
  final String soleType;
  final String description;
  final ManufacturerResponse manufacturer;
  final ShoesTypeResponse shoesType;

  ShoesResponse({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    required this.material,
    required this.soleType,
    required this.description,
    required this.manufacturer,
    required this.shoesType,
  });

  factory ShoesResponse.fromMap(Map<String, dynamic> json) {
    return ShoesResponse(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(), // Приводим к double
      color: json['color'] ?? '',
      material: json['material'] ?? '',
      soleType: json['soleType'] ?? '',
      description: json['description'] ?? '',
      manufacturer: ManufacturerResponse.fromMap(json['manufacturer']),
      shoesType: ShoesTypeResponse.fromMap(json['shoesType']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'color': color,
      'material': material,
      'soleType': soleType,
      'description': description,
      'manufacturer': manufacturer.toMap(),
      'shoesType': shoesType.toMap(),
    };
  }
}