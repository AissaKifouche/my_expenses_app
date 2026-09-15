import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:my_expenses/screens/transaction_details.dart';

class TransactionCard extends StatelessWidget {
  final AppData appData;
  final Transaction transaction;
  final Function(String) onDelete;
  final Function(Transaction) onUpdate;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onDelete,
    required this.onUpdate,
    required this.appData,
  });

  static const _income = Color(0xFF058E84);
  static const _expense = Color(0xFFE0674A);

  bool get _isExpense => transaction.transactionType == TransactionType.expense;
  Color get _accent => _isExpense ? _expense : _income;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.r),
      splashColor: _accent.withValues(alpha: 0.08),
      highlightColor: _accent.withValues(alpha: 0.04),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailPage(
              transaction: transaction,
              onDelete: onDelete,
              onUpdate: onUpdate,
              appData: appData,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.black.withAlpha(25)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // category icon badge
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                TransactionDetailPage.categoryIcon(transaction.category),
                size: 20.sp,
                color: _accent,
              ),
            ),
            SizedBox(width: 14.w),

            // title + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black87),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    Times.formatRelativeDate(transaction.dateTime),
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),

            // amount
            Text(
              '${_isExpense ? '-' : '+'}${appData.currency.symbol} ${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.sp, color: _accent, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}