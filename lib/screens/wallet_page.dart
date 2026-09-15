import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/models/goal.dart';
import 'package:my_expenses/screens/add_goal_sheet.dart';
import 'package:my_expenses/widgets/goal_card.dart';

class WalletPage extends StatefulWidget {
  final AppData appData;
  const WalletPage({super.key, required this.appData});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  static const _teal = Color(0xFF219289);

  @override
  Widget build(BuildContext context) {
    final balance = widget.appData.wallet.balance;
    final symbol = widget.appData.currency.symbol;
    final goals = widget.appData.goals;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F8),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newGoal = await showModalBottomSheet<Goal>(
            useSafeArea: true,
            isScrollControlled: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            context: context,
            builder: (context) {
              return AddGoalSheet(appData: widget.appData);
            },
          );

          if (newGoal != null) {
            setState(() {
              widget.appData.addGoal(newGoal);
            });
          }
        },
        backgroundColor: const Color(0xFF2F948D),
        label: Text(
          "Add a goal",
          style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
        icon: Icon(Icons.add_rounded, color: Colors.white, size: 22.sp),
      ),
      appBar: AppBar(
        backgroundColor: _teal,
        title: Text(
          "Wallet",
          style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // wallet balance card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 26.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: balance >= 0
                        ? [const Color(0xFF429690), const Color(0xFF058E84)]
                        : [const Color(0xFFE0674A), const Color(0xFFC94A2E)],
                  ),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet_rounded, color: Colors.white70, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          widget.appData.wallet.name,
                          style: TextStyle(color: Colors.white70, fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '$symbol ${balance.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white, fontSize: 34.sp, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your goals',
                    style: TextStyle(color: Colors.black87, fontSize: 19.sp, fontWeight: FontWeight.w600),
                  ),
                  if (goals.isNotEmpty)
                    Text(
                      '${goals.length}',
                      style: TextStyle(color: Colors.black45, fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                ],
              ),

              SizedBox(height: 16.h),

              if (goals.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 36.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.flag_outlined, size: 28.sp, color: Colors.black26),
                      SizedBox(height: 10.h),
                      Text(
                        'No goals yet — tap "Add a goal" to start saving',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black45, fontSize: 14.sp),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: goals
                      .map((goal) => Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: GoalCard(
                      goal: goal,
                      appData: widget.appData,
                      onChanged: () => setState(() {}),
                    ),
                  ))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}