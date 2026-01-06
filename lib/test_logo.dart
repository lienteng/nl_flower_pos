import 'package:flutter/material.dart';

class TestLogoScreen extends StatelessWidget {
  const TestLogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Logo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Testing logo.png:'),
            const SizedBox(height: 20),
            Image.asset(
              'assets/img/logo.png',
              width: 200,
              errorBuilder: (context, error, stackTrace) {
                return Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 10),
                    Text('Error: $error'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
