import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/widgets/currency.dart';
import 'package:my_expenses/database/database_backup_service.dart';
import 'package:my_expenses/database/app_database.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  final AppData appData;
  const SettingsPage({super.key, required this.appData});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isBackingUp = false;
  DateTime? _lastBackup;

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor:
          isError ? Colors.red.shade700 : const Color(0xFF219289),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white,
                size: 22.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }

  Future<void> _backupData() async {
    if (_isBackingUp) return;

    HapticFeedback.lightImpact();
    setState(() => _isBackingUp = true);

    try {
      final database = context.read<AppDatabase>();
      final backupService = DatabaseBackupService(database);

      final result = await backupService.saveBackup();

      if (!mounted) return;

      if (result != null) {
        HapticFeedback.mediumImpact();
        setState(() => _lastBackup = DateTime.now());
        _showSnack('Backup saved successfully');
      }
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      _showSnack("Couldn't create backup. Please try again.", isError: true);
      debugPrint('Backup error: $e');
    } finally {
      if (mounted) setState(() => _isBackingUp = false);
    }
  }

  String get _backupSubtitle {
    if (_isBackingUp) return "Please wait, this won't take long";
    if (_lastBackup != null) {
      final time = TimeOfDay.fromDateTime(_lastBackup!).format(context);
      return 'Last backup today at $time';
    }
    return 'Save a copy of your expenses to your device';
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF219289),
          title: Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30.h),

                // ── Currency ──────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Currency",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                          ),
                        ),
                        CurrencyContainerPicker(
                          selectedCurrency: widget.appData.currency,
                          onCurrencySelected: (currency) async {
                            try {
                              await widget.appData.changeCurrency(currency);

                              if (!mounted) return;
                              setState(() {});
                            } catch (e) {
                              if (!mounted) return;
                              _showSnack(
                                'Failed to update currency',
                                isError: true,
                              );
                            }
                          },
                          currencies: widget.appData.currencies,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // ── Backup ────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Material(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: InkWell(
                      onTap: _isBackingUp ? null : _backupData,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.r),
                              decoration: BoxDecoration(
                                color: const Color(0xFF219289)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Icon(
                                Icons.cloud_upload_outlined,
                                color: const Color(0xFF219289),
                                size: 26.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      _isBackingUp
                                          ? 'Creating backup…'
                                          : 'Backup Data',
                                      key: ValueKey(_isBackingUp),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    _backupSubtitle,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _isBackingUp
                                  ? SizedBox(
                                key: const ValueKey('loading'),
                                width: 22.sp,
                                height: 22.sp,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Color(0xFF219289),
                                ),
                              )
                                  : Icon(
                                Icons.arrow_forward_ios,
                                key: const ValueKey('arrow'),
                                color: Colors.grey,
                                size: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}