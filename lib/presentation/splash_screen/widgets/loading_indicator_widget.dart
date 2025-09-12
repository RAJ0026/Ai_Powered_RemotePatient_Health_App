import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:async'; // Add this import for Timer

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingIndicatorWidget extends StatefulWidget {
  final String loadingText;

  const LoadingIndicatorWidget({
    super.key,
    this.loadingText = 'Initializing HIPAA-compliant data...',
  });

  @override
  State<LoadingIndicatorWidget> createState() => _LoadingIndicatorWidgetState();
}

class _LoadingIndicatorWidgetState extends State<LoadingIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  final List<String> _loadingSteps = [
    'Checking biometric authentication...',
    'Loading encrypted patient preferences...',
    'Fetching medical device connections...',
    'Preparing cached health data...',
    'Finalizing secure initialization...',
  ];

  int _currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _startLoadingSequence();
  }

  void _startLoadingSequence() {
    _animationController.forward();

    // Update loading text every 500ms
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted && _currentStepIndex < _loadingSteps.length - 1) {
        setState(() {
          _currentStepIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60.w,
          height: 0.8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.3),
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _progressAnimation.value,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.secondary,
                ),
                borderRadius: BorderRadius.circular(10),
              );
            },
          ),
        ),
        SizedBox(height: 3.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _currentStepIndex < _loadingSteps.length
                ? _loadingSteps[_currentStepIndex]
                : widget.loadingText,
            key: ValueKey(_currentStepIndex),
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}