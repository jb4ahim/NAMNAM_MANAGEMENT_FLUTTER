import 'package:flutter/material.dart';
import 'package:namnam/core/Utility/appcolors.dart';

// Generic table column definition
class TableColumn<T> {
  final String title;
  final String key;
  final double width;
  final Widget Function(T item)? customBuilder;
  final bool sortable;
  final String Function(T item)? sortKey;

  const TableColumn({
    required this.title,
    required this.key,
    this.width = 150,
    this.customBuilder,
    this.sortable = false,
    this.sortKey,
  });
}

// Generic table action definition
class TableAction<T> {
  final String label;
  final IconData icon;
  final Color? color;
  final Function(T item)? onPressed;
  final bool Function(T item)? isVisible;

  const TableAction({
    required this.label,
    required this.icon,
    this.color,
    this.onPressed,
    this.isVisible,
  });
}

// Reusable Data Table Widget
class ReusableDataTable<T> extends StatefulWidget {
  final List<T> data;
  final List<TableColumn<T>> columns;
  final List<TableAction<T>>? actions;
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

  const ReusableDataTable({
    super.key,
    required this.data,
    required this.columns,
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
  State<ReusableDataTable<T>> createState() => _ReusableDataTableState<T>();
}

class _ReusableDataTableState<T> extends State<ReusableDataTable<T>> {
  int _currentPage = 0;
  String _searchQuery = '';
  List<T> _filteredData = [];
  String? _sortColumn;
  bool _sortAscending = true;
  int _currentItemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(widget.data);
    _currentItemsPerPage = widget.itemsPerPage;
  }

  @override
  void didUpdateWidget(ReusableDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _filteredData = List.from(widget.data);
      _applySearch();
    }
    if (oldWidget.itemsPerPage != widget.itemsPerPage) {
      _currentItemsPerPage = widget.itemsPerPage;
      _currentPage = 0;
    }
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredData = List.from(widget.data);
    } else {
      _filteredData = widget.data.where((item) {
        return widget.columns.any((column) {
          final value = _getColumnValue(item, column);
          return value.toString().toLowerCase().contains(_searchQuery.toLowerCase());
        });
      }).toList();
    }
    _currentPage = 0;
  }

  void _sortData(String columnKey) {
    final column = widget.columns.firstWhere((col) => col.key == columnKey);
    if (!column.sortable || column.sortKey == null) return;

    setState(() {
      if (_sortColumn == columnKey) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = columnKey;
        _sortAscending = true;
      }

      _filteredData.sort((a, b) {
        final aValue = column.sortKey!(a);
        final bValue = column.sortKey!(b);
        final comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  dynamic _getColumnValue(T item, TableColumn<T> column) {
    // Try to get value using reflection-like approach
    try {
      final dynamic value = (item as dynamic).toJson()[column.key];
      return value ?? '';
    } catch (e) {
      // Fallback: try to access property directly
      try {
        final dynamic value = (item as dynamic).runtimeType.toString();
        return value ?? '';
      } catch (e) {
        return '';
      }
    }
  }

  List<T> get _currentPageData {
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
                      children: _currentPageData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return _buildTableRow(item, index);
                      }).toList(),
                    ),
                  ),
          ),
          
          // Pagination
          if (widget.showPagination) _buildPagination(),
        ],
      ),
    );
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
          ...widget.columns.map((column) => _buildHeaderCell(column.title, column.width)),
          if (widget.actions != null && widget.actions!.isNotEmpty)
            _buildHeaderCell('Actions', 150),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, double width) {
    final column = widget.columns.firstWhere(
      (col) => col.title == title,
      orElse: () => TableColumn(title: title, key: title.toLowerCase()),
    );

    return Container(
      width: width,
      child: InkWell(
        onTap: column.sortable ? () => _sortData(column.key) : null,
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
            if (column.sortable) ...[
              const SizedBox(width: 4),
              Icon(
                _sortColumn == column.key
                    ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.arrow_upward,
                size: 16,
                color: _sortColumn == column.key ? Appcolors.appPrimaryColor : Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(T item, int index) {
    final isAlternate = index % 2 == 1;
    final backgroundColor = isAlternate
        ? (widget.alternateRowBackgroundColor ?? Colors.grey.shade100)
        : (widget.rowBackgroundColor ?? Colors.white);

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
          ...widget.columns.map((column) => _buildTableCell(item, column)),
          if (widget.actions != null && widget.actions!.isNotEmpty)
            _buildActionCell(item),
        ],
      ),
    );
  }

  Widget _buildTableCell(T item, TableColumn<T> column) {
    return Container(
      width: column.width,
      child: column.customBuilder?.call(item) ??
          Text(
            _getColumnValue(item, column).toString(),
            style: const TextStyle(
              fontSize: 14,
              color: Appcolors.textPrimaryColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
    );
  }

  Widget _buildActionCell(T item) {
    final visibleActions = widget.actions!.where((action) {
      return action.isVisible?.call(item) ?? true;
    }).toList();

    return Container(
      width: 150,
      child: Row(
        children: visibleActions.map((action) => IconButton(
          onPressed: () => action.onPressed?.call(item),
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
                'No data available',
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
              Row(
                children: [
                  Text(
                    'Show ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButton<int>(
                      value: _currentItemsPerPage,
                      underline: Container(),
                      items: const [
                        DropdownMenuItem(value: 10, child: Text('10')),
                        DropdownMenuItem(value: 50, child: Text('50')),
                        DropdownMenuItem(value: 100, child: Text('100')),
                      ],
                      onChanged: (value) {
                        if (value != null && value != _currentItemsPerPage) {
                          setState(() {
                            _currentItemsPerPage = value;
                            _currentPage = 0;
                          });
                          // Notify parent widget about the change
                          widget.onItemsPerPageChanged?.call(value);
                        }
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: Appcolors.textPrimaryColor,
                      ),
                    ),
                  ),
                  Text(
                    ' entries',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Right side: Pagination controls
          if (_totalPages > 1)
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
                ...List.generate(_totalPages, (index) {
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
                          color: _currentPage == index ? Appcolors.appPrimaryColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _currentPage == index ? Appcolors.appPrimaryColor : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: _currentPage == index ? Colors.white : Colors.grey.shade600,
                            fontWeight: _currentPage == index ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
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
            )
          else
            // Show a message when there's only one page or no data
            Text(
              _filteredData.isEmpty ? 'No data available' : 'All items shown',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }
} 