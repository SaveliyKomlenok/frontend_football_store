import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend_football_store/model/cart_clothing_response.dart';
import 'package:frontend_football_store/model/cart_response.dart';
import 'package:frontend_football_store/model/cart_shoes_response.dart';
import 'package:frontend_football_store/model/request/cart_clothing_request.dart';
import 'package:frontend_football_store/model/request/cart_shoes_request.dart';
import 'package:frontend_football_store/service/cart_clothing_service.dart';
import 'package:frontend_football_store/service/cart_service.dart';
import 'package:frontend_football_store/service/cart_shoes_service.dart';
import 'package:frontend_football_store/service/clothing_service.dart';
import 'package:frontend_football_store/service/shoes_service.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<CartResponse> _cartFuture;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void loadCart() {
    final CartService cartService = CartService();
    _cartFuture = cartService.listOfCarts();
  }

  int _getTotalItems(CartResponse cartData) {
    int totalItems = 0;
    totalItems += cartData.cartClothingList.fold(0, (sum, item) => sum + item.amount);
    totalItems += cartData.cartShoesList.fold(0, (sum, item) => sum + item.amount);
    return totalItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<CartResponse>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              (snapshot.data!.cartClothingList.isEmpty &&
                  snapshot.data!.cartShoesList.isEmpty)) {
            return const Center(child: Text('Корзина пуста'));
          }

          final cartData = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(right: 16.0),
                          children: [
                            const SizedBox(height: 16),
                            const Text('Корзина',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            if (cartData.cartClothingList.isNotEmpty) ...[
                              ...cartData.cartClothingList
                                  .map((item) => CartItemCard(
                                        item: item,
                                        onQuantityChanged: (newAmount) {
                                          setState(() {
                                            int tempAmount =item.amount; 
                                            item.amount = newAmount;
                                            cartData.totalPrice =  cartData.totalPrice + item.clothing.clothing.price* (newAmount- tempAmount);
                                          });
                                        },
                                      ))
                                  .toList(),
                            ],
                            if (cartData.cartShoesList.isNotEmpty) ...[
                              ...cartData.cartShoesList
                                  .map((item) => CartShoesCard(
                                        item: item,
                                        onQuantityChanged: (newAmount) {
                                          setState(() {
                                            int tempAmount =item.amount; 
                                            item.amount = newAmount;
                                            cartData.totalPrice =  cartData.totalPrice + item.shoes.shoes.price *(newAmount- tempAmount);// Обновляем количество
                                          });
                                        },
                                      ))
                                  .toList(),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Column(
                  children: [
                    Container(
                      height: 180,
                      width: 300,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Оформление заказа',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue)),
                          const SizedBox(height: 8),
                          Text(
                              'Товаров: ${_getTotalItems(cartData)}'),
                          const SizedBox(height: 8),
                          Text(
                              'Итого: ${cartData.totalPrice.toStringAsFixed(2)} BYN',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Логика для оформления заказа
                              },
                              child: const Text(
                                'Заказать',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.all(18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartClothingResponse item;
  final ValueChanged<int> onQuantityChanged;

  const CartItemCard({Key? key, required this.item, required this.onQuantityChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: ClothingService().getClothingImage(item.clothing.clothing.id),
      builder: (context, snapshot) {
        return Card(
          elevation: 6,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                 snapshot.hasData
                        ? CachedNetworkImage(
                            imageUrl: 'data:image/png;base64,${base64Encode(snapshot.data!)}',
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          )
                        : const Text(''),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.clothing.clothing.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Количество: ${item.amount}'),
                      Text('Размер: ${item.clothing.size.size}'),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            // Логика удаления элемента
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        _updateQuantity(context, item, item.amount - 1);
                      },
                    ),
                    Text('${item.amount}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _updateQuantity(context, item, item.amount + 1);
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(item.clothing.clothing.price*item.amount).toStringAsFixed(2)} BYN',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateQuantity(BuildContext context, CartClothingResponse item, int newAmount) {
    if (newAmount < 1) {
      // Логика для удаления, если количество меньше 1
      return;
    }
    
    final request = CartClothingRequest(
      amount: newAmount,
      clothing: item.clothing.clothing.id,
      size: item.clothing.size.id,
    );

    CartClothingService.update(item.id, request).then((updatedItem) {
      onQuantityChanged(newAmount); // Обновляем только количество
    }).catchError((error) {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $error')));
    });
  }
}

class CartShoesCard extends StatelessWidget {
  final CartShoesResponse item;
  final ValueChanged<int> onQuantityChanged;

  const CartShoesCard({Key? key, required this.item, required this.onQuantityChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: ShoesService().getShoesImage(item.shoes.shoes.id),
      builder: (context, snapshot) {
        return Card(
          elevation: 6,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                snapshot.hasData
                        ? CachedNetworkImage(
                            imageUrl: 'data:image/png;base64,${base64Encode(snapshot.data!)}',
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          )
                        : Text(''),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.shoes.shoes.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Количество: ${item.amount}'),
                      Text('Размер: ${item.shoes.size.size}'),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            // Логика удаления элемента
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        _updateQuantity(context, item, item.amount - 1);
                      },
                    ),
                    Text('${item.amount}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _updateQuantity(context, item, item.amount + 1);
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(item.shoes.shoes.price*item.amount).toStringAsFixed(2)} BYN',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateQuantity(BuildContext context, CartShoesResponse item, int newAmount) {
    if (newAmount < 1) {
      // Логика для удаления, если количество меньше 1
      return;
    }

    final request = CartShoesRequest(
      amount: newAmount,
      shoes: item.shoes.shoes.id,
      size: item.shoes.size.id,
    );

    CartShoesService.update(item.id, request).then((updatedItem) {
      onQuantityChanged(newAmount); // Обновляем только количество
    }).catchError((error) {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $error')));
    });
  }
}