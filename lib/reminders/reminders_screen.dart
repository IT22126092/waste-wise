// reminders_screen.dart
import 'package:flutter/material.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00C04B),
      ),
      body: Center(
        child: const Text(
          'This is the Reminders screen.\nSet your waste collection and recycling reminders here.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
