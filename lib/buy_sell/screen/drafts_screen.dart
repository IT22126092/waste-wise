import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:waste_management/buy_sell/const/colors.dart';
import 'package:waste_management/buy_sell/model/garbage_item.dart';
import 'package:waste_management/buy_sell/screen/add_garbage.dart';
import 'package:waste_management/buy_sell/screen/edit_screen.dart';

class Draft_Screen extends StatefulWidget {
  const Draft_Screen({super.key});

  @override
  State<Draft_Screen> createState() => _Draft_ScreenState();
}

bool show = true;

class _Draft_ScreenState extends State<Draft_Screen> {
  // Reference to Firestore collection
  final CollectionReference garbageCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('garbageItems');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Add_creen(),
            ));
          },
          backgroundColor: custom_green,
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                show = true;
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                show = false;
              });
            }
            return true;
          },
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: garbageCollection.snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final garbageItems = snapshot.data!.docs.map((doc) {
                      return GarbageItem.fromSnapshot(doc);
                    }).toList();

                    if (garbageItems.isEmpty) {
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
                      itemCount: garbageItems.length,
                      itemBuilder: (context, index) {
                        final garbageItem = garbageItems[index];
                        return ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/$index.jpg', // Use the image index from Firestore
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            garbageItem.selectedCategory,
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          subtitle: Text(
                              '${garbageItem.description}\nPrice: ${garbageItem.price}\nContact: ${garbageItem.contactNumber}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Edit_Screen(garbageItem),
                                  ));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteGarbageItem(garbageItem.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to delete a garbage item from Firestore
  void _deleteGarbageItem(String id) async {
    await garbageCollection.doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Garbage item deleted')),
    );
  }
}