import 'package:flutter/material.dart';
import 'add_order_screen.dart';
import 'view_orders_screen.dart' as view;
import 'manage_orders_screen.dart' as manage;
import 'database_helper.dart'; // refers to the DB helper dart file
import 'package:intl/intl.dart'; // enables the calendar for the user

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  double targetCost = 0.0;
  String selectedDate = '';
  List<int> selectedFoodItems = []; // Displays the food numbers for the user
  List<Map<String, dynamic>> foodItems = [];

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    final items = await dbHelper.getFoodItems(); // grabs the 20 food items from DB
    setState(() {
      foodItems = items;
    });
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _saveOrderPlan() async {
    if (selectedDate.isNotEmpty && selectedFoodItems.isNotEmpty && targetCost > 0) {
      String selectedFoodItemsString = selectedFoodItems.join(', ');

      // Allows the user to save the food
      await dbHelper.saveOrderPlan(selectedDate, targetCost, selectedFoodItemsString);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Food order is now saved')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please choose your date, target cost and meal')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doordash 2.0',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.deepPurple, // color to match the theme
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: _selectDate,
                child: Text(
                  'Select Date: ${selectedDate.isEmpty ? 'Not selected' : selectedDate}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Target Cost',
                  labelStyle: TextStyle(color: Colors.deepPurple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.deepPurpleAccent),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    targetCost = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Select Food Items:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = foodItems[index];
                  return CheckboxListTile(
                    title: Text(
                      foodItem['name'],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      '\$${foodItem['price']}',
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                    activeColor: Colors.orangeAccent,
                    value: selectedFoodItems.contains(foodItem['id']),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          selectedFoodItems.add(foodItem['id']);
                        } else {
                          selectedFoodItems.remove(foodItem['id']);
                        }
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveOrderPlan,
                child: Text('Save Order'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  textStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddOrderScreen()),
                      );
                    },
                    child: Text('Add Order'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete functionality not implemented yet')));
                    },
                    child: Text('Delete Order'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => manage.ManageOrdersScreen()),
                      );
                    },
                    child: Text('Manage Orders'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
