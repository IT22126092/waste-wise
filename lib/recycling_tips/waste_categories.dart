import 'package:flutter/material.dart';

class WasteCategoriesScreen extends StatefulWidget {
  const WasteCategoriesScreen({super.key});

  @override
  _WasteCategoriesScreenState createState() => _WasteCategoriesScreenState();
}

class _WasteCategoriesScreenState extends State<WasteCategoriesScreen> {
  int _selectedIndex = 0; // Track the current selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });

    // Handle navigation based on the selected index
    // For example:
    switch (index) {
      case 0:
      // Navigate to Home screen
        break;
      case 1:
      // Navigate to Reminders screen
        break;
      case 2:
      // Navigate to Campaigns screen
        break;
      case 3:
      // Navigate to Buy and Sell screen
        break;
      case 4:
      // Navigate to Lookup screen
        break;
      case 5:
      // Navigate to Profile screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Categories'),
        centerTitle: true,
          backgroundColor: const Color(0xFF00C04B)
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What do you need to recycle/dispose of?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle lookup item by photo functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Lookup Item By Photo'),
              ),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: 6, // Adjust based on the number of categories
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      // Handle category selection
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.category,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Category ${index + 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // Removed bottomNavigationBar property
    );
  }
}
