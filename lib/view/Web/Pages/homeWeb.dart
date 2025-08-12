import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/view/Web/widgets/custom_toast.dart';

import 'package:namnam/core/Utility/Preferences.dart';
import 'package:provider/provider.dart';
import 'package:namnam/view/Web/Pages/drivers_page.dart';
import 'package:namnam/view/Web/Pages/supermarket_page.dart';
import 'package:namnam/view/Web/Pages/categories_page.dart';
import 'package:namnam/view/Web/Pages/merchants_page.dart';
import 'package:namnam/view/Web/Pages/orders_page.dart';
import 'package:namnam/view/Web/Pages/push_notifications_page.dart';
import 'package:namnam/view/Web/Pages/users_page.dart';
import 'package:namnam/view/Web/Pages/analytics_page.dart';
import 'package:namnam/view/Web/Pages/settings_page.dart';
import 'package:namnam/view/Web/Pages/notifications_page.dart';
import 'package:namnam/view/Web/Pages/reports_page.dart';
import 'package:namnam/model/menu_item.dart';
import 'package:namnam/viewmodel/menu_view_model.dart';

class HomeWebPage extends StatefulWidget {
  const HomeWebPage({super.key});

  @override
  State<HomeWebPage> createState() => _HomeWebPageState();
}

class _HomeWebPageState extends State<HomeWebPage> {
  int _selectedIndex = 0;
  bool _isMenuCollapsed = false;







  void _onMenuTap(int index) {
    final menuViewModel = Provider.of<MenuViewModel>(context, listen: false);
    final menuItem = menuViewModel.menuItems[index];
    
    switch (menuItem.action) {
      case MenuAction.navigate:
        // TODO: Navigate to specific page or show content
        setState(() {
          _selectedIndex = index;
        });
        break;
      case MenuAction.logout:
        // Get preferences provider and clear login data
        final prefProvider = Provider.of<PrefProvider>(context, listen: false);
        prefProvider.logout();
        
        // Show logout toast before navigating
        ToastManager.show(
          context: context,
          message: "Log out completed",
          type: ToastType.error,
        );
        // Navigate to login page
        context.go(menuItem.route);
        break;
    }
  }

  void _toggleMenu() {
    if (mounted) {
      setState(() {
        _isMenuCollapsed = !_isMenuCollapsed;
      });
    }
  }

  Widget _buildExpandedMenuItem(MenuItem menuItem, int index, bool isSelected) {
    return ListTile(
      leading: Icon(
        menuItem.icon,
        color: isSelected ? Colors.white : Appcolors.appPrimaryColor,
      ),
      title: Text(
        menuItem.title,
        style: TextStyle(
          color: isSelected ? Colors.white : Appcolors.textPrimaryColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Appcolors.appPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onTap: () => _onMenuTap(index),
    );
  }

  Widget _buildCollapsedMenuItem(MenuItem menuItem, int index, bool isSelected) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isSelected ? Appcolors.appPrimaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          menuItem.icon,
          color: isSelected ? Colors.white : Appcolors.appPrimaryColor,
          size: 24,
        ),
        onPressed: () => _onMenuTap(index),
        tooltip: menuItem.title, // Shows tooltip on hover
      ),
    );
  }

  Widget _buildContent() {
    try {
      final menuViewModel = Provider.of<MenuViewModel>(context, listen: false);
      final selectedItem = menuViewModel.menuItems[_selectedIndex];
      
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selectedItem.icon,
                  size: 32,
                  color: Appcolors.appPrimaryColor,
                ),
                const SizedBox(width: 16),
                Text(
                  selectedItem.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Appcolors.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: _buildPageContent(selectedItem),
            ),
          ],
        ),
      );
    } catch (e) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Error loading content: $e',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  Widget _buildPageContent(MenuItem menuItem) {
    switch (menuItem.title.toLowerCase()) {
      case 'dashboard':
        return _buildDashboardContent();
      case 'categories':
        return const CategoriesPage();
      case 'merchants':
        return const MerchantsPage();
      case 'orders':
        return const OrdersPage();
      case 'drivers':
        return const DriversPage();
      case 'supermarket':
        return const SupermarketPage();
      case 'users':
        return const UsersPage();
      case 'analytics':
        return const AnalyticsPage();
      case 'settings':
        return const SettingsPage();
      case 'notifications':
        return const NotificationsPage();
      case 'push-notifications':
        return const PushNotificationsPage();
      case 'reports':
        return const ReportsPage();
      default:
        return _buildDefaultContent(menuItem);
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
              border: Border.all(
                color: Colors.grey.shade100,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Appcolors.appPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.dashboard,
                    color: Appcolors.appPrimaryColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Appcolors.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Here\'s what\'s happening with your NamNam Management system today.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Appcolors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard('Total Users', '1,234', Icons.people),
              const SizedBox(width: 24),
              _buildStatCard('Active Sessions', '89', Icons.online_prediction),
              const SizedBox(width: 24),
              _buildStatCard('Reports Generated', '45', Icons.assessment),
            ],
          ),
          const SizedBox(height: 32),
          _buildRecentActivityCard(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Appcolors.appPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Appcolors.appPrimaryColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              value,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Appcolors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Appcolors.appPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.history,
                  color: Appcolors.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Appcolors.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildActivityItem('New user registered', '2 minutes ago', Icons.person_add),
          _buildActivityItem('Report generated', '15 minutes ago', Icons.assessment),
          _buildActivityItem('System backup completed', '1 hour ago', Icons.backup),
          _buildActivityItem('Settings updated', '2 hours ago', Icons.settings),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Appcolors.appPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Appcolors.appPrimaryColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



















  Widget _buildDefaultContent(MenuItem menuItem) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            menuItem.icon,
            size: 120,
            color: Appcolors.appPrimaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            menuItem.title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Appcolors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This page is under development',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: Row(
          children: [
          // Side Menu
          Container(
            width: _isMenuCollapsed ? 80 : 280,
            decoration: BoxDecoration(
              color: Appcolors.sideMenuBackground,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(4, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                // App Logo/Title with Toggle Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Appcolors.sideMenuBackground,
                  ),
                  child: _isMenuCollapsed
                      ? Column(
                          children: [
                            Icon(
                              Icons.restaurant,
                              size: 32,
                              color: Appcolors.appPrimaryColor,
                            ),
                            const SizedBox(height: 16),
                            IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                color: Appcolors.appPrimaryColor,
                              ),
                              onPressed: _toggleMenu,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Icon(
                              Icons.restaurant,
                              size: 32,
                              color: Appcolors.appPrimaryColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'NamNam',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Appcolors.appPrimaryColor,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                color: Appcolors.appPrimaryColor,
                              ),
                              onPressed: _toggleMenu,
                            ),
                          ],
                        ),
                ),
                const Divider(),
                // Menu Items
                Expanded(
                  child: Consumer<MenuViewModel>(
                    builder: (context, menuViewModel, child) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: menuViewModel.menuItems.length,
                        itemBuilder: (context, index) {
                          final menuItem = menuViewModel.menuItems[index];
                          final isSelected = _selectedIndex == index;
                          
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: _isMenuCollapsed
                                ? _buildCollapsedMenuItem(menuItem, index, isSelected)
                                : _buildExpandedMenuItem(menuItem, index, isSelected),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade50,
                    Colors.white,
                    Colors.grey.shade100,
                  ],
                ),
              ),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
    } catch (e) {
      return Scaffold(
        body: Center(
          child: Text(
            'Error building page: $e',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
}


 