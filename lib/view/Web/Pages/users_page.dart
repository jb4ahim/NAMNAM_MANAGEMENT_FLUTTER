import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            size: 120,
            color: Appcolors.appPrimaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            'Users Management',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Appcolors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Manage your users, permissions, and access controls',
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