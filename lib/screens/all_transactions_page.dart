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

    final filtered = _typeFilter == null
        ? all
        : all.where((t) => t.transactionType == _typeFilter).toList();

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

          Expanded(
            child: filtered.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 32.sp, color: Colors.black26),
                  SizedBox(height: 10.h),
                  Text(
                    _typeFilter == null ? 'No transactions yet' : 'No matching transactions',
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