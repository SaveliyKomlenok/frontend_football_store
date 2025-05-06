import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend_football_store/main_controller.dart';
import 'package:frontend_football_store/model/cart_clothing_response.dart';
import 'package:frontend_football_store/model/cart_response.dart';
import 'package:frontend_football_store/model/cart_shoes_response.dart';
import 'package:frontend_football_store/model/request/cart_clothing_request.dart';
import 'package:frontend_football_store/model/request/cart_shoes_request.dart';
import 'package:frontend_football_store/model/request/order_request.dart';
import 'package:frontend_football_store/service/cart_clothing_service.dart';
import 'package:frontend_football_store/service/cart_service.dart';
import 'package:frontend_football_store/service/cart_shoes_service.dart';
import 'package:frontend_football_store/service/clothing_service.dart';
import 'package:frontend_football_store/service/order_service.dart';
import 'package:frontend_football_store/service/shoes_service.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<CartResponse> _cartFuture;
  Map<int, Uint8List?> _clothingImageCache = {}; // Кэш для изображений одежды
  Map<int, Uint8List?> _shoesImageCache = {}; // Кэш для изображений обуви
  CartResponse? _cartData; // Храним данные корзины локально

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final CartService cartService = CartService();
    _cartData = await cartService.listOfCarts();
    setState(() {});
  }

  Future<Uint8List?> _loadClothingImage(int id) async {
    if (_clothingImageCache.containsKey(id)) {
      return _clothingImageCache[id]; // Возвращаем из кэша
    }
    final imageData = await ClothingService().getClothingImage(id);
    _clothingImageCache[id] = imageData; // Сохраняем в кэш
    return imageData;
  }

  Future<Uint8List?> _loadShoesImage(int id) async {
    if (_shoesImageCache.containsKey(id)) {
      return _shoesImageCache[id]; // Возвращаем из кэша
    }
    final imageData = await ShoesService().getShoesImage(id);
    _shoesImageCache[id] = imageData; // Сохраняем в кэш
    return imageData;
  }

  int _getTotalItems() {
    if (_cartData == null) return 0;
    int totalItems = 0;
    totalItems +=
        _cartData!.cartClothingList.fold(0, (sum, item) => sum + item.amount);
    totalItems +=
        _cartData!.cartShoesList.fold(0, (sum, item) => sum + item.amount);
    return totalItems;
  }

  void _deleteClothingItem(int id, int index) {
    CartClothingService.delete(id).then((_) {
      setState(() {
        _cartData!.cartClothingList
            .removeAt(index); // Удаляем элемент из списка
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $error')));
    });
  }

  void _deleteShoesItem(int id, int index) {
    CartShoesService.delete(id).then((_) {
      setState(() {
        _cartData!.cartShoesList.removeAt(index); // Удаляем элемент из списка
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _cartData == null
          ? const Center(child: CircularProgressIndicator())
          : _cartData!.cartClothingList.isEmpty &&
                  _cartData!.cartShoesList.isEmpty
              ? const Center(child: Text('Корзина пуста'))
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 6,
                        child: ListView(
                          padding: const EdgeInsets.only(right: 16.0),
                          children: [
                            const SizedBox(height: 16),
                            const Text('Корзина',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                            ..._cartData!.cartClothingList
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              var item = entry.value;
                              return CartItemCard(
                                item: item,
                                loadImage: _loadClothingImage(
                                    item.clothing.clothing.id),
                                onQuantityChanged: (newAmount) {
                                  setState(() {
                                    int tempAmount = item.amount;
                                    item.amount = newAmount;
                                    _cartData!.totalPrice +=
                                        item.clothing.clothing.price *
                                            (newAmount - tempAmount);
                                  });
                                },
                                onDelete: () => _deleteClothingItem(
                                    item.id, index), // Логика удаления
                              );
                            }).toList(),
                            ..._cartData!.cartShoesList
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              var item = entry.value;
                              return CartShoesCard(
                                item: item,
                                loadImage: _loadShoesImage(item.shoes.shoes.id),
                                onQuantityChanged: (newAmount) {
                                  setState(() {
                                    int tempAmount = item.amount;
                                    item.amount = newAmount;
                                    _cartData!.totalPrice +=
                                        item.shoes.shoes.price *
                                            (newAmount - tempAmount);
                                  });
                                },
                                onDelete: () => _deleteShoesItem(
                                    item.id, index), // Логика удаления
                              );
                            }).toList(),
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
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.blue)),
                                const SizedBox(height: 8),
                                Text('Товаров: ${_getTotalItems()}'),
                                const SizedBox(height: 8),
                                Text(
                                    'Итого: ${_cartData!.totalPrice.toStringAsFixed(2)} BYN',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showOrderDialog();
                                    },
                                    child: const Text(
                                      'Заказать',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue,
                                      padding: const EdgeInsets.all(18),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
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
                ),
    );
  }

 void _showOrderDialog() {
  final TextEditingController addressController = TextEditingController();
  bool isAddressValid = true;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            backgroundColor: Colors.white, // Фон окна белый
            title: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text('Оформление заказа', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTextField(
                    controller: addressController,
                    label: 'Введите адрес доставки',
                    isError: !isAddressValid,
                    onChanged: () {
                      setModalState(() {
                        isAddressValid = true; // Сбрасываем ошибку
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String address = addressController.text;

                      if (address.isEmpty) {
                        setModalState(() {
                          isAddressValid = false; // Устанавливаем флаг для отображения ошибки
                        });
                      } else {
                        // Создаем заказ
                        final orderRequest = OrderRequest(address: address);
                        OrderService().createOrder(orderRequest).then((response) {
                          Navigator.of(context).pop(); // Закрываем диалог
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Заказ успешно оформлен')),
                          );
                         
                        }).catchError((error) {
                          
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Заказ успешно оформлен')),
                          );
                         Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MainController()),
                          );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Синий фон для кнопки "Подтвердить"
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    ),
                    child: const Text('Подтвердить', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// Метод для создания текстового поля с проверкой на ошибку
Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required bool isError,
  required Function onChanged,
}) {
  return TextField(
    controller: controller,
    onChanged: (value) => onChanged(),
    decoration: InputDecoration(
      labelText: label,
      errorText: isError ? 'Адрес не может быть пустым' : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: isError ? Colors.red : Colors.grey),
      ),
    ),
  );
}
}

class CartItemCard extends StatelessWidget {
  final CartClothingResponse item;
  final Future<Uint8List?> loadImage;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete; // Добавлено для удаления

  const CartItemCard(
      {Key? key,
      required this.item,
      required this.loadImage,
      required this.onQuantityChanged,
      required this.onDelete}) // Добавлено в конструктор
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: loadImage,
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
                        imageUrl:
                            'data:image/png;base64,${base64Encode(snapshot.data!)}',
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                        //placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Container(
                        width: 150,
                        height: 150,
                        child: const CircularProgressIndicator(),
                      ),
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
                          onPressed: onDelete, // Вызов удаления
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
                    '${(item.clothing.clothing.price * item.amount).toStringAsFixed(2)} BYN',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateQuantity(
      BuildContext context, CartClothingResponse item, int newAmount) {
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
      // Обработка ошибок
    });
  }
}

class CartShoesCard extends StatelessWidget {
  final CartShoesResponse item;
  final Future<Uint8List?> loadImage;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete; // Добавлено для удаления

  const CartShoesCard(
      {Key? key,
      required this.item,
      required this.loadImage,
      required this.onQuantityChanged,
      required this.onDelete}) // Добавлено в конструктор
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: loadImage,
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
                        imageUrl:
                            'data:image/png;base64,${base64Encode(snapshot.data!)}',
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                        //placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Container(
                        width: 150,
                        height: 150,
                        child: const CircularProgressIndicator(),
                      ),
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
                          onPressed: onDelete, // Вызов удаления
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
                    '${(item.shoes.shoes.price * item.amount).toStringAsFixed(2)} BYN',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateQuantity(
      BuildContext context, CartShoesResponse item, int newAmount) {
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
      // Обработка ошибок
    });
  }
}
