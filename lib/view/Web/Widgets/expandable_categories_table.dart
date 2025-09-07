import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/model/category.dart';
import 'package:namnam/viewmodel/categories_view_model.dart';
import 'package:provider/provider.dart';
import 'package:namnam/view/Web/widgets/reusable_data_table.dart';

class ExpandableCategoriesTable extends StatefulWidget {
  final List<Category> categories;
  final List<TableAction<Category>>? actions;
  final String? title;
  final bool showSearch;
  final bool showPagination;
  final int itemsPerPage;
  final Function(String)? onSearch;
  final Function(int)? onItemsPerPageChanged;
  final Widget? emptyStateWidget;
  final bool showHeader;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final Color? alternateRowBackgroundColor;
  final double tableHeight;
  final bool showRowNumbers;

  const ExpandableCategoriesTable({
    super.key,
    required this.categories,
    this.actions,
    this.title,
    this.showSearch = false,
    this.showPagination = true,
    this.itemsPerPage = 10,
    this.onSearch,
    this.onItemsPerPageChanged,
    this.emptyStateWidget,
    this.showHeader = true,
    this.headerBackgroundColor,
    this.rowBackgroundColor,
    this.alternateRowBackgroundColor,
    this.tableHeight = 600,
    this.showRowNumbers = false,
  });

  @override
  State<ExpandableCategoriesTable> createState() => _ExpandableCategoriesTableState();
}

class _ExpandableCategoriesTableState extends State<ExpandableCategoriesTable> {
  int _currentPage = 0;
  String _searchQuery = '';
  List<Category> _filteredData = [];
  String? _sortColumn;
  bool _sortAscending = true;
  int _currentItemsPerPage = 10;
  
  // Expandable state management
  Set<int> _expandedCategories = {};
  Map<int, List<Category>> _subcategories = {};
  Map<int, bool> _loadingSubcategories = {};

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(widget.categories);
    _currentItemsPerPage = widget.itemsPerPage;
  }

  @override
  void didUpdateWidget(ExpandableCategoriesTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categories != widget.categories) {
      _filteredData = List.from(widget.categories);
      _applySearch();
    }
    if (oldWidget.itemsPerPage != widget.itemsPerPage) {
      _currentItemsPerPage = widget.itemsPerPage;
      _currentPage = 0;
    }
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredData = List.from(widget.categories);
    } else {
      _filteredData = widget.categories.where((category) {
        return category.categoryName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               (category.status?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }
    _currentPage = 0;
  }

  void _sortData(String columnKey) {
    setState(() {
      if (_sortColumn == columnKey) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = columnKey;
        _sortAscending = true;
      }

      _filteredData.sort((a, b) {
        int comparison = 0;
        switch (columnKey) {
          case 'categoryName':
            comparison = a.categoryName.compareTo(b.categoryName);
            break;
          case 'status':
            comparison = (a.status ?? '').compareTo(b.status ?? '');
            break;
          case 'createdAt':
            comparison = a.createdAt.compareTo(b.createdAt);
            break;
          default:
            comparison = 0;
        }
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  Future<void> _toggleExpansion(Category category) async {
    print('Toggle expansion for category: ${category.categoryName} (ID: ${category.categoryId})');
    
    if (_expandedCategories.contains(category.categoryId)) {
      // Collapse
      print('Collapsing category: ${category.categoryName}');
      setState(() {
        _expandedCategories.remove(category.categoryId);
      });
    } else {
      // Expand - fetch subcategories
      print('Expanding category: ${category.categoryName} - fetching subcategories...');
      setState(() {
        _expandedCategories.add(category.categoryId);
        _loadingSubcategories[category.categoryId] = true;
      });

      try {
        final categoriesViewModel = Provider.of<CategoriesViewModel>(context, listen: false);
        final subcategories = await categoriesViewModel.fetchSubcategories(category.categoryId);
        
        if (mounted) {
          print('Found ${subcategories.length} subcategories for ${category.categoryName}');
          setState(() {
            _subcategories[category.categoryId] = subcategories;
            _loadingSubcategories[category.categoryId] = false;
          });
        }
      } catch (e) {
        print('Error fetching subcategories: $e');
        if (mounted) {
          setState(() {
            _loadingSubcategories[category.categoryId] = false;
          });
        }
      }
    }
  }

  List<Category> get _currentPageData {
    final startIndex = _currentPage * _currentItemsPerPage;
    final endIndex = (startIndex + _currentItemsPerPage).clamp(0, _filteredData.length);
    return _filteredData.sublist(startIndex, endIndex);
  }

  int get _totalPages => (_filteredData.length / _currentItemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.tableHeight,
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
        children: [
          // Table Header
          if (widget.showHeader) _buildTableHeader(),
          
          // Table Body with ScrollView
          Expanded(
            child: _filteredData.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    child: Column(
                      children: _buildAllRows(),
                    ),
                  ),
          ),
          
          // Pagination
          if (widget.showPagination) _buildPagination(),
        ],
      ),
    );
  }

  List<Widget> _buildAllRows() {
    List<Widget> rows = [];
    
    for (int i = 0; i < _currentPageData.length; i++) {
      final category = _currentPageData[i];
      final isAlternate = i % 2 == 1;
      
      // Add parent row
      rows.add(_buildTableRow(category, i, isAlternate));
      
      // Add subcategories if expanded
      if (_expandedCategories.contains(category.categoryId)) {
        final subcategories = _subcategories[category.categoryId] ?? [];
        
        if (_loadingSubcategories[category.categoryId] == true) {
          // Loading state
          rows.add(_buildLoadingRow(category.categoryId));
        } else if (subcategories.isNotEmpty) {
          // Subcategories
          for (int j = 0; j < subcategories.length; j++) {
            final subcategory = subcategories[j];
            rows.add(_buildSubcategoryRow(subcategory, j, category.categoryId, category.categoryName));
          }
        } else {
          // No subcategories - show success message
          rows.add(_buildNoSubcategoriesRow(category.categoryId));
        }
      }
    }
    
    return rows;
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.headerBackgroundColor ?? Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          if (widget.showRowNumbers) _buildHeaderCell('#', 60),
          _buildHeaderCell('Image', 80),
          _buildHeaderCell('Name', 200, sortable: true, sortKey: 'categoryName'),
          _buildHeaderCell('Parent', 150),
          _buildHeaderCell('Status', 140),
          if (widget.actions != null && widget.actions!.isNotEmpty)
            _buildHeaderCell('Actions', 150),
          _buildHeaderCell('', 40), // Expand/collapse column at the end
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, double width, {bool sortable = false, String? sortKey}) {
    return Container(
      width: width,
      child: InkWell(
        onTap: sortable ? () => _sortData(sortKey!) : null,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Appcolors.textPrimaryColor,
                ),
              ),
            ),
            if (sortable) ...[
              const SizedBox(width: 4),
              Icon(
                _sortColumn == sortKey
                    ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.arrow_upward,
                size: 16,
                color: _sortColumn == sortKey ? Appcolors.appPrimaryColor : Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(Category category, int index, bool isAlternate) {
    final backgroundColor = isAlternate
        ? (widget.alternateRowBackgroundColor ?? Colors.grey.shade100)
        : (widget.rowBackgroundColor ?? Colors.white);

    final isExpanded = _expandedCategories.contains(category.categoryId);
    final hasSubcategories = true; // All categories can potentially have subcategories

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.showRowNumbers)
            Container(
              width: 60,
              child: Text(
                '${_currentPage * _currentItemsPerPage + index + 1}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          // Image
          Container(
            width: 80,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(category.displayImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Spacing between image and name
          const SizedBox(width: 20),
          // Name
          Container(
            width: 200,
            child: Text(
              category.categoryName,
              style: const TextStyle(
                fontSize: 14,
                color: Appcolors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Parent
          Container(
            width: 150,
            child: Text(
              category.parentName,
              style: TextStyle(
                color: category.parentId == null || category.parentId == 0 ? Colors.grey.shade500 : Appcolors.textPrimaryColor,
                fontStyle: category.parentId == null || category.parentId == 0 ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
          // Status
          Container(
            width: 140,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (category.status ?? 'inactive') == 'active' 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (category.status ?? 'inactive') == 'active' ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  category.status ?? 'inactive',
                  style: TextStyle(
                    color: (category.status ?? 'inactive') == 'active' ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Actions
          if (widget.actions != null && widget.actions!.isNotEmpty)
            _buildActionCell(category),
          // Expand/collapse button at the end
          Container(
            width: 40,
            child: hasSubcategories
                ? IconButton(
                    onPressed: () => _toggleExpansion(category),
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Appcolors.appPrimaryColor,
                    ),
                    tooltip: isExpanded ? 'Collapse' : 'Expand',
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoryRow(Category subcategory, int index, int parentId, String parentName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.showRowNumbers)
            Container(
              width: 60,
              child: Text(
                '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          // Indent for subcategory
          Container(
            width: 40,
            child: Row(
              children: [
                const SizedBox(width: 20),
                Container(
                  width: 2,
                  height: 20,
                  color: Appcolors.appPrimaryColor.withOpacity(0.3),
                ),
              ],
            ),
          ),
          // Image
          Container(
            width: 80,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(subcategory.displayImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Name (no extra spacing for subcategories to maintain alignment)
          Container(
            width: 200,
            child: Text(
              subcategory.categoryName,
              style: const TextStyle(
                fontSize: 14,
                color: Appcolors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Parent
          Container(
            width: 150,
            child: Text(
              parentName,
              style: TextStyle(
                color: Appcolors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Status
          Container(
            width: 140,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (subcategory.status ?? 'inactive') == 'active' 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (subcategory.status ?? 'inactive') == 'active' ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  subcategory.status ?? 'inactive',
                  style: TextStyle(
                    color: (subcategory.status ?? 'inactive') == 'active' ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Actions
          if (widget.actions != null && widget.actions!.isNotEmpty)
            _buildActionCell(subcategory),
        ],
      ),
    );
  }

  Widget _buildLoadingRow(int parentId) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.showRowNumbers)
            Container(width: 60),
          Container(
            width: 40,
            child: Row(
              children: [
                const SizedBox(width: 20),
                Container(
                  width: 2,
                  height: 20,
                  color: Appcolors.appPrimaryColor.withOpacity(0.3),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Appcolors.appPrimaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading subcategories...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSubcategoriesRow(int parentId) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.showRowNumbers)
            Container(width: 60),
          Container(
            width: 40,
            child: Row(
              children: [
                const SizedBox(width: 20),
                Container(
                  width: 2,
                  height: 20,
                  color: Appcolors.appPrimaryColor.withOpacity(0.3),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Successfully loaded - No subcategories available',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCell(Category category) {
    if (widget.actions == null) return Container(width: 150);
    
    final visibleActions = widget.actions!.where((action) {
      return action.isVisible?.call(category) ?? true;
    }).toList();

    return Container(
      width: 150,
      child: Row(
        children: visibleActions.map((action) => IconButton(
          onPressed: () => action.onPressed?.call(category),
          icon: Icon(
            action.icon,
            color: action.color ?? Appcolors.appPrimaryColor,
            size: 20,
          ),
          tooltip: action.label,
        )).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: widget.emptyStateWidget ??
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.table_rows,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No categories available',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildPagination() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Entries info and items per page selector
          Row(
            children: [
              Text(
                'Showing ${_currentPage * _currentItemsPerPage + 1} to ${(_currentPage + 1) * _currentItemsPerPage > _filteredData.length ? _filteredData.length : (_currentPage + 1) * _currentItemsPerPage} of ${_filteredData.length} entries',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                'Show:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _currentItemsPerPage,
                items: [10, 25, 50, 100].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currentItemsPerPage = newValue;
                      _currentPage = 0;
                    });
                    widget.onItemsPerPageChanged?.call(newValue);
                  }
                },
              ),
            ],
          ),
          
          // Right side: Pagination controls
          Row(
            children: [
              IconButton(
                onPressed: _currentPage > 0 ? () {
                  setState(() {
                    _currentPage--;
                  });
                } : null,
                icon: const Icon(Icons.chevron_left),
                color: _currentPage > 0 ? Appcolors.appPrimaryColor : Colors.grey,
              ),
              
              // Page numbers
              ...List.generate(_totalPages, (index) {
                if (index == _currentPage ||
                    index == 0 ||
                    index == _totalPages - 1 ||
                    (index >= _currentPage - 1 && index <= _currentPage + 1)) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: index == _currentPage ? Appcolors.appPrimaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: index == _currentPage ? Appcolors.appPrimaryColor : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: index == _currentPage ? Colors.white : Appcolors.textPrimaryColor,
                            fontWeight: index == _currentPage ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (index == _currentPage - 2 || index == _currentPage + 2) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '...',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              
              IconButton(
                onPressed: _currentPage < _totalPages - 1 ? () {
                  setState(() {
                    _currentPage++;
                  });
                } : null,
                icon: const Icon(Icons.chevron_right),
                color: _currentPage < _totalPages - 1 ? Appcolors.appPrimaryColor : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
