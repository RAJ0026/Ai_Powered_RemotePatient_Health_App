import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import './widgets/quick_settings_widget.dart';
import './widgets/settings_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/theme_selector_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: const SettingsHeaderWidget(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Theme Selector
                  const ThemeSelectorWidget(),

                  const SizedBox(height: 24),

                  // Quick Settings
                  const QuickSettingsWidget(),

                  const SizedBox(height: 24),

                  // Notifications Settings
                  SettingsSectionWidget(
                    title: 'Notifications',
                    subtitle: 'Manage medical alerts and reminders',
                    icon: Icons.notifications_outlined,
                    children: [
                      SettingsItemWidget(
                        title: 'Medical Alerts',
                        subtitle: 'Critical health notifications',
                        leadingIcon: Icons.medical_services_outlined,
                        trailing: _buildStatusChip(context, 'Enabled', true),
                        onTap: () => _showNotificationSettings(
                            context, 'Medical Alerts'),
                      ),
                      SettingsItemWidget(
                        title: 'Appointment Reminders',
                        subtitle: 'Scheduled check-in notifications',
                        leadingIcon: Icons.schedule_outlined,
                        trailing: _buildStatusChip(context, 'Enabled', true),
                        onTap: () => _showNotificationSettings(
                            context, 'Appointment Reminders'),
                      ),
                      SettingsItemWidget(
                        title: 'Device Sync Alerts',
                        subtitle: 'Bluetooth device connection status',
                        leadingIcon: Icons.bluetooth_outlined,
                        trailing: _buildStatusChip(context, 'Disabled', false),
                        onTap: () => _showNotificationSettings(
                            context, 'Device Sync Alerts'),
                        isLast: true,
                      ),
                    ],
                  ),

                  // Privacy & Security Settings
                  SettingsSectionWidget(
                    title: 'Privacy & Security',
                    subtitle: 'Protect your health data',
                    icon: Icons.security_outlined,
                    iconColor: const Color(0xFF34C759),
                    children: [
                      SettingsItemWidget(
                        title: 'Biometric Settings',
                        subtitle: 'Touch ID, Face ID authentication',
                        leadingIcon: Icons.fingerprint,
                        onTap: () => _showSecuritySettings(
                            context, 'Biometric Settings'),
                      ),
                      SettingsItemWidget(
                        title: 'Session Timeout',
                        subtitle: 'Auto-logout after inactivity',
                        leadingIcon: Icons.timer_outlined,
                        trailing: Text(
                          '15 min',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.7),
                          ),
                        ),
                        onTap: () =>
                            _showSecuritySettings(context, 'Session Timeout'),
                      ),
                      SettingsItemWidget(
                        title: 'Data Sharing',
                        subtitle: 'HIPAA compliance settings',
                        leadingIcon: Icons.share_outlined,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF34C759).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF34C759)
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user,
                                size: 14,
                                color: const Color(0xFF34C759),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'HIPAA',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF34C759),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () =>
                            _showSecuritySettings(context, 'Data Sharing'),
                        isLast: true,
                      ),
                    ],
                  ),

                  // Account Management
                  SettingsSectionWidget(
                    title: 'Account Management',
                    subtitle: 'Profile and subscription settings',
                    icon: Icons.person_outline,
                    iconColor: const Color(0xFF007AFF),
                    children: [
                      SettingsItemWidget(
                        title: 'Edit Profile',
                        subtitle: 'Update personal information',
                        leadingIcon: Icons.edit_outlined,
                        onTap: () =>
                            _showAccountSettings(context, 'Edit Profile'),
                      ),
                      SettingsItemWidget(
                        title: 'Subscription Status',
                        subtitle: 'AI HealthMonitor Pro plan',
                        leadingIcon: Icons.workspace_premium_outlined,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF007AFF).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Premium',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF007AFF),
                            ),
                          ),
                        ),
                        onTap: () => _showAccountSettings(
                            context, 'Subscription Status'),
                      ),
                      SettingsItemWidget(
                        title: 'Emergency Contacts',
                        subtitle: 'Critical care contact information',
                        leadingIcon: Icons.emergency_outlined,
                        iconColor: const Color(0xFFFF3B30),
                        onTap: () =>
                            _showAccountSettings(context, 'Emergency Contacts'),
                      ),
                      SettingsItemWidget(
                        title: 'Logout',
                        subtitle: 'Sign out of your account',
                        leadingIcon: Icons.logout,
                        iconColor: const Color(0xFFFF3B30),
                        onTap: () => _showLogoutConfirmation(context),
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // App Information
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.dividerColor,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.medical_services,
                          color: theme.primaryColor,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AI HealthMonitor Pro',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.titleMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 2.1.0 • Build 2412',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '© 2025 Healthcare Innovations Inc.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: theme.textTheme.bodySmall?.color
                                ?.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(BuildContext context, String label, bool isEnabled) {
    final theme = Theme.of(context);
    final color = isEnabled ? const Color(0xFF34C759) : const Color(0xFFFF9500);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context, String setting) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        title: Text(
          setting,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        content: Text(
          'This feature allows you to customize $setting preferences for optimal healthcare monitoring.',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSecuritySettings(BuildContext context, String setting) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        title: Row(
          children: [
            Icon(
              Icons.security,
              color: const Color(0xFF34C759),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              setting,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
          ],
        ),
        content: Text(
          'Your health data is protected with enterprise-grade security. $setting ensures compliance with medical data protection standards.',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAccountSettings(BuildContext context, String setting) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        title: Text(
          setting,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        content: Text(
          'Access $setting to manage your healthcare profile and subscription preferences.',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        title: Row(
          children: [
            Icon(
              Icons.logout,
              color: const Color(0xFFFF3B30),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to sign out? You\'ll need to login again to access your health data.',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color:
                    theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to login screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-screen',
                (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFF3B30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
