import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:namnam/core/Utility/appcolors.dart';
import 'package:namnam/model/category.dart';
import 'package:namnam/model/zone.dart';
import 'package:namnam/view/Web/widgets/chart_loading_animation.dart';
import 'package:namnam/view/Web/widgets/chart_fade_animation.dart';

class DashboardAnalytics extends StatefulWidget {
  final List<Category> categories;
  final List<Zone> zones;

  const DashboardAnalytics({
    super.key,
    required this.categories,
    required this.zones,
  });

  @override
  State<DashboardAnalytics> createState() => _DashboardAnalyticsState();
}

class _DashboardAnalyticsState extends State<DashboardAnalytics> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(
          'Analytics & Insights',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Appcolors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 20),
        
        // First row of charts
        Row(
          children: [
            Expanded(
              child: ChartFadeAnimation(
                delay: const Duration(milliseconds: 100),
                child: _buildCategoryDistributionChart(),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ChartFadeAnimation(
                delay: const Duration(milliseconds: 200),
                child: _buildZoneActivityChart(),
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
                child: _buildMonthlyTrendsChart(),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ChartFadeAnimation(
                delay: const Duration(milliseconds: 400),
                child: _buildStatusOverviewChart(),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Third row - Performance metrics
        ChartFadeAnimation(
          delay: const Duration(milliseconds: 500),
          child: _buildPerformanceMetrics(),
        ),
      ],
    );
  }

  Widget _buildCategoryDistributionChart() {
    // Show loading animation if data is empty
    if (widget.categories.isEmpty) {
      return ChartLoadingAnimation(
        height: 300,
        title: 'Category Distribution',
        icon: Icons.pie_chart,
      );
    }
    
    // Use real category data
    final categoryData = _generateCategoryDataFromReal(widget.categories);
    
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
                  Icons.pie_chart,
                  color: Appcolors.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Category Distribution',
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
                sections: categoryData.map((data) {
                  return PieChartSectionData(
                    color: data.color,
                    value: data.value,
                    title: '${data.percentage}%',
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
          ...categoryData.map((data) => Padding(
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

  Widget _buildZoneActivityChart() {
    // Show loading animation if data is empty
    if (widget.zones.isEmpty) {
      return ChartLoadingAnimation(
        height: 300,
        title: 'Zone Activity',
        icon: Icons.location_on,
      );
    }
    
    final zoneData = _generateZoneDataFromReal(widget.zones);
    
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
                  Icons.location_on,
                  color: Appcolors.appPrimaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Zone Activity',
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
                         final zoneNames = widget.zones.isNotEmpty 
                             ? widget.zones.map((z) => z.zoneName).toList()
                             : ['Zone A', 'Zone B', 'Zone C', 'Zone D'];
                         
                         if (value.toInt() < zoneNames.length) {
                           final name = zoneNames[value.toInt()];
                           return Padding(
                             padding: const EdgeInsets.only(top: 8),
                             child: Text(
                               name.length > 8 ? '${name.substring(0, 8)}...' : name,
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
                barGroups: zoneData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value,
                        color: Appcolors.appPrimaryColor,
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

  Widget _buildMonthlyTrendsChart() {
    // Show loading animation if data is empty
    if (widget.categories.isEmpty && widget.zones.isEmpty) {
      return ChartLoadingAnimation(
        height: 300,
        title: 'Monthly Trends',
        icon: Icons.trending_up,
      );
    }
    
    final monthlyData = _generateMonthlyData();
    
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
                'Monthly Trends',
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
                  horizontalInterval: 20,
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
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
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
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: monthlyData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value);
                    }).toList(),
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        Appcolors.appPrimaryColor,
                        Appcolors.appPrimaryColor.withOpacity(0.5),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Appcolors.appPrimaryColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Appcolors.appPrimaryColor.withOpacity(0.3),
                          Appcolors.appPrimaryColor.withOpacity(0.1),
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

  Widget _buildStatusOverviewChart() {
    // Show loading animation if data is empty
    if (widget.categories.isEmpty) {
      return ChartLoadingAnimation(
        height: 300,
        title: 'Status Overview',
        icon: Icons.analytics,
      );
    }
    
    final statusData = _generateStatusDataFromReal(widget.categories);
    
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
                'Status Overview',
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
                DoughnutSeries<StatusData, String>(
                  dataSource: statusData,
                  pointColorMapper: (StatusData data, _) => data.color,
                  xValueMapper: (StatusData data, _) => data.status,
                  yValueMapper: (StatusData data, _) => data.value,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...statusData.map((data) => Padding(
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
                    data.status,
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

  Widget _buildPerformanceMetrics() {
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
                'Performance Metrics',
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
                child: _buildMetricCard(
                  'Response Time',
                  '2.3s',
                  'avg',
                  Icons.timer,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Uptime',
                  '99.8%',
                  'this month',
                  Icons.cloud_done,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Error Rate',
                  '0.2%',
                  'last 24h',
                  Icons.error_outline,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Active Users',
                  '1,247',
                  'current',
                  Icons.people,
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

  // Data generation methods
  List<CategoryData> _generateCategoryDataFromReal(List<Category> categories) {
    if (categories.isEmpty) return _generateCategoryData();
    
    // Group categories by type or create a simple count
    final Map<String, int> categoryCounts = {};
    for (final category in categories) {
      final type = category.type ?? 'Unknown';
      categoryCounts[type] = (categoryCounts[type] ?? 0) + 1;
    }
    
    final total = categories.length;
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.grey, Colors.red, Colors.teal];
    
    return categoryCounts.entries.map((entry) {
      final percentage = total > 0 ? (entry.value / total * 100).round() : 0;
      final colorIndex = categoryCounts.keys.toList().indexOf(entry.key) % colors.length;
      return CategoryData(entry.key, entry.value.toDouble(), percentage.toDouble(), colors[colorIndex]);
    }).toList();
  }

  List<CategoryData> _generateCategoryData() {
    return [
      CategoryData('Food & Beverages', 35, 35, Colors.blue),
      CategoryData('Electronics', 25, 25, Colors.green),
      CategoryData('Clothing', 20, 20, Colors.orange),
      CategoryData('Home & Garden', 15, 15, Colors.purple),
      CategoryData('Others', 5, 5, Colors.grey),
    ];
  }

  List<double> _generateZoneDataFromReal(List<Zone> zones) {
    if (zones.isEmpty) return _generateZoneData();
    
    // Generate activity data based on zone properties
    return zones.map((zone) {
      // Use zone ID as a seed for activity level, or create a simple metric
      final activityLevel = (zone.zoneId ?? 0) % 100 + 20; // 20-119 range
      return activityLevel.toDouble();
    }).toList();
  }

  List<double> _generateZoneData() {
    return [75, 60, 85, 45];
  }

  List<double> _generateMonthlyData() {
    return [45, 52, 38, 65, 72, 58];
  }

  List<StatusData> _generateStatusDataFromReal(List<Category> categories) {
    if (categories.isEmpty) return _generateStatusData();
    
    // Group categories by status
    final Map<String, int> statusCounts = {};
    for (final category in categories) {
      final status = category.status ?? 'Unknown';
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }
    
    final colors = [Colors.green, Colors.orange, Colors.red, Colors.grey, Colors.blue, Colors.purple];
    
    return statusCounts.entries.map((entry) {
      final colorIndex = statusCounts.keys.toList().indexOf(entry.key) % colors.length;
      return StatusData(entry.key, entry.value.toDouble(), colors[colorIndex]);
    }).toList();
  }

  List<StatusData> _generateStatusData() {
    return [
      StatusData('Active', 65, Colors.green),
      StatusData('Pending', 20, Colors.orange),
      StatusData('Inactive', 10, Colors.red),
      StatusData('Suspended', 5, Colors.grey),
    ];
  }
}

// Data classes for charts
class CategoryData {
  final String name;
  final double value;
  final double percentage;
  final Color color;

  CategoryData(this.name, this.value, this.percentage, this.color);
}

class StatusData {
  final String status;
  final double value;
  final Color color;

  StatusData(this.status, this.value, this.color);
}
