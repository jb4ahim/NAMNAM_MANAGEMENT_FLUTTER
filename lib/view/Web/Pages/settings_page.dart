import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings,
            size: 120,
            color: Appcolors.appPrimaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            'System Settings',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Appcolors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Configure system preferences and application settings',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
} 