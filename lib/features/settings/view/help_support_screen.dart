import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: const [
            Text(
              'Help & Support',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Need assistance? We are here to help!\n',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Frequently Asked Questions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('- How do I reset my password?\n  Go to login screen and tap on "Forgot Password".\n', style: TextStyle(fontSize: 16)),
            Text('- How do I contact support?\n  Email us at support@connectapp.com.\n', style: TextStyle(fontSize: 16)),
            Text('- How do I report a bug or user?\n  Use the in-app report feature or contact support.\n', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('If you need further help, email support@connectapp.com', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
