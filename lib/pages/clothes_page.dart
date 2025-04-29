import 'package:flutter/material.dart';
import 'package:frontend_football_store/model/clothing_with_sizes_response.dart';
import 'package:frontend_football_store/model/request/cart_clothing_request.dart';
import 'package:frontend_football_store/service/cart_clothing_service.dart';
import 'package:frontend_football_store/service/clothing_service.dart';
import 'package:frontend_football_store/service/clothing_size_service.dart';
import 'package:frontend_football_store/service/manufacturer_service.dart';
import 'package:frontend_football_store/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClothesPage extends StatefulWidget {
  final Function(int) onMenuTap;

  const ClothesPage({super.key, required this.onMenuTap});

  @override
  _ClothingPageState createState() => _ClothingPageState();
}

class _ClothingPageState extends State<ClothesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ClothingService _service = ClothingService();
  final ManufacturerService _manufacturerService = ManufacturerService();
  final ClothingSizeService _clothingSizeService = ClothingSizeService();

  late Future<List<ClothingWithSizesResponse>> _clothingItems;
  List<ClothingWithSizesResponse> _filteredItems = [];
  String searchQuery = '';
  List<String> _selectedManufacturers = [];
  List<String> _selectedSizes = [];
  List<String> _manufacturers = [];
  List<String> _sizes = [];
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _clothingItems = _service.getAllClothingItems().then((items) {
      _filteredItems = items;
      return items;
    });
    _loadManufacturersAndSizes();
  }

  void _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userRole = prefs.getString('role');
    });
  }

  void _loadManufacturersAndSizes() async {
    try {
      final manufacturers = await _manufacturerService.getAllManufacturers();
      final sizes = await _clothingSizeService.getAllClothingSizes();

      setState(() {
        _manufacturers = manufacturers.map((m) => m.name).toList();
        _sizes = sizes.map((s) => s.size).toList();
      });
    } catch (e) {
      print('Ошибка загрузки фильтров: $e');
    }
  }

  void _updateFilteredItems() async {
    final items = await _clothingItems;
    setState(() {
      _filteredItems = items;

      if (searchQuery.isNotEmpty) {
        _filteredItems = _filteredItems
            .where((item) => item.clothing.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
      }

      if (_selectedManufacturers.isNotEmpty) {
        _filteredItems = _filteredItems
            .where((item) => _selectedManufacturers
                .contains(item.clothing.manufacturer.name))
            .toList();
      }

      if (_selectedSizes.isNotEmpty) {
        _filteredItems = _filteredItems
            .where((item) =>
                item.sizes.any((size) => _selectedSizes.contains(size.size)))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.search, color: Colors.white),
            const SizedBox(width: 8), // Отступ между иконкой и текстом
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск одежды...',
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.white60),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0), // Установите вертикальные отступы
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              searchQuery = '';
                            });
                            _updateFilteredItems();
                          },
                        )
                      : null,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  _updateFilteredItems();
                },
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF007BFF),
      ),
      backgroundColor: const Color(0xFFE0E0E0),
      body: Row(
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.all(8),
            color: Colors.blue[50],
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Производители',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._manufacturers.map((manufacturer) {
                    return CheckboxListTile(
                      title: Text(manufacturer),
                      value: _selectedManufacturers.contains(manufacturer),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedManufacturers.add(manufacturer);
                          } else {
                            _selectedManufacturers.remove(manufacturer);
                          }
                          _updateFilteredItems();
                        });
                      },
                    );
                  }).toList(),
                  const Divider(),
                  const Text('Размеры',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._sizes.map((size) {
                    return CheckboxListTile(
                      title: Text(size),
                      value: _selectedSizes.contains(size),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedSizes.add(size);
                          } else {
                            _selectedSizes.remove(size);
                          }
                          _updateFilteredItems();
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ClothingWithSizesResponse>>(
              future: _clothingItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Нет доступной одежды.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    return ClothingCard(
                      item: _filteredItems[index],
                      onTap: () => widget.onMenuTap(5),
                      userRole: _userRole,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ClothingCard extends StatelessWidget {
  final ClothingWithSizesResponse item;
  final VoidCallback onTap;
  final String? userRole;

  const ClothingCard({
    Key? key,
    required this.item,
    required this.onTap,
    required this.userRole,
  }) : super(key: key);

  void _showSizeSelectionDialog(
      BuildContext context, ClothingWithSizesResponse item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'Выберите размер',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: item.sizes.map((size) {
                        return SizedBox(
                          width: 60,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              try {
                                await CartClothingService.save(
                                    CartClothingRequest(
                                  amount: 1,
                                  clothing: item.clothing.id,
                                  size: size.id,
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Добавлено в корзину: ${item.clothing.name}, размер ${size.size}')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Ошибка при добавлении: $e')),
                                );
                              }
                            },
                            child: Text(size.size,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 500,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: "$baseURL/api/v1/clothing/${item.clothing.id}/image",
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Text('Нет изображения')),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${item.clothing.price.toStringAsFixed(2)} BYN',
              style: const TextStyle(
                color: Color.fromARGB(255, 76, 89, 175),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              '${item.clothing.manufacturer.name} / ${item.clothing.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 140, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (userRole == 'USER') {
                    _showSizeSelectionDialog(context, item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Необходимо авторизоваться для добавления товаров в корзину.',
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: const Text(
                  'В корзину',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
