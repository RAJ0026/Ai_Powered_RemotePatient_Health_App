import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QrScannerDialog extends StatefulWidget {
  final Function(String) onQrCodeScanned;
  final VoidCallback onCancel;

  const QrScannerDialog({
    Key? key,
    required this.onQrCodeScanned,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<QrScannerDialog> createState() => _QrScannerDialogState();
}

class _QrScannerDialogState extends State<QrScannerDialog>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _scannerController;
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(4.w),
      child: Container(
        width: double.infinity,
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
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
                  CustomIconWidget(
                    iconName: 'qr_code_scanner',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan QR Code',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Point camera at device QR code',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
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

            // Scanner Area
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: _scannerController,
                        onDetect: (BarcodeCapture capture) {
                          if (_isScanning && capture.barcodes.isNotEmpty) {
                            final String? code =
                                capture.barcodes.first.rawValue;
                            if (code != null) {
                              setState(() {
                                _isScanning = false;
                              });
                              widget.onQrCodeScanned(code);
                            }
                          }
                        },
                      ),

                      // Scanning overlay
                      if (_isScanning)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                          child: Stack(
                            children: [
                              // Corner brackets
                              Positioned(
                                top: 20.h,
                                left: 20.w,
                                child: _buildCornerBracket(true, true),
                              ),
                              Positioned(
                                top: 20.h,
                                right: 20.w,
                                child: _buildCornerBracket(true, false),
                              ),
                              Positioned(
                                bottom: 20.h,
                                left: 20.w,
                                child: _buildCornerBracket(false, true),
                              ),
                              Positioned(
                                bottom: 20.h,
                                right: 20.w,
                                child: _buildCornerBracket(false, false),
                              ),

                              // Scanning line
                              AnimatedBuilder(
                                animation: _scanLineAnimation,
                                builder: (context, child) {
                                  return Positioned(
                                    top: 20.h +
                                        (30.h * _scanLineAnimation.value),
                                    left: 20.w,
                                    right: 20.w,
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            AppTheme
                                                .lightTheme.colorScheme.primary,
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                      // Success overlay
                      if (!_isScanning)
                        Container(
                          color: AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.2),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 8.w,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Instructions
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Text(
                    'Position the QR code within the frame',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'The QR code is usually found on the device packaging or in the user manual',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Actions
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Manual entry option
                        _showManualEntryDialog();
                      },
                      child: Text('Manual Entry'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerBracket(bool isTop, bool isLeft) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary, width: 3)
              : BorderSide.none,
          bottom: !isTop
              ? BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary, width: 3)
              : BorderSide.none,
          left: isLeft
              ? BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary, width: 3)
              : BorderSide.none,
          right: !isLeft
              ? BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary, width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }

  void _showManualEntryDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Device Code'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter device serial number or code',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                widget.onQrCodeScanned(controller.text);
              }
            },
            child: Text('Add Device'),
          ),
        ],
      ),
    );
  }
}
