import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:namnam/view/Web/Pages/loginWeb.dart';
import 'package:namnam/view/Web/Pages/homeWeb.dart';
import 'package:namnam/core/Utility/Preferences.dart';

class AppRouter {
  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final prefProvider = Provider.of<PrefProvider>(context, listen: false);
        final isLoggedIn = prefProvider.isLoggedIn();
        final isGoingToLogin = state.matchedLocation == '/login';
        
        // If user is logged in and trying to go to login, redirect to home
        if (isLoggedIn && isGoingToLogin) {
          return '/home';
        }
        
        // If user is not logged in and not going to login, redirect to login
        if (!isLoggedIn && !isGoingToLogin) {
          return '/login';
        }
        
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginWebPage(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeWebPage(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.error}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
              ),
      ),
    );
  }
} 