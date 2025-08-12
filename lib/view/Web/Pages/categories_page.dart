import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/view/Web/widgets/custom_toast.dart';
import 'package:namnam/view/Web/widgets/proceedBtn.dart';
import 'package:namnam/view/Web/widgets/reusable_data_table.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  // Categories data
  final List<Category> _allCategories = [
    Category(
      id: 1,
      name: 'Electronics',
      parent: null,
      imageUrl: 'https://via.placeholder.com/50x50/FF6B6B/FFFFFF?text=E',
      status: 'Active',
    ),
    Category(
      id: 2,
      name: 'Smartphones',
      parent: 'Electronics',
      imageUrl: 'https://via.placeholder.com/50x50/4ECDC4/FFFFFF?text=S',
      status: 'Active',
    ),
    Category(
      id: 3,
      name: 'Laptops',
      parent: 'Electronics',
      imageUrl: 'https://via.placeholder.com/50x50/45B7D1/FFFFFF?text=L',
      status: 'Active',
    ),
    Category(
      id: 4,
      name: 'Clothing',
      parent: null,
      imageUrl: 'https://via.placeholder.com/50x50/96CEB4/FFFFFF?text=C',
      status: 'Active',
    ),
    Category(
      id: 5,
      name: 'Men\'s Wear',
      parent: 'Clothing',
      imageUrl: 'https://via.placeholder.com/50x50/FFEAA7/FFFFFF?text=M',
      status: 'Inactive',
    ),
    Category(
      id: 6,
      name: 'Women\'s Wear',
      parent: 'Clothing',
      imageUrl: 'https://via.placeholder.com/50x50/DDA0DD/FFFFFF?text=W',
      status: 'Active',
    ),
    Category(
      id: 7,
      name: 'Books',
      parent: null,
      imageUrl: 'https://via.placeholder.com/50x50/98D8C8/FFFFFF?text=B',
      status: 'Active',
    ),
    Category(
      id: 8,
      name: 'Fiction',
      parent: 'Books',
      imageUrl: 'https://via.placeholder.com/50x50/F7DC6F/FFFFFF?text=F',
      status: 'Active',
    ),
    Category(
      id: 9,
      name: 'Non-Fiction',
      parent: 'Books',
      imageUrl: 'https://via.placeholder.com/50x50/BB8FCE/FFFFFF?text=N',
      status: 'Inactive',
    ),
    Category(
      id: 10,
      name: 'Sports',
      parent: null,
      imageUrl: 'https://via.placeholder.com/50x50/85C1E9/FFFFFF?text=S',
      status: 'Active',
    ),
    Category(
      id: 11,
      name: 'Fitness',
      parent: 'Sports',
      imageUrl: 'https://via.placeholder.com/50x50/F8C471/FFFFFF?text=F',
      status: 'Active',
    ),
    Category(
      id: 12,
      name: 'Outdoor',
      parent: 'Sports',
      imageUrl: 'https://via.placeholder.com/50x50/82E0AA/FFFFFF?text=O',
      status: 'Active',
    ),
    Category(
      id: 13,
      name: 'Home & Garden',
      parent: null,
      imageUrl: 'https://via.placeholder.com/50x50/F39C12/FFFFFF?text=H',
      status: 'Active',
    ),
    Category(
      id: 14,
      name: 'Kitchen',
      parent: 'Home & Garden',
      imageUrl: 'https://via.placeholder.com/50x50/E74C3C/FFFFFF?text=K',
      status: 'Active',
    ),
    Category(
      id: 15,
      name: 'Furniture',
      parent: 'Home & Garden',
      imageUrl: 'https://via.placeholder.com/50x50/9B59B6/FFFFFF?text=F',
      status: 'Inactive',
    ),
    Category(
      id: 16,
      name: 'Automotive',
      parent: null,
      imageUrl: 'https://via.placeholder.com/50x50/34495E/FFFFFF?text=A',
      status: 'Active',
    ),
    Category(
      id: 17,
      name: 'Cars',
      parent: 'Automotive',
      imageUrl: 'https://via.placeholder.com/50x50/1ABC9C/FFFFFF?text=C',
      status: 'Active',
    ),
    Category(
      id: 18,
      name: 'Motorcycles',
      parent: 'Automotive',
      imageUrl: 'https://via.placeholder.com/50x50/2ECC71/FFFFFF?text=M',
      status: 'Active',
    ),
    Category(
      id: 19,
      name: 'Health & Beauty',
      parent: null,
      imageUrl: 'https://via.placeholder.com/50x50/E67E22/FFFFFF?text=H',
      status: 'Active',
    ),
    Category(
      id: 20,
      name: 'Skincare',
      parent: 'Health & Beauty',
      imageUrl: 'https://via.placeholder.com/50x50/8E44AD/FFFFFF?text=S',
      status: 'Active',
    ),
    Category(
      id: 21,
      name: 'Makeup',
      parent: 'Health & Beauty',
      imageUrl: 'https://via.placeholder.com/50x50/16A085/FFFFFF?text=M',
      status: 'Inactive',
    ),
    Category(
      id: 22,
      name: 'Toys & Games',
      parent: null,
      imageUrl: 'https://via.placeholder.com/50x50/F1C40F/FFFFFF?text=T',
      status: 'Active',
    ),
    Category(
      id: 23,
      name: 'Board Games',
      parent: 'Toys & Games',
      imageUrl: 'https://via.placeholder.com/50x50/E74C3C/FFFFFF?text=B',
      status: 'Active',
    ),
    Category(
      id: 24,
      name: 'Video Games',
      parent: 'Toys & Games',
      imageUrl: 'https://via.placeholder.com/50x50/3498DB/FFFFFF?text=V',
      status: 'Active',
    ),
    Category(
      id: 25,
      name: 'Food & Beverages',
      parent: null,
      imageUrl: 'https://via.placeholder.com/50x50/27AE60/FFFFFF?text=F',
      status: 'Active',
    ),
    Category(
      id: 26,
      name: 'Snacks',
      parent: 'Food & Beverages',
      imageUrl: 'https://via.placeholder.com/50x50/8B4513/FFFFFF?text=S',
      status: 'Active',
    ),
    Category(
      id: 27,
      name: 'Beverages',
      parent: 'Food & Beverages',
      imageUrl: 'https://via.placeholder.com/50x50/FF6B35/FFFFFF?text=B',
      status: 'Inactive',
    ),
    Category(
      id: 28,
      name: 'Jewelry',
      parent: null,
      imageUrl: 'https://via.placeholder.com/50x50/FFD700/FFFFFF?text=J',
      status: 'Active',
    ),
    Category(
      id: 29,
      name: 'Necklaces',
      parent: 'Jewelry',
      imageUrl: 'https://via.placeholder.com/50x50/C0C0C0/FFFFFF?text=N',
      status: 'Active',
    ),
    Category(
      id: 30,
      name: 'Watches',
      parent: 'Jewelry',
      imageUrl: 'https://via.placeholder.com/50x50/000000/FFFFFF?text=W',
      status: 'Active',
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
                    Icons.category,
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
                        'Categories Management',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Appcolors.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your product categories and subcategories',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                ProceedBtn(
                  text: 'Add Category',
                  color: Appcolors.appPrimaryColor,
                  onPressed: () {
                    // TODO: Implement add category functionality
                    ToastManager.show(
                      context: context,
                      message: 'Add category functionality coming soon!',
                      type: ToastType.success,
                    );
                  },
                  borderRadius: 12,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Reusable Table
          _buildReusableCategoriesTable(),
        ],
      ),
    );
  }

  Widget _buildReusableCategoriesTable() {
    // Define table columns
    final columns = [
      TableColumn<Category>(
        title: 'ID',
        key: 'id',
        width: 60,
        sortable: true,
        sortKey: (category) => category.id.toString(),
      ),
      TableColumn<Category>(
        title: 'Image',
        key: 'imageUrl',
        width: 80,
        customBuilder: (category) => Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(category.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      TableColumn<Category>(
        title: 'Name',
        key: 'name',
        width: 200,
        sortable: true,
        sortKey: (category) => category.name,
      ),
      TableColumn<Category>(
        title: 'Parent',
        key: 'parent',
        width: 150,
        customBuilder: (category) => Text(
          category.parent ?? 'None',
          style: TextStyle(
            color: category.parent == null ? Colors.grey.shade500 : Appcolors.textPrimaryColor,
            fontStyle: category.parent == null ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ),
      TableColumn<Category>(
        title: 'Status',
        key: 'status',
        width: 100,
        customBuilder: (category) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: category.status == 'Active' 
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: category.status == 'Active' ? Colors.green : Colors.red,
              width: 1,
            ),
          ),
          child: Text(
            category.status,
            style: TextStyle(
              color: category.status == 'Active' ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ];

    // Define table actions
    final actions = [
      TableAction<Category>(
        label: 'Edit',
        icon: Icons.edit,
        color: Appcolors.appPrimaryColor,
        onPressed: (category) {
          // TODO: Implement edit functionality
          ToastManager.show(
            context: context,
            message: 'Edit ${category.name}',
            type: ToastType.success,
          );
        },
      ),
      TableAction<Category>(
        label: 'Toggle Status',
        icon: Icons.block,
        color: Colors.red,
        onPressed: (category) {
          // TODO: Implement status toggle
          ToastManager.show(
            context: context,
            message: 'Toggle ${category.name} status',
            type: ToastType.success,
          );
        },
        isVisible: (category) => category.status == 'Active',
      ),
      TableAction<Category>(
        label: 'Activate',
        icon: Icons.check_circle,
        color: Colors.green,
        onPressed: (category) {
          // TODO: Implement activate functionality
          ToastManager.show(
            context: context,
            message: 'Activate ${category.name}',
            type: ToastType.success,
          );
        },
        isVisible: (category) => category.status == 'Inactive',
      ),
    ];

    return ReusableDataTable<Category>(
      data: _allCategories,
      columns: columns,
      actions: actions,
      itemsPerPage: 10,
      showRowNumbers: true,
      tableHeight: 600,
      onItemsPerPageChanged: (newItemsPerPage) {
        // Handle items per page change if needed
        // For example, you could save this preference or make an API call
        print('Items per page changed to: $newItemsPerPage');
      },
    );
  }
}

class Category {
  final int id;
  final String name;
  final String? parent;
  final String imageUrl;
  final String status;

  Category({
    required this.id,
    required this.name,
    this.parent,
    required this.imageUrl,
    required this.status,
  });
} 