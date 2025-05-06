import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<String> orders = [
    'Заказ #1 - Дата: 2023-05-01',
    'Заказ #2 - Дата: 2023-05-02',
    'Заказ #3 - Дата: 2023-05-03',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заказы'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('Нет заказов'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(orders[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteOrder(index);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addOrder,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addOrder() {
    setState(() {
      orders.add('Заказ #${orders.length + 1} - Дата: ${DateTime.now().toLocal()}');
    });
  }

  void _deleteOrder(int index) {
    setState(() {
      orders.removeAt(index);
    });
  }
}