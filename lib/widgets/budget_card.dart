import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/models/monthly_budget.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/widgets/add_budget_window.dart';

class BudgetCard extends StatefulWidget {
  final AppData appData;
  const BudgetCard({super.key, required this.appData});

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    MonthlyBudget? monthlyBudget;
    final i = widget.appData.budgets.indexWhere((b) => b.year == now.year && b.month == now.month);
    if (i != -1) monthlyBudget = widget.appData.budgets[i];

    return monthlyBudget == null ? _noBudgetExist() : _budgetExists(monthlyBudget);
  }

  BoxDecoration get _cardDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(20.r),
    color: const Color(0xFF296D68),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 15.r,
        offset: const Offset(0, 8),
      ),
    ],
  );

  Widget _budgetExists(MonthlyBudget budget) {
    final ratio = budget.amount > 0 ? (budget.spent / budget.amount).clamp(0.0, 1.0) : 0.0;
    final percent = (ratio * 100).round();
    final isOver = budget.spent > budget.amount;
    final isNearLimit = ratio > 0.8;

    final barColor = isOver
        ? const Color(0xFFFF6B6B)
        : isNearLimit
        ? const Color(0xFFFFC857)
        : Colors.white;

    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () async {
        final updated = await showSetBudgetDialog(context, widget.appData);
        if (updated != null) {
          setState(() {
            widget.appData.addBudget(updated);
          });
        }
      },
      child: Container(
        width: double.infinity,
        decoration: _cardDecoration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Spent This Month",
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                  if (isOver)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Over budget',
                        style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),

              SizedBox(height: 6.h),

              Text(
                "${widget.appData.currency.symbol} ${budget.spent.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w700, color: Colors.white),
              ),

              SizedBox(height: 18.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Budget: ${widget.appData.currency.symbol} ${budget.amount.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 13.sp, color: Colors.white70),
                  ),
                  Text(
                    "Remaining: ${widget.appData.currency.symbol} ${budget.remaining.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 13.sp, color: Colors.white70),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: LinearProgressIndicator(
                  value: ratio,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  color: barColor,
                  minHeight: 10.h,
                ),
              ),

              SizedBox(height: 12.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$percent% used",
                    style: TextStyle(fontSize: 13.sp, color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${Times.getRemainingDaysInMonth()} left",
                    style: TextStyle(fontSize: 13.sp, color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _noBudgetExist() {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () async {
        final b = await showSetBudgetDialog(context, widget.appData);
        if (b != null) {
          setState(() {
            widget.appData.addBudget(b);
          });
        }
      },
      child: Container(
        width: double.infinity,
        decoration: _cardDecoration,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat("MMMM yyyy").format(now),
              style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Text(
              "No budget set for this month",
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 18.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "Set monthly budget",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}