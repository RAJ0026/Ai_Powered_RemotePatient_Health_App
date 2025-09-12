import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivePatientsWidget extends StatelessWidget {
  const ActivePatientsWidget({super.key});

  final List<Map<String, dynamic>> _patientsData = const [
    {
      "id": "P001",
      "name": "Sarah Johnson",
      "age": 45,
      "condition": "Hypertension",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastVitals": {
        "heartRate": 78,
        "bloodPressure": "140/90",
        "temperature": 98.6,
        "timestamp": "2 hours ago"
      },
      "riskLevel": "high",
      "status": "critical"
    },
    {
      "id": "P002",
      "name": "Michael Chen",
      "age": 62,
      "condition": "Diabetes Type 2",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastVitals": {
        "heartRate": 85,
        "bloodSugar": 180,
        "temperature": 99.1,
        "timestamp": "1 hour ago"
      },
      "riskLevel": "medium",
      "status": "warning"
    },
    {
      "id": "P003",
      "name": "Emma Rodriguez",
      "age": 38,
      "condition": "Asthma",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastVitals": {
        "heartRate": 72,
        "oxygenSat": 98,
        "temperature": 98.2,
        "timestamp": "30 minutes ago"
      },
      "riskLevel": "low",
      "status": "stable"
    },
    {
      "id": "P004",
      "name": "James Wilson",
      "age": 55,
      "condition": "Heart Disease",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "lastVitals": {
        "heartRate": 92,
        "bloodPressure": "130/85",
        "temperature": 98.4,
        "timestamp": "45 minutes ago"
      },
      "riskLevel": "medium",
      "status": "stable"
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'critical':
        return const Color(0xFFFF3B30);
      case 'warning':
        return const Color(0xFFFF9500);
      case 'stable':
        return const Color(0xFF34C759);
      default:
        return const Color(0xFF34C759);
    }
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'high':
        return const Color(0xFFFF3B30);
      case 'medium':
        return const Color(0xFFFF9500);
      case 'low':
        return const Color(0xFF34C759);
      default:
        return const Color(0xFF34C759);
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
                  iconName: 'people',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Active Patients",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${_patientsData.length} patients monitored",
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
                    "View All",
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Horizontal Patient List
          SizedBox(
            height: 28.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _patientsData.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final patient = _patientsData[index];
                return _buildPatientCard(context, patient);
              },
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, Map<String, dynamic> patient) {
    final status = patient['status'] as String;
    final riskLevel = patient['riskLevel'] as String;
    final lastVitals = patient['lastVitals'] as Map<String, dynamic>;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/patient-health-tracking');
      },
      onLongPress: () {
        _showPatientContextMenu(context, patient);
      },
      child: Container(
        width: 70.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getStatusColor(status).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header
            Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CustomImageWidget(
                        imageUrl: patient['avatar'] as String,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient['name'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${patient['condition']} • ${patient['age']}y",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getRiskColor(riskLevel).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getRiskColor(riskLevel).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "AI: ${riskLevel.toUpperCase()}",
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getRiskColor(riskLevel),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Vitals Section
            Text(
              "Last Vitals",
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),

            SizedBox(height: 1.h),

            // Vitals Data
            Expanded(
              child: Column(
                children: [
                  if (lastVitals.containsKey('heartRate'))
                    _buildVitalRow(
                      'Heart Rate',
                      '${lastVitals['heartRate']} bpm',
                      Icons.favorite,
                      const Color(0xFFFF3B30),
                    ),
                  if (lastVitals.containsKey('bloodPressure'))
                    _buildVitalRow(
                      'Blood Pressure',
                      lastVitals['bloodPressure'] as String,
                      Icons.monitor_heart,
                      const Color(0xFF007AFF),
                    ),
                  if (lastVitals.containsKey('bloodSugar'))
                    _buildVitalRow(
                      'Blood Sugar',
                      '${lastVitals['bloodSugar']} mg/dL',
                      Icons.water_drop,
                      const Color(0xFFFF9500),
                    ),
                  if (lastVitals.containsKey('oxygenSat'))
                    _buildVitalRow(
                      'Oxygen Sat',
                      '${lastVitals['oxygenSat']}%',
                      Icons.air,
                      const Color(0xFF34C759),
                    ),
                  if (lastVitals.containsKey('temperature'))
                    _buildVitalRow(
                      'Temperature',
                      '${lastVitals['temperature']}°F',
                      Icons.thermostat,
                      const Color(0xFFFF9500),
                    ),
                ],
              ),
            ),

            // Timestamp
            Text(
              "Updated ${lastVitals['timestamp']}",
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalRow(
      String label, String value, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon.codePoint.toString(),
            color: color,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showPatientContextMenu(
      BuildContext context, Map<String, dynamic> patient) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              patient['name'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              context,
              'Schedule Appointment',
              Icons.calendar_today,
              () => Navigator.pop(context),
            ),
            _buildContextMenuItem(
              context,
              'Add Notes',
              Icons.note_add,
              () => Navigator.pop(context),
            ),
            _buildContextMenuItem(
              context,
              'Emergency Contact',
              Icons.emergency,
              () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon.codePoint.toString(),
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
