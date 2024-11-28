import 'package:flutter/material.dart';

class AddOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Order',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.shade100,
                Colors.orange.shade50,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Text(
            'This is where your orders get added',
            style: TextStyle(
              fontSize: 18,
              color: Colors.deepPurple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
