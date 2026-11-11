import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/widgets/transaction_card.dart';

class AllTransactionsPage extends StatefulWidget {
  final AppData appData;
  const AllTransactionsPage({super.key, required this.appData});

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  static const _teal = Color(0xFF219289);

  TransactionType? _typeFilter; // null = show all
  DateTimeRange? _dateRange; // null = no date filter

  Future<void> _pickDateRange () async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: _dateRange,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: _teal)),
        child: child!,
      ),
    );

    if (picked == null || !mounted) return;
    setState( () => _dateRange = picked);
  }

  String _sectionLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (date.year == now.year) return DateFormat('MMMM d').format(date);
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final all = [...widget.appData.transactions]
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    final filtered = all.where(
        (t) {
          if (_typeFilter != null && t.transactionType != _typeFilter) return false;
          if (_dateRange != null) {
            final day = DateTime(t.dateTime.year, t.dateTime.month, t.dateTime.day);
            final start = DateTime(_dateRange!.start.year, _dateRange!.start.month, _dateRange!.start.day);
            final end = DateTime(_dateRange!.end.year, _dateRange!.end.month, _dateRange!.end.day);
            if (day.isBefore(start) || day.isAfter(end)) return false;
          }
          return true;
        }
    ).toList();

    // group by day
    final Map<String, List<Transaction>> grouped = {};
    for (final t in filtered) {
      final key = _sectionLabel(t.dateTime);
      grouped.putIfAbsent(key, () => []).add(t);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F8),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: _teal,
        title: Text(
          "All Transactions",
          style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // filter chips
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _typeFilter == null,
                  onTap: () => setState(() => _typeFilter = null),
                ),
                SizedBox(width: 10.w),
                _FilterChip(
                  label: 'Income',
                  selected: _typeFilter == TransactionType.income,
                  onTap: () => setState(() => _typeFilter = TransactionType.income),
                ),
                SizedBox(width: 10.w),
                _FilterChip(
                  label: 'Expenses',
                  selected: _typeFilter == TransactionType.expense,
                  onTap: () => setState(() => _typeFilter = TransactionType.expense),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 4.h),
            child: Row(
              children: [
                _FilterChip(
                  label: _dateRange == null ?
                    'Select Dates'
                    : '${DateFormat('MMM dd, yyyy').format(_dateRange!.start)} - ${DateFormat('MMM dd, yyyy').format(_dateRange!.end)}',
                  selected: _dateRange != null,
                  onTap: _pickDateRange
                ),

                if (_dateRange != null) ...[
                  SizedBox(width: 8.w,),
                  InkWell(
                    borderRadius: BorderRadius.circular(20.r),
                    onTap: () => setState(() {
                      _dateRange = null;
                    }),
                    child: Padding(
                      padding: EdgeInsets.all(6.r),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18.sp,
                        color: Colors.black45,
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 32.sp, color: Colors.black26),
                  SizedBox(height: 10.h),
                  Text(
                    _typeFilter == null && _dateRange == null ?
                        "No transactions yet"
                        : "No matching transactions",
                    style: TextStyle(color: Colors.black45, fontSize: 14.sp),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 30.h),
              itemCount: grouped.length,
              itemBuilder: (context, sectionIndex) {
                final sectionKey = grouped.keys.elementAt(sectionIndex);
                final sectionTransactions = grouped[sectionKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16.h, bottom: 10.h),
                      child: Text(
                        sectionKey,
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black45),
                      ),
                    ),
                    ...sectionTransactions.map((transaction) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: TransactionCard(
                          appData: widget.appData,
                          transaction: transaction,
                          onDelete: (id) {
                            setState(() {
                              widget.appData.deleteTransaction(id);
                            });
                          },
                          onUpdate: (updated) {
                            setState(() {
                              widget.appData.editTransaction(updated);
                            });
                          },
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF058E84) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: selected ? const Color(0xFF058E84) : Colors.black12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}