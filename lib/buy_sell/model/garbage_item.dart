import 'package:cloud_firestore/cloud_firestore.dart';

class GarbageItem {
  final String id;
  final String selectedCategory;
  final String quantity;
  final String description;
  final String price;
  final String contactNumber;
  final String time;
  final bool isDone;
  final int image; // Field for the image represented as an int

  GarbageItem({
    required this.id,
    required this.selectedCategory,
    required this.quantity,
    required this.description,
    required this.price,
    required this.contactNumber,
    required this.time,
    required this.isDone,
    required this.image, // Accept image as int in the constructor
  });

  // fromSnapshot method to create a GarbageItem from a Firestore snapshot
  factory GarbageItem.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GarbageItem(
      id: doc.id, // Get document ID
      selectedCategory: data['selectedCategory'] as String,
      quantity: data['quantity'] as String? ?? '0', // Handle null for quantity
      description: data['description'] as String,
      price: data['price'] as String,
      contactNumber: data['contactNumber'] as String,
      time: data['time'] as String,
      isDone: (data['isDone'] as bool?) ?? false, // Default to false if null
      image: data['image'] as int? ??
          0, // Retrieve image as int, default to 0 if null
    );
  }
}