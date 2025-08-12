import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';

class MerchantsPage extends StatelessWidget {
  const MerchantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store,
            size: 120,
            color: Appcolors.appPrimaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            'Merchants Management',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Appcolors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Manage your registered merchants and their store information',
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