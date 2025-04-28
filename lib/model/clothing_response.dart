import 'package:frontend_football_store/model/clothing_type_response.dart';
import 'package:frontend_football_store/model/manufacturer_response.dart';

class ClothingResponse {
  final int id;
  final String name;
  final double price; // Используем double для цены
  final String color;
  final String material;
  final String description;
  final ManufacturerResponse manufacturer;
  final ClothingTypeResponse clothingType;

  ClothingResponse({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    required this.material,
    required this.description,
    required this.manufacturer,
    required this.clothingType,
  });

  factory ClothingResponse.fromMap(Map<String, dynamic> json) {
    return ClothingResponse(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(), // Приводим к double
      color: json['color'] ?? '',
      material: json['material'] ?? '',
      description: json['description'] ?? '',
      manufacturer: ManufacturerResponse.fromMap(json['manufacturer']),
      clothingType: ClothingTypeResponse.fromMap(json['clothingType']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'color': color,
      'material': material,
      'description': description,
      'manufacturer': manufacturer.toMap(),
      'clothingType': clothingType.toMap(),
    };
  }
}