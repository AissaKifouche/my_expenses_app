import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/buttom_clipper.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/screens/add_transaction_sheet.dart';
import 'package:my_expenses/widgets/budget_card.dart';
import 'package:my_expenses/widgets/transaction_card.dart';

class HomePage extends StatefulWidget {
  final AppData appData;
  final void Function(int) onNavigateToTab;
  const HomePage({super.key, required this.onNavigateToTab, required this.appData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // most recent first, capped at 5
    final sortedTransactions = [...widget.appData.transactions]
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    final recentTransactions = sortedTransactions.take(5).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newTransaction = await showModalBottomSheet<Transaction>(
              useSafeArea: true,
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              context: context,
              builder: (context) => AddTransactionSheet(appData: widget.appData),
            );

            if (newTransaction != null) {
              setState(() {
                widget.appData.addTransaction(newTransaction);
              });
            }
          },
          backgroundColor: const Color(0xFF2F948D),
          child: Icon(Icons.add_rounded, color: Colors.white, size: 26.sp),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // the top green container
                      ClipPath(
                        clipper: BottomCurveClipper(),
                        child: Container(
                          height: 300.h,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 35.h),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF429690), Color(0xFF058E84)],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Text(
                                _greeting,
                                style: TextStyle(fontSize: 16.sp, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 70.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recent Transactions",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (sortedTransactions.isNotEmpty)
                                  TextButton(
                                    onPressed: () => widget.onNavigateToTab(1),
                                    child: Text(
                                      "See all",
                                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(height: 20.h),

                            if (recentTransactions.isEmpty)
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 36.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(color: Colors.black.withAlpha(25)),
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Icon(Icons.receipt_long_outlined, size: 28.sp, color: Colors.black26),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'No transactions yet',
                                      style: TextStyle(color: Colors.black45, fontSize: 14.sp),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...recentTransactions.map((transaction) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 15.h),
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
                        ),
                      ),

                      SizedBox(height: 100.h), // clears the FAB at the bottom
                    ],
                  ),
                  Positioned(
                    top: 120.h,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: BudgetCard(appData: widget.appData),
                    ),
                  ),
                ],
              ),
            ),

            // status bar's background color
            Container(
              height: statusBarHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withAlpha(90), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}