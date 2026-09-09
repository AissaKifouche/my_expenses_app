import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/models/transaction.dart'; // adjust path to your model file


class TransactionDetailPage extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  static const _teal = Color(0xFF058E84);
  static const _tealDark = Color(0xFF06655E);
  static const _expense = Colors.red; // warm coral, not alarm-red
  static const _bg = Colors.white;

  bool get _isIncome => transaction.transactionType == TransactionType.income;
  Color get _accent => _isIncome ? _teal : _expense;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light
      ),
      child: Scaffold(
        backgroundColor: _bg,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header(transaction: transaction, accent: _accent, isIncome: _isIncome)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionCard(
                      children: [
                        _DetailRow(
                          label: 'Category',
                          value: _categoryLabel(transaction.category),
                          icon: _categoryIcon(transaction.category),
                        ),
                        const _RowDivider(),
                        _DetailRow(
                          label: 'Type',
                          value: _isIncome ? 'Income' : 'Expense',
                          icon: _isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
                        ),
                        const _RowDivider(),
                        _DetailRow(
                          label: 'Date',
                          value: _formatDate(transaction.dateTime),
                          icon: Icons.calendar_today_rounded,
                        ),
                        const _RowDivider(),
                        _DetailRow(
                          label: 'Time',
                          value: _formatTime(transaction.dateTime),
                          icon: Icons.schedule_rounded,
                        ),
                      ],
                    ),
                    if (transaction.note != null && transaction.note!.trim().isNotEmpty) ...[
                      SizedBox(height: 20.h),
                      Text(
                        'Note',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          transaction.note!,
                          style: TextStyle(fontSize: 15.sp, color: Colors.black87, height: 1.4),
                        ),
                      ),
                    ],
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: hook up edit flow
                            },
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _tealDark,
                              side: BorderSide(color: _tealDark.withValues(alpha: 0.4)),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: hook up delete flow
                            },
                            icon: const Icon(Icons.delete_outline_rounded, size: 18),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFBEAE6),
                              foregroundColor: const Color(0xFFB3402B),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _categoryLabel(Category c) {
    switch (c) {
      case Category.food:
        return 'Food';
      case Category.bills:
        return 'Bills';
      case Category.entertainment:
        return 'Entertainment';
      case Category.studies:
        return 'Studies';
      case Category.travel:
        return 'Travel';
      case Category.other:
        return 'Other';
    }
  }

  static IconData _categoryIcon(Category c) {
    switch (c) {
      case Category.food:
        return Icons.restaurant_rounded;
      case Category.bills:
        return Icons.receipt_long_rounded;
      case Category.entertainment:
        return Icons.movie_creation_outlined;
      case Category.studies:
        return Icons.school_outlined;
      case Category.travel:
        return Icons.flight_takeoff_rounded;
      case Category.other:
        return Icons.category_outlined;
    }
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  static String _formatTime(DateTime d) {
    final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

/// Top banner: back button, category icon badge and the headline amount.
class _Header extends StatelessWidget {
  final Transaction transaction;
  final Color accent;
  final bool isIncome;

  const _Header({required this.transaction, required this.accent, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, MediaQuery.of(context).padding.top + 12.h, 20.w, 36.h),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20.r),
                onTap: () => Navigator.of(context).maybePop(),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Transaction',
                style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(height: 28.h),
          Text(
            transaction.title,
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6.h),
          Text(
            '${isIncome ? '+' : '-'} ${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(color: Colors.white, fontSize: 40.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(children: children),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.black45),
          SizedBox(width: 14.w),
          Text(label, style: TextStyle(fontSize: 18.sp, color: Colors.black54)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.normal, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 10.h, thickness: 1, color: Color(0xFFF0F0F0));
  }
}