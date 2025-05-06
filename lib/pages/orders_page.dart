import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend_football_store/model/order_clothing_response.dart';
import 'package:frontend_football_store/model/order_list_response.dart';
import 'package:frontend_football_store/model/order_response.dart';
import 'package:frontend_football_store/model/order_shoes_response.dart';
import 'package:frontend_football_store/service/order_service.dart';
import 'package:frontend_football_store/service/clothing_service.dart';
import 'package:frontend_football_store/service/shoes_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<OrderListResponse> ordersFuture;
  Map<int, Uint8List?> clothingImageCache = {};
  Map<int, Uint8List?> shoesImageCache = {};

  @override
  void initState() {
    super.initState();
    ordersFuture = OrderService().findAllOrders();
  }

  Future<Uint8List?> _loadClothingImage(int id) async {
    if (clothingImageCache.containsKey(id)) {
      return clothingImageCache[id];
    }
    final imageData = await ClothingService().getClothingImage(id);
    clothingImageCache[id] = imageData;
    return imageData;
  }

  Future<Uint8List?> _loadShoesImage(int id) async {
    if (shoesImageCache.containsKey(id)) {
      return shoesImageCache[id];
    }
    final imageData = await ShoesService().getShoesImage(id);
    shoesImageCache[id] = imageData;
    return imageData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<OrderListResponse>(
        future: ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_shopping_cart_rounded,
                          size: 100, color: Colors.grey[400]),
                      const SizedBox(height: 20),
                      const Text(
                        'Заказы отсутствуют',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Оформите заказ, чтобы увидеть его здесь.',
                        style: TextStyle(fontSize: 16, color: Colors.black38),
                      ),
                    ],
                  ),
                );
          }

          final orders = snapshot.data!.items;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderCard(
                order: orders[index],
                loadClothingImage: _loadClothingImage,
                loadShoesImage: _loadShoesImage,
                onDelete: (id) async {
                  await OrderService().deleteOrder(id);
                  setState(() {
                    ordersFuture = OrderService().findAllOrders(); // Обновляем список заказов
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderResponse order;
  final Future<Uint8List?> Function(int) loadClothingImage;
  final Future<Uint8List?> Function(int) loadShoesImage;
  final Function(int) onDelete; // Добавляем функцию для удаления заказа

  const OrderCard({
    required this.order,
    required this.loadClothingImage,
    required this.loadShoesImage,
    required this.onDelete, // Передаём функцию в конструктор
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.dateOfCreation.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Row(
                          children: [
                            const Text('Подтверждение удаления',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        content: const Text('Вы уверены, что хотите удалить этот заказ?'),
                        actions: [
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                              ),
                              child: const Text('Удалить'),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (result == true) {
                      await onDelete(order.id);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red, backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Отменить заказ'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${order.totalPrice} BYN',
              style: const TextStyle(color: Colors.green, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Адрес: ${order.address}',
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 8),
            _buildItemsGrid(order),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsGrid(OrderResponse order) {
    final itemCount =
        order.orderClothingList.length + order.orderShoesList.length;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index < order.orderClothingList.length) {
          return _buildClothingCard(order.orderClothingList[index]);
        } else {
          return _buildShoesCard(
              order.orderShoesList[index - order.orderClothingList.length]);
        }
      },
    );
  }

  Widget _buildClothingCard(OrderClothingResponse clothing) {
    return FutureBuilder<Uint8List?>(
      future: loadClothingImage(clothing.clothingWarehouse.clothing.id),
      builder: (context, snapshot) {
        return Card(
          color: Colors.white,
          elevation: 4,
          child: SizedBox(
            width: 400,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (snapshot.connectionState == ConnectionState.waiting)
                    Container(
                      width: 400,
                      height: 400,
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (snapshot.hasData)
                    CachedNetworkImage(
                      imageUrl:
                          'data:image/png;base64,${base64Encode(snapshot.data!)}',
                      width: 400,
                      height: 400,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${clothing.clothingWarehouse.clothing.price} BYN',
                        style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${clothing.clothingWarehouse.clothing.name}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Количество - ${clothing.amount}',
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            'Размер - ${clothing.clothingWarehouse.size.size}',
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShoesCard(OrderShoesResponse shoes) {
    return FutureBuilder<Uint8List?>(
      future: loadShoesImage(shoes.shoesWarehouse.shoes.id),
      builder: (context, snapshot) {
        return Card(
          color: Colors.white,
          elevation: 4,
          child: SizedBox(
            width: 400,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (snapshot.connectionState == ConnectionState.waiting)
                    Container(
                      width: 400,
                      height: 400,
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (snapshot.hasData)
                    CachedNetworkImage(
                      imageUrl: 'data:image/png;base64,${base64Encode(snapshot.data!)}',
                      width: 400,
                      height: 400,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Цена: ${shoes.shoesWarehouse.shoes.price} BYN',
                        style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${shoes.shoesWarehouse.shoes.name}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Количество - ${shoes.amount}',
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            'Размер - ${shoes.shoesWarehouse.size.size}',
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}