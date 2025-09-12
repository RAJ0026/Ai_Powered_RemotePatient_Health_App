import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './device_list_item.dart';

class DeviceCategorySection extends StatefulWidget {
  final String categoryTitle;
  final List<Map<String, dynamic>> devices;
  final Function(Map<String, dynamic>) onDeviceTap;
  final Function(Map<String, dynamic>) onSyncDevice;
  final Function(Map<String, dynamic>) onRemoveDevice;
  final Function(Map<String, dynamic>) onDeviceSettings;

  const DeviceCategorySection({
    Key? key,
    required this.categoryTitle,
    required this.devices,
    required this.onDeviceTap,
    required this.onSyncDevice,
    required this.onRemoveDevice,
    required this.onDeviceSettings,
  }) : super(key: key);

  @override
  State<DeviceCategorySection> createState() => _DeviceCategorySectionState();
}

class _DeviceCategorySectionState extends State<DeviceCategorySection>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: _getCategoryIcon(widget.categoryTitle),
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.categoryTitle,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${widget.devices.length} devices available',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: EdgeInsets.only(
                left: 4.w,
                right: 4.w,
                bottom: 2.h,
              ),
              child: Column(
                children: widget.devices.map((device) {
                  return DeviceListItem(
                    device: device,
                    onTap: () => widget.onDeviceTap(device),
                    onSync: () => widget.onSyncDevice(device),
                    onRemove: () => widget.onRemoveDevice(device),
                    onSettings: () => widget.onDeviceSettings(device),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'blood pressure monitors':
        return 'favorite';
      case 'glucose meters':
        return 'water_drop';
      case 'smart scales':
        return 'monitor_weight';
      case 'fitness trackers':
        return 'fitness_center';
      case 'heart rate monitors':
        return 'monitor_heart';
      default:
        return 'device_hub';
    }
  }
}
