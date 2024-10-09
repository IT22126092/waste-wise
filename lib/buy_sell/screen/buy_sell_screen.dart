import 'package:flutter/material.dart';
import 'package:waste_management/buy_sell/screen/Buy_screen.dart';
import 'package:waste_management/buy_sell/screen/Sell_Screen.dart';

class Home_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garbage Management'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Welcome to Garbage Management!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Background color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    // Navigate to "Buy" screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Buy_Screen()),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.shopping_cart, size: 30),
                      SizedBox(height: 10),
                      Text('Buy Garbage', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to "Sell" screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Sell_Screen()),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.sell, size: 30),
                      SizedBox(height: 10),
                      Text('Sell Garbage', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              'Manage and recycle garbage efficiently!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}