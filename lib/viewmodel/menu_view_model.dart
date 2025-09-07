import 'package:flutter/material.dart';
import 'package:namnam/model/menu_item.dart';

class MenuViewModel extends ChangeNotifier {
  List<MenuItem> _menuItems = [
    MenuItem(
      icon: Icons.dashboard,
      title: 'Dashboard',
      action: MenuAction.navigate,
      route: '/dashboard',
    ),
    MenuItem(
      icon: Icons.category,
      title: 'Categories',
      action: MenuAction.navigate,
      route: '/categories',
    ),
    MenuItem(
      icon: Icons.store,
      title: 'Merchants',
      action: MenuAction.navigate,
      route: '/merchants',
    ),
    MenuItem(
      icon: Icons.shopping_cart,
      title: 'Orders',
      action: MenuAction.navigate,
      route: '/orders',
    ),
    MenuItem(
      icon: Icons.local_shipping,
      title: 'Drivers',
      action: MenuAction.navigate,
      route: '/drivers',
    ),
    MenuItem(
      icon: Icons.storefront,
      title: 'Supermarket',
      action: MenuAction.navigate,
      route: '/supermarket',
    ),
    MenuItem(
      icon: Icons.people,
      title: 'Users',
      action: MenuAction.navigate,
      route: '/users',
    ),
    MenuItem(
      icon: Icons.map,
      title: 'Zones',
      action: MenuAction.navigate,
      route: '/zones',
    ),
    MenuItem(
      icon: Icons.analytics,
      title: 'Analytics',
      action: MenuAction.navigate,
      route: '/analytics',
    ),
    MenuItem(
      icon: Icons.settings,
      title: 'Settings',
      action: MenuAction.navigate,
      route: '/settings',
    ),
    MenuItem(
      icon: Icons.notifications,
      title: 'Notifications',
      action: MenuAction.navigate,
      route: '/notifications',
    ),
    MenuItem(
      icon: Icons.notifications_active,
      title: 'Push Notifications',
      action: MenuAction.navigate,
      route: '/push-notifications',
    ),
    MenuItem(
      icon: Icons.assessment,
      title: 'Reports',
      action: MenuAction.navigate,
      route: '/reports',
    ),
    MenuItem(
      icon: Icons.logout,
      title: 'Logout',
      action: MenuAction.logout,
      route: '/login',
    ),
  ];

  List<MenuItem> get menuItems => _menuItems;

  // Method to add a new menu item
  void addMenuItem(MenuItem menuItem) {
    _menuItems.add(menuItem);
    notifyListeners();
  }

  // Method to remove a menu item by index
  void removeMenuItem(int index) {
    if (index >= 0 && index < _menuItems.length) {
      _menuItems.removeAt(index);
      notifyListeners();
    }
  }

  // Method to update a menu item
  void updateMenuItem(int index, MenuItem newMenuItem) {
    if (index >= 0 && index < _menuItems.length) {
      _menuItems[index] = newMenuItem;
      notifyListeners();
    }
  }

  // Method to reorder menu items
  void reorderMenuItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final MenuItem item = _menuItems.removeAt(oldIndex);
    _menuItems.insert(newIndex, item);
    notifyListeners();
  }

  // Method to get menu item by title
  MenuItem? getMenuItemByTitle(String title) {
    try {
      return _menuItems.firstWhere((item) => item.title.toLowerCase() == title.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  // Method to get menu item by route
  MenuItem? getMenuItemByRoute(String route) {
    try {
      return _menuItems.firstWhere((item) => item.route == route);
    } catch (e) {
      return null;
    }
  }
} 