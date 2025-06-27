import 'package:connect/core/constants/colours.dart';
import 'package:connect/core/theme/theme_provider.dart';
import 'package:connect/core/widgets/buttons/back_button.dart';
import 'package:connect/core/widgets/buttons/submit_button.dart';
import 'package:connect/features/auth/data/repositories/auth_viewmodel_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please login to view settings',
            style: textTheme.bodyLarge,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const CustomBackButton(),
        ),
        title: Text('Settings', style: textTheme.titleLarge),
      ),
      body: ListView(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: KColor.purpleGradient,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    user.firstName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        '@${user.username}',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/user-profile'),
                ),
              ],
            ),
          ),
          const Divider(),

          // Theme Section
          ListTile(
            leading: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Color(0xff9C27B0),
            ),
            title: Text('Dark Mode', style: textTheme.titleMedium),
            trailing: Switch(
              value: isDark,
              onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
              activeColor: Color(0xff9C27B0),
            ),
          ),
          const Divider(),

          // Other Settings
          ListTile(
            leading: Icon(
              Icons.notifications_outlined,
              color: Color(0xff9C27B0),
            ),
            title: Text('Notifications', style: textTheme.titleMedium),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Coming soon!',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.security_outlined,
              color: Color(0xff9C27B0),
            ),
            title: Text('Privacy', style: textTheme.titleMedium),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Coming soon!',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.help_outline,
              color: Color(0xff9C27B0),
            ),
            title: Text('Help & Support', style: textTheme.titleMedium),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Coming soon!',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          const Divider(),

          // Logout Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: SubmitButton(
              isEnabled: true,
              onSubmit: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                }
              },
              buttonText: 'Logout',
              message: '',
            ),
          ),

          // App Version
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Version 1.0.0',
                style: textTheme.bodySmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
