import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/widgets/currency.dart';
import 'package:my_expenses/database/database_backup_service.dart';
import 'package:my_expenses/database/app_database.dart';
import 'package:provider/provider.dart';

const _brandColor = Color(0xFF219289);

class SettingsPage extends StatefulWidget {
  final AppData appData;
  const SettingsPage({super.key, required this.appData});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isBackingUp = false;
  bool _isRestoring = false;
  DateTime? _lastBackup;

  bool get _isBusy => _isBackingUp || _isRestoring;

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? Colors.red.shade700 : _brandColor,
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

  // ── Backup ────────────────────────────────────────────────

  Future<void> _backupData() async {
    if (_isBusy) return;

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

  // ── Restore ───────────────────────────────────────────────

  Future<bool> _confirmRestore() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        icon: Icon(
          Icons.warning_amber_rounded,
          color: Colors.orange.shade700,
          size: 40.sp,
        ),
        title: const Text('Restore backup?'),
        content: const Text(
          'This will replace all your current wallet, transactions, '
              'goals, and budgets with the data from this backup.\n\n'
              'This action cannot be undone.',
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Replace my data'),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _restoreData() async {
    if (_isBusy) return;

    HapticFeedback.lightImpact();

    try {
      final backupService = DatabaseBackupService(widget.appData.database);

      // Select a backup file.
      final backup = await backupService.readBackupFile();
      if (backup == null || !mounted) return;

      // Validate the selected backup.
      final data = await backupService.validateBackup(backup);
      if (!mounted) return;

      // Ask for confirmation before replacing existing data.
      HapticFeedback.mediumImpact();
      final confirmed = await _confirmRestore();
      if (!confirmed || !mounted) return;

      setState(() => _isRestoring = true);

      // Restore database.
      await backupService.restoreBackup(data);

      // Refresh in-memory application data.
      await widget.appData.initialize();

      if (!mounted) return;
      HapticFeedback.mediumImpact();
      _showSnack('Backup restored successfully');
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      _showSnack(
        "Couldn't restore backup. The file may be invalid or corrupted.",
        isError: true,
      );
      debugPrint('Restore error: $e');
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  String get _restoreSubtitle {
    if (_isRestoring) return "Don't close the app";
    return 'Replace current data with a saved backup file';
  }

  // ── UI ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _brandColor,
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
                  child: _ActionTile(
                    icon: Icons.cloud_upload_outlined,
                    title: 'Backup Data',
                    busyTitle: 'Creating backup…',
                    subtitle: _backupSubtitle,
                    isBusy: _isBackingUp,
                    isDisabled: _isRestoring,
                    onTap: _backupData,
                  ),
                ),

                SizedBox(height: 15.h),

                // ── Restore ───────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _ActionTile(
                    icon: Icons.cloud_download_outlined,
                    title: 'Restore Data',
                    busyTitle: 'Restoring backup…',
                    subtitle: _restoreSubtitle,
                    isBusy: _isRestoring,
                    isDisabled: _isBackingUp,
                    onTap: _restoreData,
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

/// Reusable settings action row with icon badge, subtitle,
/// loading spinner, and disabled state.
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String busyTitle;
  final String subtitle;
  final bool isBusy;
  final bool isDisabled;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.busyTitle,
    required this.subtitle,
    required this.isBusy,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inactive = isBusy || isDisabled;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isDisabled ? 0.5 : 1,
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: InkWell(
          onTap: inactive ? null : onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: _brandColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(icon, color: _brandColor, size: 26.sp),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          isBusy ? busyTitle : title,
                          key: ValueKey(isBusy),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
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
                  child: isBusy
                      ? SizedBox(
                    key: const ValueKey('loading'),
                    width: 22.sp,
                    height: 22.sp,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: _brandColor,
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
    );
  }
}