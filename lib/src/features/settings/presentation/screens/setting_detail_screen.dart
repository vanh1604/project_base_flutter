import 'package:flutter/material.dart';

class SettingDetailScreen extends StatelessWidget {
  const SettingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting Detail Screen')),
      body: const Center(child: Text('Welcome to the Setting Detail Screen!')),
    );
  }
}
