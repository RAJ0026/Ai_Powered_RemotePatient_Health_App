import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/context_menu_sheet.dart';
import './widgets/device_status_bar.dart';
import './widgets/health_metric_card.dart';
import './widgets/patient_header.dart';
import './widgets/quick_actions_sheet.dart';

class PatientHealthTracking extends StatefulWidget {
  @override
  _PatientHealthTrackingState createState() => _PatientHealthTrackingState();
}

class _PatientHealthTrackingState extends State<PatientHealthTracking>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock patient data
  final Map<String, dynamic> patientData = {
    "name": "Sarah Johnson",
    "healthScore": 85,
    "nextAppointment": "Dec 15, 2:30 PM",
    "profileImage":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
  };

  // Mock health metrics data
  final List<Map<String, dynamic>> healthMetrics = [
    {
      "title": "Heart Rate",
      "currentValue": "72",
      "unit": "bpm",
      "trendData": [68.0, 70.0, 72.0, 75.0, 73.0, 71.0, 72.0],
      "color": Color(0xFFE91E63),
      "aiInsight": "Resting heart rate is optimal",
    },
    {
      "title": "Blood Pressure",
      "currentValue": "120/80",
      "unit": "mmHg",
      "trendData": [118.0, 120.0, 122.0, 119.0, 121.0, 120.0, 120.0],
      "color": Color(0xFF2196F3),
      "aiInsight": "Blood pressure within normal range",
    },
    {
      "title": "Weight",
      "currentValue": "65.2",
      "unit": "kg",
      "trendData": [66.0, 65.8, 65.5, 65.3, 65.1, 65.0, 65.2],
      "color": Color(0xFF4CAF50),
      "aiInsight": "Weight trending towards goal",
    },
    {
      "title": "Activity Level",
      "currentValue": "8,542",
      "unit": "steps",
      "trendData": [7500.0, 8200.0, 9100.0, 8800.0, 8542.0, 9200.0, 8542.0],
      "color": Color(0xFFFF9800),
      "aiInsight": "Daily activity goal achieved",
    },
    {
      "title": "Medication Adherence",
      "currentValue": "95",
      "unit": "%",
      "trendData": [92.0, 94.0, 96.0, 95.0, 97.0, 94.0, 95.0],
      "color": Color(0xFF9C27B0),
      "aiInsight": "Excellent medication compliance",
    },
  ];

  // Mock connected devices data
  final List<Map<String, dynamic>> connectedDevices = [
    {
      "name": "BP Monitor",
      "icon": "monitor_heart",
      "battery": 85,
      "lastSync": "2 min ago",
    },
    {
      "name": "Glucose Meter",
      "icon": "water_drop",
      "battery": 42,
      "lastSync": "1 hour ago",
    },
    {
      "name": "Fitness Watch",
      "icon": "watch",
      "battery": 78,
      "lastSync": "Just now",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate data refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Health data synced successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successLight,
      textColor: Colors.white,
    );
  }

  void _showQuickActions(String metricTitle) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickActionsSheet(
        metricTitle: metricTitle,
        onAddReading: () {
          Navigator.pop(context);
          _addManualReading(metricTitle);
        },
        onSetGoal: () {
          Navigator.pop(context);
          _setGoal(metricTitle);
        },
        onShareWithDoctor: () {
          Navigator.pop(context);
          _shareWithDoctor(metricTitle);
        },
      ),
    );
  }

  void _showContextMenu(String metricTitle) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContextMenuSheet(
        metricTitle: metricTitle,
        onEditTargetRange: () {
          Navigator.pop(context);
          _editTargetRange(metricTitle);
        },
        onNotificationSettings: () {
          Navigator.pop(context);
          _notificationSettings(metricTitle);
        },
        onExportData: () {
          Navigator.pop(context);
          _exportData(metricTitle);
        },
      ),
    );
  }

  void _addManualReading(String metricTitle) {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Add $metricTitle reading",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _setGoal(String metricTitle) {
    Fluttertoast.showToast(
      msg: "Set goal for $metricTitle",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _shareWithDoctor(String metricTitle) {
    Fluttertoast.showToast(
      msg: "Sharing $metricTitle data with doctor",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _editTargetRange(String metricTitle) {
    Fluttertoast.showToast(
      msg: "Edit target range for $metricTitle",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _notificationSettings(String metricTitle) {
    Fluttertoast.showToast(
      msg: "Configure notifications for $metricTitle",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _exportData(String metricTitle) {
    Fluttertoast.showToast(
      msg: "Exporting $metricTitle data",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _viewDetailedHistory(String metricTitle) {
    HapticFeedback.selectionClick();
    Fluttertoast.showToast(
      msg: "Opening detailed view for $metricTitle",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _addVitalEntry() {
    HapticFeedback.mediumImpact();
    Fluttertoast.showToast(
      msg: "Quick vital entry",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                labelStyle: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: AppTheme.lightTheme.textTheme.titleSmall,
                tabs: [
                  Tab(text: 'Health'),
                  Tab(text: 'Devices'),
                  Tab(text: 'Reports'),
                  Tab(text: 'Settings'),
                ],
              ),
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Health Tab
                  RefreshIndicator(
                    onRefresh: _refreshData,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Patient Header
                          PatientHeader(
                            patientName: patientData['name'] as String,
                            healthScore: patientData['healthScore'] as int,
                            nextAppointment:
                                patientData['nextAppointment'] as String,
                            profileImage: patientData['profileImage'] as String,
                          ),

                          // Connected Devices Status
                          DeviceStatusBar(
                            connectedDevices: connectedDevices,
                          ),

                          // Health Metrics Cards
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: healthMetrics.length,
                            itemBuilder: (context, index) {
                              final metric = healthMetrics[index];
                              return Slidable(
                                key: ValueKey(metric['title']),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) => _showQuickActions(
                                          metric['title'] as String),
                                      backgroundColor: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      icon: Icons.add_circle,
                                      label: 'Add',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) =>
                                          _setGoal(metric['title'] as String),
                                      backgroundColor: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      foregroundColor: Colors.white,
                                      icon: Icons.flag,
                                      label: 'Goal',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) => _shareWithDoctor(
                                          metric['title'] as String),
                                      backgroundColor: AppTheme
                                          .lightTheme.colorScheme.tertiary,
                                      foregroundColor: Colors.white,
                                      icon: Icons.share,
                                      label: 'Share',
                                    ),
                                  ],
                                ),
                                child: HealthMetricCard(
                                  title: metric['title'] as String,
                                  currentValue:
                                      metric['currentValue'] as String,
                                  unit: metric['unit'] as String,
                                  trendData: (metric['trendData'] as List)
                                      .cast<double>(),
                                  cardColor: metric['color'] as Color,
                                  aiInsight: metric['aiInsight'] as String,
                                  onTap: () => _viewDetailedHistory(
                                      metric['title'] as String),
                                  onSwipeLeft: () => _showQuickActions(
                                      metric['title'] as String),
                                  onLongPress: () => _showContextMenu(
                                      metric['title'] as String),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),

                  // Devices Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'bluetooth',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Device Management',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Connect and manage your medical devices',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3.h),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(
                              context, '/device-connection'),
                          child: Text('Connect Device'),
                        ),
                      ],
                    ),
                  ),

                  // Reports Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'assessment',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Health Reports',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'View detailed health analytics and reports',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Settings Tab
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'settings',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 64,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Health Settings',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Configure your health tracking preferences',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: _addVitalEntry,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 24,
              ),
              label: Text(
                'Quick Entry',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}
