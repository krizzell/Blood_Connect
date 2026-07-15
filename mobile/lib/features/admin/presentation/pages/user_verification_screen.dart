import 'package:flutter/material.dart';

class UserVerificationScreen extends StatelessWidget {
  const UserVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Users'),
        backgroundColor: const Color(0xFFC62828), // Dark Red
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('User Verification Screen Coming Soon...'),
      ),
    );
  }
}
