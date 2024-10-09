import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waste_management/buy_sell/const/colors.dart';
import 'package:waste_management/buy_sell/model/garbage_item.dart';

class Buy_Screen extends StatefulWidget {
  const Buy_Screen({super.key});

  @override
  State<Buy_Screen> createState() => _Buy_ScreenState();
}

class _Buy_ScreenState extends State<Buy_Screen> {
  // Reference to Firestore collection
  final CollectionReference garbageCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('garbageItems');

  // Variables for filtering
  String selectedCategory = 'All';
  List<String> categories = [
    'All',
    'Plastic',
    'Paper',
    'Metal',
    'Wood',
    'Glass',
    'Organic Waste'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      appBar: AppBar(
        title: Text('Available Garbage Items'),
        backgroundColor: custom_green,
        actions: [
          DropdownButton<String>(
            value: selectedCategory,
            icon: Icon(Icons.filter_list, color: Colors.white),
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category, style: TextStyle(color: Colors.black)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue!;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: garbageCollection.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final garbageItems = snapshot.data!.docs.map((doc) {
              return GarbageItem.fromSnapshot(doc);
            }).toList();

            // Filter items based on selected category
            final filteredGarbageItems = selectedCategory == 'All'
                ? garbageItems
                : garbageItems
                .where((item) => item.selectedCategory == selectedCategory)
                .toList();

            if (filteredGarbageItems.isEmpty) {
              return Center(
                child: Text(
                  'No garbage items available',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold),
                ),
              );
            }

            return ListView.builder(
              itemCount: filteredGarbageItems.length,
              itemBuilder: (context, index) {
                final garbageItem = filteredGarbageItems[index];
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/${index}.jpg', // Use the image index from Firestore
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    garbageItem.selectedCategory,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  subtitle: Text(
                    '${garbageItem.description}\nQuantity: ${garbageItem.quantity}\nPrice: ${garbageItem.price}\nContact: ${garbageItem.contactNumber}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_red_eye, color: Colors.blue),
                    onPressed: () {
                      // Optionally, add functionality to show more details about the item
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(garbageItem.selectedCategory),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/${index}.jpg', // Use the image index from Firestore
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${garbageItem.description}\nQuantity: ${garbageItem.quantity}\nPrice: ${garbageItem.price}\nContact: ${garbageItem.contactNumber}',
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}