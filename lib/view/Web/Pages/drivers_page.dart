import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/view/Web/widgets/custom_toast.dart';
import 'package:namnam/view/Web/widgets/proceedBtn.dart';
import 'package:namnam/view/Web/widgets/reusable_data_table.dart';

class DriversPage extends StatefulWidget {
  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  // Drivers data
  final List<Driver> _allDrivers = [
    Driver(
      id: 1,
      name: 'Ali Hassan',
      email: 'ali.hassan@namnam.com',
      phone: '+961 70 111 111',
      vehicleNumber: 'ABC-123',
      vehicleType: 'Motorcycle',
      status: 'Active',
      rating: 4.7,
      joinDate: '2024-01-10',
      completedDeliveries: 156,
    ),
    Driver(
      id: 2,
      name: 'Omar Khalil',
      email: 'omar.khalil@namnam.com',
      phone: '+961 71 222 222',
      vehicleNumber: 'XYZ-456',
      vehicleType: 'Car',
      status: 'Active',
      rating: 4.5,
      joinDate: '2024-02-15',
      completedDeliveries: 142,
    ),
    Driver(
      id: 3,
      name: 'Ahmed Mansour',
      email: 'ahmed.mansour@namnam.com',
      phone: '+961 76 333 333',
      vehicleNumber: 'DEF-789',
      vehicleType: 'Motorcycle',
      status: 'Inactive',
      rating: 4.2,
      joinDate: '2024-03-05',
      completedDeliveries: 89,
    ),
    Driver(
      id: 4,
      name: 'Hassan Fares',
      email: 'hassan.fares@namnam.com',
      phone: '+961 78 444 444',
      vehicleNumber: 'GHI-012',
      vehicleType: 'Car',
      status: 'Active',
      rating: 4.8,
      joinDate: '2024-01-20',
      completedDeliveries: 203,
    ),
    Driver(
      id: 5,
      name: 'Karim Ali',
      email: 'karim.ali@namnam.com',
      phone: '+961 79 555 555',
      vehicleNumber: 'JKL-345',
      vehicleType: 'Motorcycle',
      status: 'Suspended',
      rating: 3.9,
      joinDate: '2024-02-28',
      completedDeliveries: 67,
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
                    Icons.local_shipping,
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
                        'Drivers Management',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Appcolors.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your delivery drivers, track their performance, and monitor their status.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                ProceedBtn(
                  text: 'Add Driver',
                  color: Appcolors.appPrimaryColor,
                  onPressed: () {
                    // TODO: Implement add driver functionality
                    ToastManager.show(
                      context: context,
                      message: 'Add driver functionality coming soon!',
                      type: ToastType.success,
                    );
                  },
                  borderRadius: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Drivers Table
          _buildReusableDriversTable(),
        ],
      ),
    );
  }

  Widget _buildReusableDriversTable() {
    // Define table columns
    final columns = [
      TableColumn<Driver>(
        title: 'ID',
        key: 'id',
        width: 60,
        sortable: true,
        sortKey: (driver) => driver.id.toString(),
      ),
      TableColumn<Driver>(
        title: 'Name',
        key: 'name',
        width: 150,
        sortable: true,
        sortKey: (driver) => driver.name,
      ),
      TableColumn<Driver>(
        title: 'Email',
        key: 'email',
        width: 200,
        sortable: true,
        sortKey: (driver) => driver.email,
      ),
      TableColumn<Driver>(
        title: 'Phone',
        key: 'phone',
        width: 120,
        sortable: false,
      ),
      TableColumn<Driver>(
        title: 'Vehicle',
        key: 'vehicleNumber',
        width: 100,
        sortable: true,
        sortKey: (driver) => driver.vehicleNumber,
      ),
      TableColumn<Driver>(
        title: 'Type',
        key: 'vehicleType',
        width: 100,
        sortable: true,
        sortKey: (driver) => driver.vehicleType,
      ),
      TableColumn<Driver>(
        title: 'Status',
        key: 'status',
        width: 100,
        sortable: true,
        sortKey: (driver) => driver.status,
        customBuilder: (driver) => _buildDriverStatusCell(driver.status),
      ),
      TableColumn<Driver>(
        title: 'Rating',
        key: 'rating',
        width: 80,
        sortable: true,
        sortKey: (driver) => driver.rating.toString(),
        customBuilder: (driver) => _buildRatingCell(driver.rating),
      ),
      TableColumn<Driver>(
        title: 'Deliveries',
        key: 'completedDeliveries',
        width: 100,
        sortable: true,
        sortKey: (driver) => driver.completedDeliveries.toString(),
      ),
      TableColumn<Driver>(
        title: 'Join Date',
        key: 'joinDate',
        width: 120,
        sortable: true,
        sortKey: (driver) => driver.joinDate,
      ),
    ];

    // Define table actions
    final actions = [
      TableAction<Driver>(
        label: 'View',
        icon: Icons.visibility,
        color: Appcolors.appPrimaryColor,
        onPressed: (driver) {
          // TODO: Implement view driver details
          ToastManager.show(
            context: context,
            message: 'Viewing driver: ${driver.name}',
            type: ToastType.success,
          );
        },
      ),
      TableAction<Driver>(
        label: 'Edit',
        icon: Icons.edit,
        color: Colors.blue,
        onPressed: (driver) {
          // TODO: Implement edit driver
          ToastManager.show(
            context: context,
            message: 'Editing driver: ${driver.name}',
            type: ToastType.success,
          );
        },
      ),
      TableAction<Driver>(
        label: 'Suspend',
        icon: Icons.block,
        color: Colors.red,
        onPressed: (driver) {
          // TODO: Implement suspend driver
          ToastManager.show(
            context: context,
            message: 'Suspending driver: ${driver.name}',
            type: ToastType.error,
          );
        },
        isVisible: (driver) => driver.status == 'Active',
      ),
      TableAction<Driver>(
        label: 'Activate',
        icon: Icons.check_circle,
        color: Colors.green,
        onPressed: (driver) {
          // TODO: Implement activate driver
          ToastManager.show(
            context: context,
            message: 'Activating driver: ${driver.name}',
            type: ToastType.success,
          );
        },
        isVisible: (driver) => driver.status != 'Active',
      ),
    ];

    return ReusableDataTable<Driver>(
      data: _allDrivers,
      columns: columns,
      actions: actions,
      title: 'Drivers List',
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

  Widget _buildDriverStatusCell(String status) {
    final isActive = status == 'Active';
    final isSuspended = status == 'Suspended';
    
    Color backgroundColor;
    Color textColor;
    
    if (isActive) {
      backgroundColor = Colors.green.shade100;
      textColor = Colors.green.shade700;
    } else if (isSuspended) {
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red.shade700;
    } else {
      backgroundColor = Colors.orange.shade100;
      textColor = Colors.orange.shade700;
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

class Driver {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String vehicleNumber;
  final String vehicleType;
  final String status;
  final double rating;
  final String joinDate;
  final int completedDeliveries;

  Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.status,
    required this.rating,
    required this.joinDate,
    required this.completedDeliveries,
  });
} 