import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BluetoothStatusIndicator extends StatefulWidget {
  final bool isBluetoothEnabled;
  final bool isScanning;
  final VoidCallback onToggleBluetooth;

  const BluetoothStatusIndicator({
    Key? key,
    required this.isBluetoothEnabled,
    required this.isScanning,
    required this.onToggleBluetooth,
  }) : super(key: key);

  @override
  State<BluetoothStatusIndicator> createState() =>
      _BluetoothStatusIndicatorState();
}

class _BluetoothStatusIndicatorState extends State<BluetoothStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isScanning) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(BluetoothStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !oldWidget.isScanning) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isScanning && oldWidget.isScanning) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: widget.isBluetoothEnabled
            ? AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isBluetoothEnabled
              ? AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          widget.isScanning
              ? AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: CustomIconWidget(
                        iconName: 'bluetooth_searching',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 6.w,
                      ),
                    );
                  },
                )
              : CustomIconWidget(
                  iconName: widget.isBluetoothEnabled
                      ? 'bluetooth'
                      : 'bluetooth_disabled',
                  color: widget.isBluetoothEnabled
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : AppTheme.lightTheme.colorScheme.error,
                  size: 6.w,
                ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isScanning
                      ? 'Scanning for devices...'
                      : widget.isBluetoothEnabled
                          ? 'Bluetooth Enabled'
                          : 'Bluetooth Disabled',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: widget.isBluetoothEnabled
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.isScanning
                      ? 'Looking for nearby medical devices'
                      : widget.isBluetoothEnabled
                          ? 'Ready to connect to medical devices'
                          : 'Enable Bluetooth to connect devices',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!widget.isBluetoothEnabled)
            TextButton(
              onPressed: widget.onToggleBluetooth,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Enable',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
