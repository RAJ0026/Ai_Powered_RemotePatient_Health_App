import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_device_fab.dart';
import './widgets/bluetooth_status_indicator.dart';
import './widgets/device_category_section.dart';
import './widgets/pairing_instructions_dialog.dart';
import './widgets/qr_scanner_dialog.dart';

class DeviceConnection extends StatefulWidget {
  const DeviceConnection({Key? key}) : super(key: key);

  @override
  State<DeviceConnection> createState() => _DeviceConnectionState();
}

class _DeviceConnectionState extends State<DeviceConnection>
    with TickerProviderStateMixin {
  bool _isBluetoothEnabled = true;
  bool _isScanning = false;
  bool _isRefreshing = false;
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;

  final List<Map<String, dynamic>> _deviceCategories = [
    {
      'title': 'Blood Pressure Monitors',
      'devices': [
        {
          'id': 'bp_001',
          'name': 'Omron HeartGuide',
          'model': 'HEM-6410T-ZM',
          'category': 'Blood Pressure Monitors',
          'brandLogo':
              'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=200&h=200&fit=crop',
          'status': 'Connected',
          'batteryLevel': 85,
          'lastSync': '2 hours ago',
        },
        {
          'id': 'bp_002',
          'name': 'Withings BPM Core',
          'model': 'BPM-CORE-2',
          'category': 'Blood Pressure Monitors',
          'brandLogo':
              'https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=200&h=200&fit=crop',
          'status': 'Available',
          'batteryLevel': 0,
          'lastSync': 'Never',
        },
      ],
    },
    {
      'title': 'Glucose Meters',
      'devices': [
        {
          'id': 'gm_001',
          'name': 'FreeStyle Libre 2',
          'model': 'FSL-2-US',
          'category': 'Glucose Meters',
          'brandLogo':
              'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?w=200&h=200&fit=crop',
          'status': 'Connected',
          'batteryLevel': 92,
          'lastSync': '30 minutes ago',
        },
        {
          'id': 'gm_002',
          'name': 'Dexcom G6',
          'model': 'G6-CGM-US',
          'category': 'Glucose Meters',
          'brandLogo':
              'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=200&h=200&fit=crop',
          'status': 'Pairing',
          'batteryLevel': 0,
          'lastSync': 'Never',
        },
      ],
    },
    {
      'title': 'Smart Scales',
      'devices': [
        {
          'id': 'ss_001',
          'name': 'Withings Body+',
          'model': 'WBS05-ALL-EN',
          'category': 'Smart Scales',
          'brandLogo':
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&h=200&fit=crop',
          'status': 'Connected',
          'batteryLevel': 78,
          'lastSync': '1 day ago',
        },
        {
          'id': 'ss_002',
          'name': 'Fitbit Aria Air',
          'model': 'FB203BK',
          'category': 'Smart Scales',
          'brandLogo':
              'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=200&h=200&fit=crop',
          'status': 'Available',
          'batteryLevel': 0,
          'lastSync': 'Never',
        },
      ],
    },
    {
      'title': 'Fitness Trackers',
      'devices': [
        {
          'id': 'ft_001',
          'name': 'Apple Watch Series 9',
          'model': 'A2978',
          'category': 'Fitness Trackers',
          'brandLogo':
              'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?w=200&h=200&fit=crop',
          'status': 'Connected',
          'batteryLevel': 65,
          'lastSync': '5 minutes ago',
        },
        {
          'id': 'ft_002',
          'name': 'Fitbit Charge 5',
          'model': 'FB421BKBK',
          'category': 'Fitness Trackers',
          'brandLogo':
              'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=200&h=200&fit=crop',
          'status': 'Available',
          'batteryLevel': 0,
          'lastSync': 'Never',
        },
        {
          'id': 'ft_003',
          'name': 'Garmin Vivosmart 5',
          'model': 'VS5-010-02645-01',
          'category': 'Fitness Trackers',
          'brandLogo':
              'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=200&h=200&fit=crop',
          'status': 'Available',
          'batteryLevel': 0,
          'lastSync': 'Never',
        },
      ],
    },
    {
      'title': 'Heart Rate Monitors',
      'devices': [
        {
          'id': 'hrm_001',
          'name': 'Polar H10',
          'model': 'H10-92053',
          'category': 'Heart Rate Monitors',
          'brandLogo':
              'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=200&h=200&fit=crop',
          'status': 'Connected',
          'batteryLevel': 45,
          'lastSync': '10 minutes ago',
        },
        {
          'id': 'hrm_002',
          'name': 'Wahoo TICKR X',
          'model': 'WFBTHR02',
          'category': 'Heart Rate Monitors',
          'brandLogo':
              'https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=200&h=200&fit=crop',
          'status': 'Available',
          'batteryLevel': 0,
          'lastSync': 'Never',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: BluetoothStatusIndicator(
                  isBluetoothEnabled: _isBluetoothEnabled,
                  isScanning: _isScanning,
                  onToggleBluetooth: _toggleBluetooth,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = _deviceCategories[index];
                    return DeviceCategorySection(
                      categoryTitle: category['title'] as String,
                      devices: (category['devices'] as List)
                          .cast<Map<String, dynamic>>(),
                      onDeviceTap: _handleDeviceTap,
                      onSyncDevice: _handleSyncDevice,
                      onRemoveDevice: _handleRemoveDevice,
                      onDeviceSettings: _handleDeviceSettings,
                    );
                  },
                  childCount: _deviceCategories.length,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 10.h),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AddDeviceFab(
        onPressed: _showAddDeviceOptions,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Device Connection',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      actions: [
        AnimatedBuilder(
          animation: _refreshAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _refreshAnimation.value * 2 * 3.14159,
              child: IconButton(
                onPressed: _isRefreshing ? null : _startScanning,
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: _isRefreshing
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              ),
            );
          },
        ),
        IconButton(
          onPressed: _showTroubleshootingTips,
          icon: CustomIconWidget(
            iconName: 'help_outline',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    _refreshController.reset();

    Fluttertoast.showToast(
      msg: "Device list refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _toggleBluetooth() {
    setState(() {
      _isBluetoothEnabled = !_isBluetoothEnabled;
    });

    HapticFeedback.lightImpact();

    Fluttertoast.showToast(
      msg: _isBluetoothEnabled ? "Bluetooth enabled" : "Bluetooth disabled",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _startScanning() {
    if (!_isBluetoothEnabled) {
      Fluttertoast.showToast(
        msg: "Please enable Bluetooth first",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isScanning = true;
    });

    _refreshController.repeat();

    // Simulate scanning
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        _refreshController.stop();
        _refreshController.reset();

        Fluttertoast.showToast(
          msg: "Scan completed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  void _handleDeviceTap(Map<String, dynamic> device) {
    final String status = device['status'] as String? ?? 'Available';

    if (status.toLowerCase() == 'available') {
      _showPairingInstructions(device);
    } else if (status.toLowerCase() == 'connected') {
      _showDeviceDetails(device);
    } else if (status.toLowerCase() == 'pairing') {
      Fluttertoast.showToast(
        msg: "Device is currently pairing...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _showPairingInstructions(Map<String, dynamic> device) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PairingInstructionsDialog(
        device: device,
        onStartPairing: () {
          Navigator.pop(context);
          _startPairingProcess(device);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _startPairingProcess(Map<String, dynamic> device) {
    // Update device status to pairing
    setState(() {
      final categoryIndex = _deviceCategories.indexWhere(
        (category) => (category['devices'] as List).any(
          (d) => d['id'] == device['id'],
        ),
      );
      if (categoryIndex != -1) {
        final devices = _deviceCategories[categoryIndex]['devices'] as List;
        final deviceIndex = devices.indexWhere((d) => d['id'] == device['id']);
        if (deviceIndex != -1) {
          devices[deviceIndex]['status'] = 'Pairing';
        }
      }
    });

    HapticFeedback.mediumImpact();

    // Simulate pairing process
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          final categoryIndex = _deviceCategories.indexWhere(
            (category) => (category['devices'] as List).any(
              (d) => d['id'] == device['id'],
            ),
          );
          if (categoryIndex != -1) {
            final devices = _deviceCategories[categoryIndex]['devices'] as List;
            final deviceIndex =
                devices.indexWhere((d) => d['id'] == device['id']);
            if (deviceIndex != -1) {
              devices[deviceIndex]['status'] = 'Connected';
              devices[deviceIndex]['batteryLevel'] = 85;
              devices[deviceIndex]['lastSync'] = 'Just now';
            }
          }
        });

        HapticFeedback.heavyImpact();

        Fluttertoast.showToast(
          msg: "Device connected successfully!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  void _showDeviceDetails(Map<String, dynamic> device) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomImageWidget(
                            imageUrl: device['brandLogo'] as String? ?? '',
                            width: 15.w,
                            height: 15.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device['name'] as String? ?? 'Unknown Device',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              device['model'] as String? ?? 'Model Unknown',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  _buildDetailRow(
                      'Status', device['status'] as String? ?? 'Unknown'),
                  _buildDetailRow(
                      'Battery Level', '${device['batteryLevel'] ?? 0}%'),
                  _buildDetailRow(
                      'Last Sync', device['lastSync'] as String? ?? 'Never'),
                  _buildDetailRow('Data Transmission', 'Encrypted'),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _handleSyncDevice(device);
                          },
                          child: Text('Sync Now'),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _handleRemoveDevice(device);
                          },
                          child: Text('Disconnect'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSyncDevice(Map<String, dynamic> device) {
    HapticFeedback.lightImpact();

    Fluttertoast.showToast(
      msg: "Syncing ${device['name']}...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    // Simulate sync process
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          final categoryIndex = _deviceCategories.indexWhere(
            (category) => (category['devices'] as List).any(
              (d) => d['id'] == device['id'],
            ),
          );
          if (categoryIndex != -1) {
            final devices = _deviceCategories[categoryIndex]['devices'] as List;
            final deviceIndex =
                devices.indexWhere((d) => d['id'] == device['id']);
            if (deviceIndex != -1) {
              devices[deviceIndex]['lastSync'] = 'Just now';
            }
          }
        });

        Fluttertoast.showToast(
          msg: "Sync completed successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }

  void _handleRemoveDevice(Map<String, dynamic> device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Device'),
        content: Text(
            'Are you sure you want to remove ${device['name']}? This will disconnect the device and remove all stored data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _removeDevice(device);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _removeDevice(Map<String, dynamic> device) {
    setState(() {
      final categoryIndex = _deviceCategories.indexWhere(
        (category) => (category['devices'] as List).any(
          (d) => d['id'] == device['id'],
        ),
      );
      if (categoryIndex != -1) {
        final devices = _deviceCategories[categoryIndex]['devices'] as List;
        final deviceIndex = devices.indexWhere((d) => d['id'] == device['id']);
        if (deviceIndex != -1) {
          devices[deviceIndex]['status'] = 'Available';
          devices[deviceIndex]['batteryLevel'] = 0;
          devices[deviceIndex]['lastSync'] = 'Never';
        }
      }
    });

    HapticFeedback.mediumImpact();

    Fluttertoast.showToast(
      msg: "Device removed successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _handleDeviceSettings(Map<String, dynamic> device) {
    Fluttertoast.showToast(
      msg: "Opening settings for ${device['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showAddDeviceOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Add New Device',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Scan QR Code'),
              subtitle: Text('Scan device QR code for quick setup'),
              onTap: () {
                Navigator.pop(context);
                _showQrScanner();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bluetooth_searching',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Search Nearby'),
              subtitle: Text('Scan for nearby Bluetooth devices'),
              onTap: () {
                Navigator.pop(context);
                _startScanning();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Manual Entry'),
              subtitle: Text('Enter device details manually'),
              onTap: () {
                Navigator.pop(context);
                _showManualEntry();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showQrScanner() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => QrScannerDialog(
        onQrCodeScanned: (String code) {
          Navigator.pop(context);
          _processQrCode(code);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _processQrCode(String code) {
    HapticFeedback.heavyImpact();

    Fluttertoast.showToast(
      msg: "QR Code scanned: $code",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );

    // Process the QR code and add device
    // This would typically involve parsing the QR code data
    // and adding the device to the appropriate category
  }

  void _showManualEntry() {
    Fluttertoast.showToast(
      msg: "Manual device entry coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showTroubleshootingTips() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text('Troubleshooting Tips'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTipItem('Device not found?',
                  'Make sure the device is in pairing mode and within 10 feet of your phone.'),
              _buildTipItem('Connection failed?',
                  'Restart both devices and try again. Clear Bluetooth cache if needed.'),
              _buildTipItem('Sync issues?',
                  'Check internet connection and ensure device has sufficient battery.'),
              _buildTipItem('Data not updating?',
                  'Verify device permissions and check if automatic sync is enabled.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            description,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
