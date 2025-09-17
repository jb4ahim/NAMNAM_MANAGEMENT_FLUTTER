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
import 'package:namnam/view/Web/Pages/zones_page.dart';
import 'package:namnam/model/menu_item.dart';
import 'package:namnam/viewmodel/menu_view_model.dart';
import 'package:namnam/view/Web/widgets/dashboard_analytics.dart';
import 'package:namnam/view/Web/widgets/comprehensive_analytics.dart';
import 'package:namnam/viewmodel/categories_view_model.dart';
import 'package:namnam/viewmodel/zones_view_model.dart';
import 'package:namnam/viewmodel/merchants_view_model.dart';
import 'package:namnam/viewmodel/customers_view_model.dart';
import 'package:namnam/viewmodel/orders_view_model.dart';

class HomeWebPage extends StatefulWidget {
  const HomeWebPage({super.key});

  @override
  State<HomeWebPage> createState() => _HomeWebPageState();
}

class _HomeWebPageState extends State<HomeWebPage> {
  int _selectedIndex = 0;
  bool _isMenuCollapsed = false;

  @override
  void initState() {
    super.initState();
    // Load data for dashboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoriesViewModel = Provider.of<CategoriesViewModel>(context, listen: false);
      final zonesViewModel = Provider.of<ZonesViewModel>(context, listen: false);
      final merchantsViewModel = Provider.of<MerchantsViewModel>(context, listen: false);
      final customersViewModel = Provider.of<CustomersViewModel>(context, listen: false);
      final ordersViewModel = Provider.of<OrdersViewModel>(context, listen: false);
      
      categoriesViewModel.fetchCategories();
      zonesViewModel.fetchZones();
      merchantsViewModel.fetchMerchants();
      customersViewModel.fetchCustomers();
      ordersViewModel.fetchOrders();
    });
  }







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
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Appcolors.appPrimaryColor,
                        Appcolors.appPrimaryColor.withOpacity(0.8),
                      ],
                    )
                  : isHovered
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        )
                      : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Appcolors.appPrimaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : isHovered
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _onMenuTap(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.2)
                              : isHovered
                                  ? Colors.white.withOpacity(0.15)
                                  : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          menuItem.icon,
                          color: isSelected 
                              ? Colors.white 
                              : isHovered
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          menuItem.title,
                          style: TextStyle(
                            color: isSelected 
                                ? Colors.white 
                                : isHovered
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.9),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCollapsedMenuItem(MenuItem menuItem, int index, bool isSelected) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Appcolors.appPrimaryColor,
                        Appcolors.appPrimaryColor.withOpacity(0.8),
                      ],
                    )
                  : isHovered
                      ? LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                          ],
                        )
                      : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Appcolors.appPrimaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : isHovered
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _onMenuTap(index),
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.all(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : isHovered
                              ? Colors.white.withOpacity(0.15)
                              : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      menuItem.icon,
                      color: isSelected 
                          ? Colors.white 
                          : isHovered
                              ? Colors.white
                              : Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
      case 'zones':
        return const ZonesPage();
      case 'analytics':
        return const AnalyticsPage();
      case 'settings':
        return const SettingsPage();
      case 'notifications':
        return const NotificationsPage();
      case 'push notifications':
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
                  child: Image.asset(
                    "assets/logo/namnam_white_logo.png",
                    height: 32,
                    width: 32,
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
          Consumer5<CategoriesViewModel, ZonesViewModel, MerchantsViewModel, CustomersViewModel, OrdersViewModel>(
            builder: (context, categoriesViewModel, zonesViewModel, merchantsViewModel, customersViewModel, ordersViewModel, child) {
              return Column(
                children: [
                  DashboardAnalytics(
                    categories: categoriesViewModel.categories,
                    zones: zonesViewModel.zones,
                  ),
                  const SizedBox(height: 32),
                  ComprehensiveAnalytics(
                    drivers: [],
                    merchants: merchantsViewModel.merchants,
                    customers: customersViewModel.customers,
                    orders: ordersViewModel.orders,
                  ),
                ],
              );
            },
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
          // Modern Side Menu
          Container(
            width: _isMenuCollapsed ? 80 : 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A1A2E),
                  const Color(0xFF16213E),
                  const Color(0xFF0F3460),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(8, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                // Modern App Logo/Title with Toggle Button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Appcolors.appPrimaryColor.withOpacity(0.1),
                        Appcolors.appPrimaryColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(32),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: _isMenuCollapsed
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Appcolors.appPrimaryColor,
                                    Appcolors.appPrimaryColor.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Appcolors.appPrimaryColor.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                "assets/logo/namnam_white_logo.png",
                                height: 28,
                                width: 28,
                              ),
                            ),
                            const SizedBox(height: 20),
                            StatefulBuilder(
                              builder: (context, setState) {
                                bool isHovered = false;
                                
                                return MouseRegion(
                                  onEnter: (_) => setState(() => isHovered = true),
                                  onExit: (_) => setState(() => isHovered = false),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: isHovered
                                            ? [
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.1),
                                              ]
                                            : [
                                                Colors.white.withOpacity(0.1),
                                                Colors.white.withOpacity(0.05),
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: isHovered
                                          ? [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: IconButton(
                                      icon: AnimatedRotation(
                                        turns: isHovered ? 0.125 : 0,
                                        duration: const Duration(milliseconds: 200),
                                        child: Icon(
                                          Icons.chevron_right,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      onPressed: _toggleMenu,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Appcolors.appPrimaryColor,
                                    Appcolors.appPrimaryColor.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Appcolors.appPrimaryColor.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                "assets/logo/namnam_white_logo.png",
                                height: 28,
                                width: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NamNam',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    'Management',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatefulBuilder(
                              builder: (context, setState) {
                                bool isHovered = false;
                                
                                return MouseRegion(
                                  onEnter: (_) => setState(() => isHovered = true),
                                  onExit: (_) => setState(() => isHovered = false),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: isHovered
                                            ? [
                                                Colors.white.withOpacity(0.2),
                                                Colors.white.withOpacity(0.1),
                                              ]
                                            : [
                                                Colors.white.withOpacity(0.1),
                                                Colors.white.withOpacity(0.05),
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: isHovered
                                          ? [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: const Offset(0, 1),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: IconButton(
                                      icon: AnimatedRotation(
                                        turns: isHovered ? -0.125 : 0,
                                        duration: const Duration(milliseconds: 200),
                                        child: Icon(
                                          Icons.chevron_left,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      onPressed: _toggleMenu,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ),
                // Modern Divider
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Modern Menu Items
                Expanded(
                  child: Consumer<MenuViewModel>(
                    builder: (context, menuViewModel, child) {
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        itemCount: menuViewModel.menuItems.length,
                        itemBuilder: (context, index) {
                          final menuItem = menuViewModel.menuItems[index];
                          final isSelected = _selectedIndex == index;
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: _isMenuCollapsed
                                ? _buildCollapsedMenuItem(menuItem, index, isSelected)
                                : _buildExpandedMenuItem(menuItem, index, isSelected),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Bottom Spacing
                const SizedBox(height: 20),
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


 
 