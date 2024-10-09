import 'package:flutter/material.dart';
import 'package:waste_management/buy_sell/screen/drafts_screen.dart';

class Sell_Screen extends StatefulWidget {
  const Sell_Screen({super.key});

  @override
  State<Sell_Screen> createState() => _Sell_ScreenState();
}

bool show = true;

class _Sell_ScreenState extends State<Sell_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace For Recyclable Materials'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Main Title
            Text(
              'List Your Waste, Earn With Ease',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Sell Your Recyclables Here',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Image Row
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/0.png',
                    width: 100, height: 100), // Replace with your image
                SizedBox(width: 10),
                Image.asset('images/0.jpg',
                    width: 100, height: 100), // Replace with your image
                SizedBox(width: 10),
                Image.asset('image/0.jpg',
                    width: 100, height: 100), // Replace with your image
              ],
            ),*/
            SizedBox(height: 20),
            // Subtitle
            Text(
              'Turn your recyclables into cash by selling them here. Post your items, connect with buyers, and contribute to a greener planet. Simple, fast, and rewarding!',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Tips
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.green),
                    title: Text('Be Specific In Your Description'),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.green),
                    title: Text('Set Competitive Prices'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Sell Garbage Button

            // View My Sellings Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Draft_Screen()), // Navigating to Drafts Screen
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50), // Full-width button
              ),
              child: Text(
                'Sell Garbage',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}