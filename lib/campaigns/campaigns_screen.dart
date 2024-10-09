import 'package:flutter/material.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaigns'),
        centerTitle: true, // This will center-align the title
        backgroundColor: const Color(0xFF00C04B),
      ),
      body: const Center(
        child: Text(
          'This is the Campaigns screen.\nJoin community campaigns for better waste management.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
