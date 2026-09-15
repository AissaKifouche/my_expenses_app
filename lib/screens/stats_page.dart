import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/screens/transaction_details.dart';
import 'package:my_expenses/widgets/six_months_chart.dart';

class StatsPage extends StatefulWidget {
  final AppData appData;
  const StatsPage({super.key, required this.appData});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  static const _teal = Color(0xFF219289);
  static const _income = Color(0xFF2FAE6B);
  static const _expense = Color(0xFFE0674A);

  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return selectedMonth.year == now.year && selectedMonth.month == now.month;
  }

  void _changeMonth(int delta) {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    // now tracks the month selector, so the chart updates when you navigate months
    final sixMonthData = widget.appData.getLastSixMonthsExpenses(selectedMonth.year, selectedMonth.month);
    final income = widget.appData.getMonthlyIncome(selectedMonth.year, selectedMonth.month);
    final expenses = widget.appData.getMonthlyExpenses(selectedMonth.year, selectedMonth.month);
    final balance = income - expenses;
    final symbol = widget.appData.currency.symbol;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F8),
      appBar: AppBar(
        backgroundColor: _teal,
        title: Text(
          "Statistics",
          style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // month selector
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MonthArrowButton(icon: Icons.chevron_left_rounded, onTap: () => _changeMonth(-1)),
                    Text(
                      DateFormat('MMMM yyyy').format(selectedMonth),
                      style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    _MonthArrowButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: _isCurrentMonth ? null : () => _changeMonth(1),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // net balance
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF429690), Color(0xFF058E84)],
                  ),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Net balance',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          balance >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                          color: Colors.white,
                          size: 26.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${balance >= 0 ? '' : '-'}$symbol ${balance.abs().toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white, fontSize: 30.sp, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // income / expense breakdown
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      label: 'Income',
                      amount: income,
                      symbol: symbol,
                      color: _income,
                      icon: Icons.south_west_rounded,
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: _SummaryCard(
                      label: 'Expenses',
                      amount: expenses,
                      symbol: symbol,
                      color: _expense,
                      icon: Icons.north_east_rounded,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 28.h),

              Text(
                'Spending by category',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              SizedBox(height: 14.h),

              Builder(builder: (context) {
                final categoryData = widget.appData.getMonthlyExpensesByCategory(
                  selectedMonth.year,
                  selectedMonth.month,
                );
                if (categoryData.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'No expenses this month',
                      style: TextStyle(color: Colors.black45, fontSize: 14.sp),
                    ),
                  );
                }
                final entries = categoryData.entries.toList();
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < entries.length; i++) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(7.w),
                                    decoration: BoxDecoration(
                                      color: _teal.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Icon(
                                      TransactionDetailPage.categoryIcon(entries[i].key),
                                      size: 16.sp,
                                      color: _teal,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    TransactionDetailPage.categoryLabel(entries[i].key),
                                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                                  ),
                                ],
                              ),
                              Text(
                                '$symbol ${entries[i].value.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        if (i != entries.length - 1)
                          const Divider(height: 1, color: Color(0xFFF0F0F0)),
                      ],
                    ],
                  ),
                );
              }),

              SizedBox(height: 28.h),

              Text(
                'Spending history',
                style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              SizedBox(height: 14.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(12.w, 16.h, 16.w, 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: SixMonthExpenseChart(expenses: sixMonthData, appData: widget.appData,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _MonthArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Icon(icon, size: 26.sp, color: disabled ? Colors.black26 : Colors.black87),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final String symbol;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.symbol,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10.r)),
            child: Icon(icon, size: 18.sp, color: color),
          ),
          SizedBox(height: 14.h),
          Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.black54, fontWeight: FontWeight.w500)),
          SizedBox(height: 4.h),
          Text(
            '$symbol ${amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}