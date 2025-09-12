import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/healthcare_logo_widget.dart';
import './widgets/login_button_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/role_selection_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String _selectedRole = 'Doctor';
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isBiometricLoading = false;
  String? _emailError;
  String? _passwordError;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock credentials for different user types
  final Map<String, Map<String, String>> _mockCredentials = {
    'Doctor': {
      'email': 'dr.smith@hospital.com',
      'password': 'SecureDoc123!',
    },
    'Patient': {
      'email': 'patient@email.com',
      'password': 'Patient123!',
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupKeyboardListener();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  void _setupKeyboardListener() {
    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        _clearEmailError();
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        _clearPasswordError();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _clearEmailError() {
    if (_emailError != null) {
      setState(() {
        _emailError = null;
      });
    }
  }

  void _clearPasswordError() {
    if (_passwordError != null) {
      setState(() {
        _passwordError = null;
      });
    }
  }

  bool _validateCredentials() {
    bool isValid = true;

    // Email validation
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Medical email is required';
      });
      isValid = false;
    } else if (!_emailController.text.contains('@')) {
      setState(() {
        _emailError = 'Please enter a valid medical email';
      });
      isValid = false;
    }

    // Password validation
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Secure password is required';
      });
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      isValid = false;
    }

    return isValid;
  }

  bool _checkMockCredentials() {
    final mockCreds = _mockCredentials[_selectedRole];
    return mockCreds != null &&
        _emailController.text == mockCreds['email'] &&
        _passwordController.text == mockCreds['password'];
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!_validateCredentials()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 2));

    if (_checkMockCredentials()) {
      // Success - provide haptic feedback
      HapticFeedback.lightImpact();

      // Show success toast
      Fluttertoast.showToast(
        msg: "Login successful! Welcome to AI HealthMonitor Pro",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        textColor: Colors.white,
      );

      // Navigate to appropriate dashboard
      if (mounted) {
        final route = _selectedRole == 'Doctor'
            ? '/doctor-dashboard'
            : '/patient-health-tracking';

        Navigator.pushReplacementNamed(context, route);
      }
    } else {
      // Show error for invalid credentials
      setState(() {
        _emailError = 'Invalid medical credentials';
        _passwordError = 'Please check your login details';
      });

      // Show error toast with mock credentials hint
      Fluttertoast.showToast(
        msg:
            "Invalid credentials. Try: ${_mockCredentials[_selectedRole]!['email']}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        textColor: Colors.white,
      );

      HapticFeedback.heavyImpact();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleBiometricAuth() async {
    setState(() {
      _isBiometricLoading = true;
    });

    // Simulate biometric authentication
    await Future.delayed(const Duration(seconds: 1));

    // Success - provide haptic feedback
    HapticFeedback.lightImpact();

    Fluttertoast.showToast(
      msg: "Biometric authentication successful!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      textColor: Colors.white,
    );

    if (mounted) {
      setState(() {
        _isBiometricLoading = false;
      });

      // Navigate to appropriate dashboard
      final route = _selectedRole == 'Doctor'
          ? '/doctor-dashboard'
          : '/patient-health-tracking';

      Navigator.pushReplacementNamed(context, route);
    }
  }

  void _handleForgotPassword() {
    Fluttertoast.showToast(
      msg: "Password reset link sent to your medical email",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      textColor: Colors.white,
    );
  }

  void _handleRoleChange(String role) {
    setState(() {
      _selectedRole = role;
      _emailError = null;
      _passwordError = null;
    });

    // Clear form when role changes
    _emailController.clear();
    _passwordController.clear();
  }

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailError == null &&
        _passwordError == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),

                    // Healthcare Logo
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const HealthcareLogoWidget(),
                    ),

                    SizedBox(height: 6.h),

                    // Role Selection
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: RoleSelectionWidget(
                          selectedRole: _selectedRole,
                          onRoleChanged: _handleRoleChange,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Login Form
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: LoginFormWidget(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          isPasswordVisible: _isPasswordVisible,
                          onTogglePasswordVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          onForgotPassword: _handleForgotPassword,
                          emailError: _emailError,
                          passwordError: _passwordError,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Login Button
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: LoginButtonWidget(
                          onPressed: _handleLogin,
                          isLoading: _isLoading,
                          isEnabled: _isFormValid,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Biometric Authentication
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: BiometricAuthWidget(
                          onBiometricAuth: _handleBiometricAuth,
                          isLoading: _isBiometricLoading,
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // HIPAA Compliance Notice
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'verified_user',
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              size: 20,
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Text(
                                'HIPAA compliant medical-grade encryption ensures your health data remains secure and private.',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
