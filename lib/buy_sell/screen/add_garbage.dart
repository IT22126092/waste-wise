import 'package:flutter/material.dart';
import 'package:waste_management/buy_sell/const/colors.dart';
import 'package:waste_management/buy_sell/data/firestor.dart';

class Add_creen extends StatefulWidget {
  const Add_creen({super.key});

  @override
  State<Add_creen> createState() => _Add_creenState();
}

class _Add_creenState extends State<Add_creen> {
  final TextEditingController quantity = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController contactNumber = TextEditingController();

  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _contactFocus = FocusNode();

  final List<String> categories = [
    'Paper',
    'Plastic',
    'Metal',
    'Wood',
    'Organic Waste',
    'Glass'
  ];

  String? selectedCategory;
  int indexx = 0;

  @override
  void dispose() {
    quantity.dispose();
    description.dispose();
    price.dispose();
    contactNumber.dispose();
    _quantityFocus.dispose();
    _descriptionFocus.dispose();
    _priceFocus.dispose();
    _contactFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Add Garbage Item'),
        backgroundColor: custom_green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCategoryField(),
              const SizedBox(height: 20),
              _buildQuantityField(),
              const SizedBox(height: 20),
              _buildDescriptionField(),
              const SizedBox(height: 20),
              _buildPriceField(),
              const SizedBox(height: 20),
              _buildContactField(),
              const SizedBox(height: 20),
              imagess(), // Display image picker widget
              const SizedBox(height: 30),
              _buildButtonRow(),
            ],
          ),
        ),
      ),
    );
  }

  Container imagess() {
    return Container(
      height: 180,
      child: ListView.builder(
        itemCount: 6, // You can customize the number of images available
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                indexx = index; // Update the selected index
              });
            },
            child: Padding(
              padding: EdgeInsets.only(left: index == 0 ? 7 : 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: indexx == index ? custom_green : Colors.grey,
                  ),
                ),
                width: 140,
                margin: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.asset(
                        'assets/images/${index}.jpg'), // Display image from assets folder
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: custom_green,
            minimumSize: const Size(170, 48),
          ),
          onPressed: () async {
            if (selectedCategory == null ||
                quantity.text.isEmpty ||
                description.text.isEmpty ||
                price.text.isEmpty ||
                contactNumber.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all fields')),
              );
              return;
            }

            // Call Firestore to add the item without imageUrl (as we're using integer for image)
            bool success = await Firestore_Datasource().addGarbageItem(
              selectedCategory!,
              quantity.text,
              description.text,
              price.text,
              contactNumber.text,
              indexx, // Use selectedImage as integer
            );

            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Garbage item added successfully!')),
              );
              Navigator.pop(context); // Close the screen on success
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to add item. Try again!')),
              );
            }
          },
          child: const Text('Add Garbage'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(170, 48),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        hint: const Text('Select Category'),
        items: categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue;
          });
        },
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffc5c5c5),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: quantity,
        focusNode: _quantityFocus,
        style: const TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: 'Quantity',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffc5c5c5),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: description,
        focusNode: _descriptionFocus,
        maxLines: 3,
        style: const TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: 'Description',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffc5c5c5),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: price,
        focusNode: _priceFocus,
        style: const TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: 'Price',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffc5c5c5),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: contactNumber,
        focusNode: _contactFocus,
        style: const TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          hintText: 'Contact Number',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xffc5c5c5),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}