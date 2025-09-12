import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ScheduledCheckinsWidget extends StatelessWidget {
  const ScheduledCheckinsWidget({super.key});

  final List<Map<String, dynamic>> _checkinsData = const [
    {
      "id": 1,
      "patientName": "Sarah Johnson",
      "patientAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "checkInType": "Blood Pressure Check",
      "scheduledTime": "2:00 PM",
      "status": "pending",
      "priority": "high",
      "notes": "Post-medication monitoring required"
    },
    {
      "id": 2,
      "patientName": "Michael Chen",
      "patientAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "checkInType": "Blood Sugar Reading",
      "scheduledTime": "3:30 PM",
      "status": "completed",
      "priority": "medium",
      "notes": "Regular diabetes monitoring"
    },
    {
      "id": 3,
      "patientName": "Emma Rodriguez",
      "patientAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "checkInType": "Oxygen Saturation",
      "scheduledTime": "4:15 PM",
      "status": "pending",
      "priority": "low",
      "notes": "Asthma follow-up check"
    },
    {
      "id": 4,
      "patientName": "James Wilson",
      "patientAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "checkInType": "Heart Rate Monitor",
      "scheduledTime": "5:00 PM",
      "status": "overdue",
      "priority": "high",
      "notes": "Cardiac rehabilitation check"
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF34C759);
      case 'pending':
        return const Color(0xFF007AFF);
      case 'overdue':
        return const Color(0xFFFF3B30);
      default:
        return const Color(0xFF007AFF);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
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

  IconData _getCheckInIcon(String checkInType) {
    switch (checkInType) {
      case 'Blood Pressure Check':
        return Icons.monitor_heart;
      case 'Blood Sugar Reading':
        return Icons.water_drop;
      case 'Oxygen Saturation':
        return Icons.air;
      case 'Heart Rate Monitor':
        return Icons.favorite;
      default:
        return Icons.health_and_safety;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'overdue':
        return 'Overdue';
      default:
        return 'Unknown';
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
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Scheduled Check-ins",
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${_checkinsData.where((checkin) => (checkin['status'] as String) == 'pending').length} pending today",
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

          // Check-ins List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _checkinsData.length,
            separatorBuilder: (context, index) => Divider(
              height: 2.h,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.1),
            ),
            itemBuilder: (context, index) {
              final checkin = _checkinsData[index];
              return _buildCheckinItem(context, checkin);
            },
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildCheckinItem(BuildContext context, Map<String, dynamic> checkin) {
    final status = checkin['status'] as String;
    final priority = checkin['priority'] as String;
    final checkInType = checkin['checkInType'] as String;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/patient-health-tracking');
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            // Patient Avatar with Status Indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CustomImageWidget(
                    imageUrl: checkin['patientAvatar'] as String,
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

            // Check-in Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient Name and Time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          checkin['patientName'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        checkin['scheduledTime'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 0.5.h),

                  // Check-in Type with Icon
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName:
                            _getCheckInIcon(checkInType).codePoint.toString(),
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          checkInType,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 0.5.h),

                  // Notes
                  if (checkin['notes'] != null &&
                      (checkin['notes'] as String).isNotEmpty)
                    Text(
                      checkin['notes'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            SizedBox(width: 3.w),

            // Status and Priority Badges
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status Badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getStatusColor(status).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getStatusText(status),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: 1.h),

                // Priority Indicator
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      priority.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getPriorityColor(priority),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
