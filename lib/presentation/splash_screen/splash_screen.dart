import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/app_title_widget.dart';
import './widgets/gradient_background_widget.dart';
import './widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late Animation<double> _fadeAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  // Mock user authentication states
  final Map<String, dynamic> _mockUserData = {
    'isAuthenticated': true,
    'userType': 'doctor', // 'doctor', 'patient', or 'new'
    'biometricEnabled': true,
    'hasHealthKitPermission': true,
    'deviceConnections': ['Apple Watch', 'Blood Pressure Monitor'],
    'lastSync': DateTime.now().subtract(const Duration(minutes: 5)),
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
    _setSystemUIOverlay();
  }

  void _setupAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeIn,
    ));

    _mainAnimationController.forward();
  }

  void _setSystemUIOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization process
      await Future.delayed(const Duration(milliseconds: 500));
      await _checkBiometricAuthentication();

      await Future.delayed(const Duration(milliseconds: 500));
      await _loadEncryptedPreferences();

      await Future.delayed(const Duration(milliseconds: 500));
      await _fetchMedicalDeviceConnections();

      await Future.delayed(const Duration(milliseconds: 500));
      await _prepareCachedHealthData();

      await Future.delayed(const Duration(milliseconds: 500));
      await _finalizeInitialization();

      setState(() {
        _isInitialized = true;
      });

      // Navigate after initialization
      Timer(const Duration(milliseconds: 800), () {
        _navigateToNextScreen();
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize secure healthcare services';
      });

      // Retry after error display
      Timer(const Duration(seconds: 3), () {
        _retryInitialization();
      });
    }
  }

  Future<void> _checkBiometricAuthentication() async {
    // Simulate biometric check
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation - in real app would use local_auth package
  }

  Future<void> _loadEncryptedPreferences() async {
    // Simulate loading encrypted user preferences
    await Future.delayed(const Duration(milliseconds: 400));
    // Mock implementation - in real app would use secure storage
  }

  Future<void> _fetchMedicalDeviceConnections() async {
    // Simulate fetching connected medical devices
    await Future.delayed(const Duration(milliseconds: 350));
    // Mock implementation - in real app would check Bluetooth connections
  }

  Future<void> _prepareCachedHealthData() async {
    // Simulate preparing cached health data
    await Future.delayed(const Duration(milliseconds: 450));
    // Mock implementation - in real app would sync with HealthKit/Google Fit
  }

  Future<void> _finalizeInitialization() async {
    // Simulate final initialization steps
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation - in real app would complete security checks
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    // Navigation logic based on user state
    String nextRoute;

    if (_mockUserData['isAuthenticated'] == true) {
      if (_mockUserData['userType'] == 'doctor') {
        nextRoute = '/doctor-dashboard';
      } else if (_mockUserData['userType'] == 'patient') {
        nextRoute = '/patient-health-tracking';
      } else {
        nextRoute = '/login-screen';
      }
    } else {
      nextRoute = '/login-screen';
    }

    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _isInitialized = false;
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackgroundWidget(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _hasError ? _buildErrorView() : _buildMainContent(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),

        // Animated Logo
        const AnimatedLogoWidget(),

        SizedBox(height: 4.h),

        // App Title
        const AppTitleWidget(),

        const Spacer(flex: 2),

        // Loading Indicator
        const LoadingIndicatorWidget(),

        SizedBox(height: 8.h),

        // HIPAA Compliance Badge
        _buildComplianceBadge(),

        const Spacer(),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'error_outline',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 12.w,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Initialization Error',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _errorMessage,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 3.h),
                  ElevatedButton(
                    onPressed: _retryInitialization,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: 'verified_user',
            color: Colors.white,
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Text(
            'HIPAA Compliant',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
