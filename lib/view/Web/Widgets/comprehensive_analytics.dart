import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/view/Web/Pages/drivers_page.dart';
import 'package:namnam/model/merchant.dart';
import 'package:namnam/model/customer.dart';
import 'package:namnam/model/order.dart';
import 'package:namnam/view/Web/widgets/chart_loading_animation.dart';
import 'package:namnam/view/Web/widgets/metric_loading_animation.dart';
import 'package:namnam/view/Web/widgets/chart_fade_animation.dart';

class ComprehensiveAnalytics extends StatefulWidget {
  final List<Driver> drivers;
  final List<Merchant> merchants;
  final List<Customer> customers;
  final List<Order> orders;

  const ComprehensiveAnalytics({
    super.key,
    required this.drivers,
    required this.merchants,
    required this.customers,
    required this.orders,
  });

  @override
  State<ComprehensiveAnalytics> createState() => _ComprehensiveAnalyticsState();
}

class _ComprehensiveAnalyticsState extends State<ComprehensiveAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          'Comprehensive Analytics',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Appcolors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 20),
        
        // Key Metrics Row
        ChartFadeAnimation(
          delay: const Duration(milliseconds: 50),
          child: _buildKeyMetricsRow(),
        ),
        
        const SizedBox(height: 24),
        
        // First row of charts
        Row(
          children: [
            Expanded(
              child: ChartFadeAnimation(
                delay: const Duration(milliseconds: 100),
                child: _buildOrderStatusChart(),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ChartFadeAnimation(
                delay: const Duration(milliseconds: 200),
                child: _buildDriverStatusChart(),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Second row of charts
        Row(
          children: [
            Expanded(
              child: ChartFadeAnimation(
                delay: const Duration(milliseconds: 300),
                child: _buildMerchantCategoryChart(),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ChartFadeAnimation(
                delay: const Duration(milliseconds: 400),
                child: _buildRevenueTrendsChart(),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Third row of charts
        Row(
          children: [
            Expanded(
              child: ChartFadeAnimation(
                delay: const Duration(milliseconds: 500),
                child: _buildCustomerActivityChart(),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ChartFadeAnimation(
                delay: const Duration(milliseconds: 600),
                child: _buildDeliveryPerformanceChart(),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Fourth row - Detailed metrics
        ChartFadeAnimation(
          delay: const Duration(milliseconds: 700),
          child: _buildDetailedMetrics(),
        ),
      ],
    );
  }

  Widget _buildKeyMetricsRow() {
    // Check if any data is still loading
    final isLoading = widget.drivers.isEmpty || 
                     widget.merchants.isEmpty || 
                     widget.customers.isEmpty || 
                     widget.orders.isEmpty;

    if (isLoading) {
      return Row(
        children: [
          Expanded(
            child: MetricLoadingAnimation(
              icon: Icons.delivery_dining,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: MetricLoadingAnimation(
              icon: Icons.store,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: MetricLoadingAnimation(
              icon: Icons.people,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: MetricLoadingAnimation(
              icon: Icons.shopping_cart,
              color: Colors.purple,
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Total Drivers',
            '${widget.drivers.length}',
            '${widget.drivers.where((d) => d.status.toLowerCase() == 'active').length} active',
            Icons.delivery_dining,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Total Merchants',
            '${widget.merchants.length}',
            '${widget.merchants.where((m) => m.status == 'active').length} active',
            Icons.store,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Total Customers',
            '${widget.customers.length}',
            '${widget.customers.where((c) => c.status == 'active').length} active',
            Icons.people,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Total Orders',
            '${widget.orders.length}',
            '${widget.orders.where((o) => o.status == 'active').length} active',
            Icons.shopping_cart,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStatusChart() {
    // Show loading animation if data is empty
    if (widget.orders.isEmpty) {
      return ChartLoadingAnimation(
        height: 300,
        title: 'Order Status Distribution',
        icon: Icons.shopping_cart,
      );
    }
    
    final orderStatusData = _generateOrderStatusData();
    
    return Container(
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
                  Icons.shopping_cart,
                  color: Appcolors.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Order Status Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Appcolors.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: orderStatusData.map((data) {
                                     final percentage = widget.orders.isNotEmpty ? (data.value / widget.orders.length * 100).round() : 0;
                   return PieChartSectionData(
                     color: data.color,
                     value: data.value,
                     title: '$percentage%',
                     radius: 60,
                     titleStyle: const TextStyle(
                       fontSize: 12,
                       fontWeight: FontWeight.bold,
                       color: Colors.white,
                     ),
                   );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...orderStatusData.map((data) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: data.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                Text(
                  '${data.value}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Appcolors.textPrimaryColor,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDriverStatusChart() {
    // Show loading animation if data is empty
    if (widget.drivers.isEmpty) {
      return ChartLoadingAnimation(
        height: 300,
        title: 'Driver Status Overview',
        icon: Icons.delivery_dining,
      );
    }
    
    final driverStatusData = _generateDriverStatusData();
    
    return Container(
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
                  Icons.delivery_dining,
                  color: Appcolors.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Driver Status Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Appcolors.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Active', 'Available', 'Suspended'];
                        if (value.toInt() < titles.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              titles[value.toInt()],
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: driverStatusData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: [Colors.blue, Colors.green, Colors.red][entry.key],
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantCategoryChart() {
    // Show loading animation if data is empty
    if (widget.merchants.isEmpty) {
      return ChartLoadingAnimation(
        height: 300,
        title: 'Merchant Categories',
        icon: Icons.store,
      );
    }
    
    final merchantCategoryData = _generateMerchantCategoryData();
    
    return Container(
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
                  Icons.store,
                  color: Appcolors.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Merchant Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Appcolors.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: SfCircularChart(
              series: <CircularSeries>[
                DoughnutSeries<CategoryData, String>(
                  dataSource: merchantCategoryData,
                  pointColorMapper: (CategoryData data, _) => data.color,
                  xValueMapper: (CategoryData data, _) => data.name,
                  yValueMapper: (CategoryData data, _) => data.value,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTrendsChart() {
    // Show loading animation if data is empty
    if (widget.orders.isEmpty) {
      return ChartLoadingAnimation(
        height: 300,
        title: 'Revenue Trends',
        icon: Icons.trending_up,
      );
    }
    
    final revenueData = _generateRevenueData();
    
    return Container(
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
                  Icons.trending_up,
                  color: Appcolors.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Revenue Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Appcolors.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 50,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        if (value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        );
                      },
                      reservedSize: 40,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 200,
                lineBarsData: [
                  LineChartBarData(
                    spots: revenueData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value);
                    }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green,
                        Colors.green.withOpacity(0.5),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.green,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.3),
                          Colors.green.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerActivityChart() {
    // Show loading animation if data is empty
    if (widget.customers.isEmpty) {
      return ChartLoadingAnimation(
        height: 300,
        title: 'Customer Activity',
        icon: Icons.people,
      );
    }
    
    final customerActivityData = _generateCustomerActivityData();
    
    return Container(
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
                  Icons.people,
                  color: Appcolors.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Customer Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Appcolors.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 25,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['0-5', '6-10', '11-15', '16-20', '20+'];
                        if (value.toInt() < titles.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              titles[value.toInt()],
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: customerActivityData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: Colors.orange,
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryPerformanceChart() {
    // Show loading animation if data is empty
    if (widget.drivers.isEmpty) {
      return ChartLoadingAnimation(
        height: 300,
        title: 'Delivery Performance',
        icon: Icons.speed,
      );
    }
    
    final deliveryData = _generateDeliveryPerformanceData();
    
    return Container(
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
                  Icons.speed,
                  color: Appcolors.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Delivery Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Appcolors.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: SfCircularChart(
              series: <CircularSeries>[
                DoughnutSeries<PerformanceData, String>(
                  dataSource: deliveryData,
                  pointColorMapper: (PerformanceData data, _) => data.color,
                  xValueMapper: (PerformanceData data, _) => data.metric,
                  yValueMapper: (PerformanceData data, _) => data.value,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMetrics() {
    return Container(
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
                  Icons.analytics,
                  color: Appcolors.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Detailed Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Appcolors.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDetailedMetricCard(
                  'Average Order Value',
                  '\$${widget.orders.isNotEmpty ? (widget.orders.fold(0.0, (sum, order) => sum + order.totalAmount) / widget.orders.length).toStringAsFixed(2) : '0.00'}',
                  'per order',
                  Icons.attach_money,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailedMetricCard(
                  'Total Revenue',
                  '\$${widget.orders.fold(0.0, (sum, order) => sum + order.totalAmount).toStringAsFixed(2)}',
                  'this month',
                  Icons.trending_up,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailedMetricCard(
                  'Average Driver Rating',
                  '${widget.drivers.isNotEmpty ? (widget.drivers.map((d) => d.rating).reduce((a, b) => a + b) / widget.drivers.length).toStringAsFixed(1) : '0.0'}',
                  'out of 5',
                  Icons.star,
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDetailedMetricCard(
                  'Total Deliveries',
                  '${widget.drivers.fold(0, (sum, driver) => sum + driver.completedDeliveries)}',
                  'completed',
                  Icons.check_circle,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMetricCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // Data generation methods
  List<StatusData> _generateOrderStatusData() {
    final total = widget.orders.length;
    if (total == 0) return [];

    final completed = widget.orders.where((o) => o.status == 'completed').length;
    final active = widget.orders.where((o) => o.status == 'active').length;
    final pending = widget.orders.where((o) => o.status == 'pending').length;
    final cancelled = widget.orders.where((o) => o.status == 'cancelled').length;

    return [
      StatusData('Completed', completed.toDouble(), Colors.green),
      StatusData('Active', active.toDouble(), Colors.blue),
      StatusData('Pending', pending.toDouble(), Colors.orange),
      StatusData('Cancelled', cancelled.toDouble(), Colors.red),
    ];
  }

  List<double> _generateDriverStatusData() {
    final total = widget.drivers.length;
    if (total == 0) return [0, 0, 0];

    final active = widget.drivers.where((d) => d.status.toLowerCase() == 'active').length;
    final available = widget.drivers.where((d) => d.status.toLowerCase() == 'available').length;
    final suspended = widget.drivers.where((d) => d.status.toLowerCase() == 'suspended').length;

    return [
      (active / total * 100),
      (available / total * 100),
      (suspended / total * 100),
    ];
  }

  List<CategoryData> _generateMerchantCategoryData() {
    final Map<String, int> categoryCounts = {};
    for (final merchant in widget.merchants) {
      categoryCounts[merchant.category] = (categoryCounts[merchant.category] ?? 0) + 1;
    }

    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
    return categoryCounts.entries.map((entry) {
      final colorIndex = categoryCounts.keys.toList().indexOf(entry.key) % colors.length;
      return CategoryData(entry.key, entry.value.toDouble(), entry.value.toDouble(), colors[colorIndex]);
    }).toList();
  }

  List<double> _generateRevenueData() {
    // Generate sample revenue data for the last 6 months
    return [85, 92, 78, 105, 120, 95];
  }

  List<double> _generateCustomerActivityData() {
    // Generate sample customer activity data based on order counts
    final orderCounts = widget.customers.map((c) => c.totalOrders).toList();
    final ranges = [0, 0, 0, 0, 0]; // 0-5, 6-10, 11-15, 16-20, 20+
    
    for (final count in orderCounts) {
      if (count <= 5) ranges[0]++;
      else if (count <= 10) ranges[1]++;
      else if (count <= 15) ranges[2]++;
      else if (count <= 20) ranges[3]++;
      else ranges[4]++;
    }
    
    return ranges.map((count) => count.toDouble()).toList();
  }

  List<PerformanceData> _generateDeliveryPerformanceData() {
    final totalDeliveries = widget.drivers.fold(0, (sum, driver) => sum + driver.completedDeliveries);
    final totalDrivers = widget.drivers.length;
    final averageDeliveries = totalDrivers > 0 ? totalDeliveries / totalDrivers : 0;
    final onTimeDeliveries = (totalDeliveries * 0.85).round(); // Assume 85% on-time delivery
    final lateDeliveries = totalDeliveries - onTimeDeliveries;

    return [
      PerformanceData('On Time', onTimeDeliveries.toDouble(), Colors.green),
      PerformanceData('Late', lateDeliveries.toDouble(), Colors.red),
             PerformanceData('Avg/Driver', averageDeliveries.toDouble(), Colors.blue),
    ];
  }
}

// Data classes for charts
class StatusData {
  final String name;
  final double value;
  final Color color;

  StatusData(this.name, this.value, this.color);
}

class CategoryData {
  final String name;
  final double value;
  final double percentage;
  final Color color;

  CategoryData(this.name, this.value, this.percentage, this.color);
}

class PerformanceData {
  final String metric;
  final double value;
  final Color color;

  PerformanceData(this.metric, this.value, this.color);
}
