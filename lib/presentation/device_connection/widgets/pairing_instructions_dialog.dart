import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PairingInstructionsDialog extends StatefulWidget {
  final Map<String, dynamic> device;
  final VoidCallback onStartPairing;
  final VoidCallback onCancel;

  const PairingInstructionsDialog({
    Key? key,
    required this.device,
    required this.onStartPairing,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<PairingInstructionsDialog> createState() =>
      _PairingInstructionsDialogState();
}

class _PairingInstructionsDialogState extends State<PairingInstructionsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentStep = 0;
  bool _isPairing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _pairingSteps {
    final String deviceType =
        (widget.device['category'] as String? ?? '').toLowerCase();

    switch (deviceType) {
      case 'blood pressure monitors':
        return [
          {
            'title': 'Power On Device',
            'description':
                'Press and hold the power button for 3 seconds until the display lights up.',
            'icon': 'power_settings_new',
          },
          {
            'title': 'Enable Pairing Mode',
            'description':
                'Press the Bluetooth button until the Bluetooth symbol starts blinking.',
            'icon': 'bluetooth',
          },
          {
            'title': 'Start Connection',
            'description': 'Tap "Start Pairing" below to connect your device.',
            'icon': 'link',
          },
        ];
      case 'glucose meters':
        return [
          {
            'title': 'Insert Test Strip',
            'description':
                'Insert a test strip to automatically turn on the device.',
            'icon': 'insert_drive_file',
          },
          {
            'title': 'Activate Bluetooth',
            'description':
                'Navigate to Settings > Bluetooth and enable pairing mode.',
            'icon': 'bluetooth',
          },
          {
            'title': 'Connect Device',
            'description': 'Tap "Start Pairing" to establish the connection.',
            'icon': 'link',
          },
        ];
      case 'smart scales':
        return [
          {
            'title': 'Step on Scale',
            'description':
                'Step on the scale briefly to wake it up, then step off.',
            'icon': 'monitor_weight',
          },
          {
            'title': 'Enable Pairing',
            'description':
                'The scale will automatically enter pairing mode for 2 minutes.',
            'icon': 'bluetooth',
          },
          {
            'title': 'Start Pairing',
            'description':
                'Tap "Start Pairing" while the scale is in pairing mode.',
            'icon': 'link',
          },
        ];
      case 'fitness trackers':
        return [
          {
            'title': 'Charge Device',
            'description':
                'Ensure your fitness tracker is charged and powered on.',
            'icon': 'battery_charging_full',
          },
          {
            'title': 'Reset if Needed',
            'description':
                'If previously paired, reset the device to factory settings.',
            'icon': 'refresh',
          },
          {
            'title': 'Start Pairing',
            'description':
                'Tap "Start Pairing" to begin the connection process.',
            'icon': 'link',
          },
        ];
      default:
        return [
          {
            'title': 'Power On',
            'description':
                'Turn on your medical device and ensure it\'s ready.',
            'icon': 'power_settings_new',
          },
          {
            'title': 'Enable Bluetooth',
            'description': 'Enable Bluetooth pairing mode on your device.',
            'icon': 'bluetooth',
          },
          {
            'title': 'Connect',
            'description': 'Tap "Start Pairing" to connect.',
            'icon': 'link',
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 85.w,
            maxHeight: 80.h,
          ),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: widget.device['brandLogo'] as String? ?? '',
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pairing Instructions',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.device['name'] as String? ??
                                'Unknown Device',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onCancel,
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                    ),
                  ],
                ),
              ),

              // Steps
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    children: _pairingSteps.asMap().entries.map((entry) {
                      final int index = entry.key;
                      final Map<String, String> step = entry.value;
                      final bool isActive = index == _currentStep;
                      final bool isCompleted = index < _currentStep;

                      return Container(
                        margin: EdgeInsets.only(bottom: 3.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? AppTheme.lightTheme.colorScheme.secondary
                                    : isActive
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.outline
                                            .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: isCompleted
                                    ? CustomIconWidget(
                                        iconName: 'check',
                                        color: Colors.white,
                                        size: 5.w,
                                      )
                                    : CustomIconWidget(
                                        iconName: step['icon']!,
                                        color: isActive
                                            ? Colors.white
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurfaceVariant,
                                        size: 5.w,
                                      ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    step['title']!,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isActive
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    step['description']!,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Actions
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isPairing ? null : widget.onCancel,
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isPairing ? null : _startPairing,
                        child: _isPairing
                            ? SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text('Start Pairing'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startPairing() {
    setState(() {
      _isPairing = true;
    });

    // Simulate pairing process
    _simulatePairingSteps();
    widget.onStartPairing();
  }

  void _simulatePairingSteps() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _currentStep < _pairingSteps.length - 1) {
        setState(() {
          _currentStep++;
        });
        _simulatePairingSteps();
      }
    });
  }
}
