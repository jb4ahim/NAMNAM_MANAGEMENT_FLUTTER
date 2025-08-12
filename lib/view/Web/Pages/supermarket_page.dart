import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/view/Web/widgets/custom_toast.dart';
import 'package:namnam/view/Web/widgets/proceedBtn.dart';
import 'package:namnam/view/Web/widgets/reusable_data_table.dart';

class SupermarketPage extends StatefulWidget {
  const SupermarketPage({super.key});

  @override
  State<SupermarketPage> createState() => _SupermarketPageState();
}

class _SupermarketPageState extends State<SupermarketPage> {
  // Supermarket data
  final List<Supermarket> _allSupermarkets = [
    Supermarket(
      id: 1,
      name: 'Fresh Market Beirut',
      owner: 'Samir El Khoury',
      email: 'samir@freshmarket.com',
      phone: '+961 1 234 567',
      address: 'Hamra Street, Beirut',
      status: 'Active',
      rating: 4.6,
      joinDate: '2024-01-05',
      totalProducts: 1250,
    ),
    Supermarket(
      id: 2,
      name: 'City Mart Tripoli',
      owner: 'Nadine Mansour',
      email: 'nadine@citymart.com',
      phone: '+961 6 345 678',
      address: 'Al Mina Road, Tripoli',
      status: 'Active',
      rating: 4.4,
      joinDate: '2024-02-10',
      totalProducts: 980,
    ),
    Supermarket(
      id: 3,
      name: 'Green Valley Sidon',
      owner: 'Rami Saad',
      email: 'rami@greenvalley.com',
      phone: '+961 7 456 789',
      address: 'Saida Main Street',
      status: 'Pending',
      rating: 0.0,
      joinDate: '2024-03-15',
      totalProducts: 0,
    ),
    Supermarket(
      id: 4,
      name: 'Family Store Byblos',
      owner: 'Layla Tannous',
      email: 'layla@familystore.com',
      phone: '+961 9 567 890',
      address: 'Byblos Old Souk',
      status: 'Active',
      rating: 4.7,
      joinDate: '2024-01-25',
      totalProducts: 850,
    ),
    Supermarket(
      id: 5,
      name: 'Mega Market Zahle',
      owner: 'Tony Abi Khalil',
      email: 'tony@megamarket.com',
      phone: '+961 8 678 901',
      address: 'Zahle Downtown',
      status: 'Suspended',
      rating: 4.1,
      joinDate: '2023-12-20',
      totalProducts: 1100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
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
                    Icons.storefront,
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
                        'Supermarket Management',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Appcolors.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your supermarket partners, monitor their performance, and track their products.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                ProceedBtn(
                  text: 'Add Supermarket',
                  color: Appcolors.appPrimaryColor,
                  onPressed: () {
                    // TODO: Implement add supermarket functionality
                    ToastManager.show(
                      context: context,
                      message: 'Add supermarket functionality coming soon!',
                      type: ToastType.success,
                    );
                  },
                  borderRadius: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Supermarket Table
          _buildReusableSupermarketTable(),
        ],
      ),
    );
  }

  Widget _buildReusableSupermarketTable() {
    // Define table columns
    final columns = [
      TableColumn<Supermarket>(
        title: 'ID',
        key: 'id',
        width: 60,
        sortable: true,
        sortKey: (supermarket) => supermarket.id.toString(),
      ),
      TableColumn<Supermarket>(
        title: 'Name',
        key: 'name',
        width: 200,
        sortable: true,
        sortKey: (supermarket) => supermarket.name,
      ),
      TableColumn<Supermarket>(
        title: 'Owner',
        key: 'owner',
        width: 150,
        sortable: true,
        sortKey: (supermarket) => supermarket.owner,
      ),
      TableColumn<Supermarket>(
        title: 'Email',
        key: 'email',
        width: 200,
        sortable: true,
        sortKey: (supermarket) => supermarket.email,
      ),
      TableColumn<Supermarket>(
        title: 'Phone',
        key: 'phone',
        width: 120,
        sortable: false,
      ),
      TableColumn<Supermarket>(
        title: 'Address',
        key: 'address',
        width: 200,
        sortable: true,
        sortKey: (supermarket) => supermarket.address,
      ),
      TableColumn<Supermarket>(
        title: 'Status',
        key: 'status',
        width: 100,
        sortable: true,
        sortKey: (supermarket) => supermarket.status,
        customBuilder: (supermarket) => _buildSupermarketStatusCell(supermarket.status),
      ),
      TableColumn<Supermarket>(
        title: 'Rating',
        key: 'rating',
        width: 80,
        sortable: true,
        sortKey: (supermarket) => supermarket.rating.toString(),
        customBuilder: (supermarket) => _buildRatingCell(supermarket.rating),
      ),
      TableColumn<Supermarket>(
        title: 'Products',
        key: 'totalProducts',
        width: 100,
        sortable: true,
        sortKey: (supermarket) => supermarket.totalProducts.toString(),
      ),
      TableColumn<Supermarket>(
        title: 'Join Date',
        key: 'joinDate',
        width: 120,
        sortable: true,
        sortKey: (supermarket) => supermarket.joinDate,
      ),
    ];

    // Define table actions
    final actions = [
      TableAction<Supermarket>(
        label: 'View',
        icon: Icons.visibility,
        color: Appcolors.appPrimaryColor,
        onPressed: (supermarket) {
          // TODO: Implement view supermarket details
          ToastManager.show(
            context: context,
            message: 'Viewing supermarket: ${supermarket.name}',
            type: ToastType.success,
          );
        },
      ),
      TableAction<Supermarket>(
        label: 'Edit',
        icon: Icons.edit,
        color: Colors.blue,
        onPressed: (supermarket) {
          // TODO: Implement edit supermarket
          ToastManager.show(
            context: context,
            message: 'Editing supermarket: ${supermarket.name}',
            type: ToastType.success,
          );
        },
      ),
      TableAction<Supermarket>(
        label: 'Suspend',
        icon: Icons.block,
        color: Colors.red,
        onPressed: (supermarket) {
          // TODO: Implement suspend supermarket
          ToastManager.show(
            context: context,
            message: 'Suspending supermarket: ${supermarket.name}',
            type: ToastType.error,
          );
        },
        isVisible: (supermarket) => supermarket.status == 'Active',
      ),
      TableAction<Supermarket>(
        label: 'Activate',
        icon: Icons.check_circle,
        color: Colors.green,
        onPressed: (supermarket) {
          // TODO: Implement activate supermarket
          ToastManager.show(
            context: context,
            message: 'Activating supermarket: ${supermarket.name}',
            type: ToastType.success,
          );
        },
        isVisible: (supermarket) => supermarket.status != 'Active',
      ),
    ];

    return ReusableDataTable<Supermarket>(
      data: _allSupermarkets,
      columns: columns,
      actions: actions,
      title: 'Supermarkets List',
      showSearch: true,
      showPagination: true,
      itemsPerPage: 10,
      onSearch: (query) {
        // TODO: Implement search functionality
        print('Searching for: $query');
      },
      onItemsPerPageChanged: (itemsPerPage) {
        // TODO: Handle items per page change
        print('Items per page changed to: $itemsPerPage');
      },
    );
  }

  Widget _buildSupermarketStatusCell(String status) {
    final isActive = status == 'Active';
    final isSuspended = status == 'Suspended';
    final isPending = status == 'Pending';
    
    Color backgroundColor;
    Color textColor;
    
    if (isActive) {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade700;
    } else if (isSuspended) {
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red.shade700;
    } else if (isPending) {
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade700;
    } else {
      backgroundColor = Colors.grey.shade100;
      textColor = Colors.grey.shade700;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildRatingCell(double rating) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Appcolors.textPrimaryColor,
          ),
        ),
      ],
    );
  }
}

class Supermarket {
  final int id;
  final String name;
  final String owner;
  final String email;
  final String phone;
  final String address;
  final String status;
  final double rating;
  final String joinDate;
  final int totalProducts;

  Supermarket({
    required this.id,
    required this.name,
    required this.owner,
    required this.email,
    required this.phone,
    required this.address,
    required this.status,
    required this.rating,
    required this.joinDate,
    required this.totalProducts,
  });
} 