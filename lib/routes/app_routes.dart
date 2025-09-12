import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/device_connection/device_connection.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/patient_health_tracking/patient_health_tracking.dart';
import '../presentation/doctor_dashboard/doctor_dashboard.dart';
import '../presentation/patient_list/patient_list.dart';
import '../presentation/settings_screen/settings_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String deviceConnection = '/device-connection';
  static const String login = '/login-screen';
  static const String patientHealthTracking = '/patient-health-tracking';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String patientList = '/patient-list';
  static const String settingsScreen = '/settings-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    deviceConnection: (context) => const DeviceConnection(),
    login: (context) => const LoginScreen(),
    patientHealthTracking: (context) => PatientHealthTracking(),
    doctorDashboard: (context) => const DoctorDashboard(),
    patientList: (context) => const PatientList(),
    settingsScreen: (context) => const SettingsScreen(),
    // TODO: Add your other routes here
  };
}
