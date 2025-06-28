import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: const [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'We value your privacy. This app collects only the minimum information required to provide our services. Your data is never sold or shared with third parties except as required by law.\n',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Information We Collect:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('- Account information (name, email, username)\n- Content you create (posts, comments)\n- Usage data (app interactions, device info)\n', style: TextStyle(fontSize: 16)),
            Text(
              'How We Use Your Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('- To provide and improve our services\n- To personalize your experience\n- To communicate important updates\n', style: TextStyle(fontSize: 16)),
            Text(
              'Your Rights:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('- You can update or delete your account at any time.\n- You can contact us for any privacy concerns.\n', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('For more details, contact support@connectapp.com', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
