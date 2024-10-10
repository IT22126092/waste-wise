import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waste_management/buy_sell/model/garbage_item.dart';
import 'package:uuid/uuid.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      print(e);
      return false; // Return false in case of error
    }
  }

  Future<bool> addGarbageItem(
      String selectedCategory,
      String quantity,
      String description,
      String price,
      String contactNumber,
      int image, // Change imageUrl to int image
      ) async {
    try {
      var uuid = const Uuid().v4(); // Generate unique ID
      DateTime data = DateTime.now(); // Get current time
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('garbageItems')
          .doc(uuid)
          .set({
        'id': uuid,
        'selectedCategory': selectedCategory,
        'quantity': quantity,
        'description': description,
        'price': price,
        'contactNumber': contactNumber,
        'time': '${data.hour}:${data.minute}', // Save current time
        'isDon': false, // Default value for isDon
        'image': image, // Save the image as int
      });
      return true; // Return true if Firestore operation is successful
    } catch (e) {
      print('Error adding item: $e'); // Print the error for debugging
      return false; // Return false if there is an error
    }
  }

  // Corrected getGarbageItems method to properly handle Firestore data
  List<GarbageItem> getGarbageItems(QuerySnapshot snapshot) {
    try {
      final garbageList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>; // Ensure it's a Map
        return GarbageItem(
          id: data['id'], // Make sure to use named parameters
          selectedCategory: data['selectedCategory'],
          quantity: data['quantity'],
          description: data['description'],
          price: data['price'],
          contactNumber: data['contactNumber'],
          time: data['time'],
          isDone: data['isDon'],
          image: data['image'], // Retrieve image as int from Firestore
        );
      }).toList();
      return garbageList;
    } catch (e) {
      print('Error parsing items: $e');
      return [];
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('garbageItems')
        .where('isDon', isEqualTo: isDone)
        .snapshots();
  }

  Future<bool> updateIsDone(String uuid, bool isDone) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('garbageItems')
          .doc(uuid)
          .update({'isDon': isDone});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateGarbageItem(
      String uuid,
      String selectedCategory,
      String quantity,
      String description,
      String price,
      String contactNumber,
      int image, // Change imageUrl to int image
      ) async {
    try {
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('garbageItems')
          .doc(uuid)
          .update({
        'time': '${data.hour}:${data.minute}',
        'selectedCategory': selectedCategory,
        'description': description,
        'price': price,
        'contactNumber': contactNumber,
        'image': image, // Update the image as int if provided
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteGarbageItem(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('garbageItems')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}