import 'package:flutter/material.dart';
import 'package:frontend_football_store/model/shoes_with_sizes_response.dart';
import 'package:frontend_football_store/model/request/cart_shoes_request.dart';
import 'package:frontend_football_store/service/cart_shoes_service.dart';
import 'package:frontend_football_store/service/shoe_size_service.dart';
import 'package:frontend_football_store/service/shoes_service.dart';
import 'package:frontend_football_store/service/manufacturer_service.dart';
import 'package:frontend_football_store/util/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoesPage extends StatefulWidget {
  final Function(int) onMenuTap;

  const ShoesPage({super.key, required this.onMenuTap});

  @override
  _ShoesPageState createState() => _ShoesPageState();
}

class _ShoesPageState extends State<ShoesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ShoesService _service = ShoesService();
  final ManufacturerService _manufacturerService = ManufacturerService();
  final ShoeSizeService _shoesSizeService = ShoeSizeService();

  late Future<List<ShoesWithSizesResponse>> _shoeItems;
  List<ShoesWithSizesResponse> _filteredItems = [];
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
    _shoeItems = _service.getAllShoes().then((items) {
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
    final manufacturers = await _manufacturerService.getAllManufacturers();
    final sizes = await _shoesSizeService.getAllShoeSizes();

    setState(() {
      _manufacturers = manufacturers.map((m) => m.name).toList();
      _sizes = sizes.map((s) => s.size).toList();
    });
  }

  void _updateFilteredItems() async {
    final items = await _shoeItems;
    setState(() {
      _filteredItems = items;

      if (searchQuery.isNotEmpty) {
        _filteredItems = _filteredItems
            .where((item) => item.shoes.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
      }

      if (_selectedManufacturers.isNotEmpty) {
        _filteredItems = _filteredItems
            .where((item) =>
                _selectedManufacturers.contains(item.shoes.manufacturer.name))
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.search, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск обуви...',
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.white60),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body:
       Row(
        children: [
          Container(
            width: 250,
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Производители',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._manufacturers.map((manufacturer) => CheckboxListTile(
                        title: Text(manufacturer),
                        value: _selectedManufacturers.contains(manufacturer),
                        activeColor: Colors.blue,
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
                      )),
                  const Divider(),
                  const Text('Размеры',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._sizes.map((size) => CheckboxListTile(
                        title: Text(size),
                        value: _selectedSizes.contains(size),
                        activeColor: Colors.blue,
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
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ShoesWithSizesResponse>>(
              future: _shoeItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                }
                if (_filteredItems.isEmpty) {
                  return const Center(
                      child: Text(
                    'Обуви не найдено',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ));
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
                    return ShoeCard(
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

class ShoeCard extends StatelessWidget {
  final ShoesWithSizesResponse item;
  final VoidCallback onTap;
  final String? userRole;

  const ShoeCard({
    Key? key,
    required this.item,
    required this.onTap,
    required this.userRole,
  }) : super(key: key);

  void _showSizeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 75), // ограничение ширины
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        'Выберите размер',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: item.sizes.map((size) {
                          return SizedBox(
                            width: 60,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets
                                    .zero, // убираем внутренние отступы
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                try {
                                  await CartShoesService.save(CartShoesRequest(
                                    amount: 1,
                                    shoes: item.shoes.id,
                                    size: size.id,
                                  ));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Добавлено в корзину: ${item.shoes.name}, размер ${size.size}')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Выбранная пара обуви размера ${size.size} отсутствует на складе')),
                                  );
                                }
                              },
                              child: Text(
                                size.size,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
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
              imageUrl: "$baseURL/api/v1/shoes/${item.shoes.id}/image",
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Center(child: Text('Нет изображения')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${item.shoes.price.toStringAsFixed(2)} BYN',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 76, 89, 175),
                    fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Text(
              '${item.shoes.manufacturer.name} / ${item.shoes.name}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (userRole == 'USER') {
                    _showSizeSelectionDialog(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Необходимо авторизоваться.')),
                    );
                  }
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: const Text('В корзину',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
