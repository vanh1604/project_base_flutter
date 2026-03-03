import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting Screen')),
      body: Column(
        children: [
          const Center(child: Text('Welcome to the Setting Screen!')),
          ElevatedButton(
            onPressed: () {
              context.go('/settings/details');
            },
            child: const Text('Go to Setting Details'),
          ),
        ],
      ),
    );
  }
}
