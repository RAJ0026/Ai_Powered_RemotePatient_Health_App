import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentVitalsWidget extends StatelessWidget {
  const RecentVitalsWidget({super.key});

  final List<Map<String, dynamic>> _vitalsData = const [
    {
      "patientName": "Sarah Johnson",
      "vitals": [
        {
          "type": "Heart Rate",
          "value": 78,
          "unit": "bpm",
          "timestamp": "10:30 AM"
        },
        {
          "type": "Blood Pressure",
          "value": "140/90",
          "unit": "mmHg",
          "timestamp": "10:30 AM"
        },
        {
          "type": "Temperature",
          "value": 98.6,
          "unit": "°F",
          "timestamp": "10:30 AM"
        },
      ]
    },
    {
      "patientName": "Michael Chen",
      "vitals": [
        {
          "type": "Heart Rate",
          "value": 85,
          "unit": "bpm",
          "timestamp": "09:45 AM"
        },
        {
          "type": "Blood Sugar",
          "value": 180,
          "unit": "mg/dL",
          "timestamp": "09:45 AM"
        },
        {
          "type": "Temperature",
          "value": 99.1,
          "unit": "°F",
          "timestamp": "09:45 AM"
        },
      ]
    },
    {
      "patientName": "Emma Rodriguez",
      "vitals": [
        {
          "type": "Heart Rate",
          "value": 72,
          "unit": "bpm",
          "timestamp": "11:15 AM"
        },
        {
          "type": "Oxygen Sat",
          "value": 98,
          "unit": "%",
          "timestamp": "11:15 AM"
        },
        {
          "type": "Temperature",
          "value": 98.2,
          "unit": "°F",
          "timestamp": "11:15 AM"
        },
      ]
    },
  ];

  // Sample chart data for heart rate trends
  final List<FlSpot> _heartRateData = const [
    FlSpot(0, 75),
    FlSpot(1, 78),
    FlSpot(2, 82),
    FlSpot(3, 85),
    FlSpot(4, 80),
    FlSpot(5, 78),
    FlSpot(6, 76),
  ];

  Color _getVitalColor(String vitalType) {
    switch (vitalType) {
      case 'Heart Rate':
        return const Color(0xFFFF3B30);
      case 'Blood Pressure':
        return const Color(0xFF007AFF);
      case 'Blood Sugar':
        return const Color(0xFFFF9500);
      case 'Oxygen Sat':
        return const Color(0xFF34C759);
      case 'Temperature':
        return const Color(0xFFFF9500);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  IconData _getVitalIcon(String vitalType) {
    switch (vitalType) {
      case 'Heart Rate':
        return Icons.favorite;
      case 'Blood Pressure':
        return Icons.monitor_heart;
      case 'Blood Sugar':
        return Icons.water_drop;
      case 'Oxygen Sat':
        return Icons.air;
      case 'Temperature':
        return Icons.thermostat;
      default:
        return Icons.health_and_safety;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'timeline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recent Vitals Summary",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Last 24 hours overview",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/patient-list');
                  },
                  child: Text(
                    "View Details",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Heart Rate Trend Chart
          Container(
            height: 20.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Heart Rate Trends",
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 10,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const style = TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              );
                              Widget text;
                              switch (value.toInt()) {
                                case 0:
                                  text = const Text('6AM', style: style);
                                  break;
                                case 1:
                                  text = const Text('9AM', style: style);
                                  break;
                                case 2:
                                  text = const Text('12PM', style: style);
                                  break;
                                case 3:
                                  text = const Text('3PM', style: style);
                                  break;
                                case 4:
                                  text = const Text('6PM', style: style);
                                  break;
                                case 5:
                                  text = const Text('9PM', style: style);
                                  break;
                                case 6:
                                  text = const Text('12AM', style: style);
                                  break;
                                default:
                                  text = const Text('', style: style);
                                  break;
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: text,
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 10,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            },
                            reservedSize: 32,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      minX: 0,
                      maxX: 6,
                      minY: 60,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _heartRateData,
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightTheme.colorScheme.primary,
                              AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: AppTheme.lightTheme.colorScheme.primary,
                                strokeWidth: 2,
                                strokeColor:
                                    AppTheme.lightTheme.colorScheme.surface,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.0),
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
          ),

          SizedBox(height: 2.h),

          // Recent Vitals List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _vitalsData.length,
            separatorBuilder: (context, index) => Divider(
              height: 2.h,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.1),
            ),
            itemBuilder: (context, index) {
              final patientData = _vitalsData[index];
              return _buildPatientVitalsRow(context, patientData);
            },
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildPatientVitalsRow(
      BuildContext context, Map<String, dynamic> patientData) {
    final patientName = patientData['patientName'] as String;
    final vitals = patientData['vitals'] as List<Map<String, dynamic>>;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/patient-health-tracking');
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Name
            Text(
              patientName,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 1.h),

            // Vitals Row
            Row(
              children: vitals.map((vital) {
                final vitalMap = vital;
                final vitalType = vitalMap['type'] as String;
                final vitalValue = vitalMap['value'];
                final vitalUnit = vitalMap['unit'] as String;

                return Expanded(
                  child: _buildVitalChip(vitalType, vitalValue, vitalUnit),
                );
              }).toList(),
            ),

            SizedBox(height: 0.5.h),

            // Timestamp
            Text(
              "Last updated: ${vitals.first['timestamp']}",
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalChip(String type, dynamic value, String unit) {
    final color = _getVitalColor(type);
    final icon = _getVitalIcon(type);

    return Container(
      margin: EdgeInsets.only(right: 2.w),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon.codePoint.toString(),
            color: color,
            size: 16,
          ),
          SizedBox(height: 0.5.h),
          Text(
            "$value",
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            unit,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
