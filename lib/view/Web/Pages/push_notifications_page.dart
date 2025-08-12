import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';

class PushNotificationsPage extends StatelessWidget {
  const PushNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_active,
            size: 120,
            color: Appcolors.appPrimaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            'Push Notifications',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Appcolors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Send targeted notifications to your users with Firebase Cloud Messaging',
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