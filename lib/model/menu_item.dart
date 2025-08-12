import 'package:flutter/material.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final MenuAction action;
  final String route;

  MenuItem({
    required this.icon,
    required this.title,
    required this.action,
    required this.route,
  });
}

enum MenuAction {
  navigate,
  logout,
} 