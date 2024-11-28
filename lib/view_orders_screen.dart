import 'package:flutter/material.dart';
import 'package:food_ordering_app/database_helper.dart';
import 'order.dart'; // the imports for associated linked dart files

class ViewOrdersScreen extends StatefulWidget {
  @override
  _ViewOrdersScreenState createState() => _ViewOrdersScreenState();
}

class _ViewOrdersScreenState extends State<ViewOrdersScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
  }

  // the method to grab the orders by date
  Future<void> _fetchOrders(String date) async {
    List<Map<String, dynamic>> orderMaps = await dbHelper.getOrderPlansByDate(date);

    setState(() {
      orders = orderMaps.map((map) => Order.fromMap(map)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Orders'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (date) {
                _fetchOrders(date);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text(order.foodItem),
                  subtitle: Text('Price: \$${order.price}'),
                  trailing: Text('Date: ${order.date}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
