import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/screens/goal_details.dart';
import '../models/goal.dart';

class GoalCard extends StatelessWidget {
  final AppData appData;
  final Goal goal;
  final VoidCallback onChanged;

  const GoalCard({super.key, required this.appData, required this.goal, required this.onChanged});

  bool get _isComplete => goal.progress >= 1;

  Color _progressColor() {
    if (goal.progress >= 6 / 7) return const Color(0xFF002017);
    if (goal.progress >= 5 / 7) return const Color(0xFF004231);
    if (goal.progress >= 4 / 7) return const Color(0xFF00674F);
    if (goal.progress >= 3 / 7) return const Color(0xFF008F6F);
    if (goal.progress >= 2 / 7) return const Color(0xFF00B890);
    if (goal.progress >= 1 / 7) return const Color(0xFF00E4B2);
    return const Color(0xFFBAFFE5);
  }

  Widget _completeBar() {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF80FFB3).withValues(alpha: 0.35),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF80FFB3).withValues(alpha: 0.5), width: 1.0),
          gradient: const RadialGradient(
            colors: [Colors.white, Color(0xFFE6FFFA)],
            radius: 4.0,
          ),
        ),
      ),
    );
  }

  Widget _progressBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: LinearProgressIndicator(
        value: goal.targetedAmount > 0 ? goal.progress.clamp(0, 1) : 0,
        minHeight: 12.h,
        backgroundColor: const Color(0xFFD9D9D9),
        color: _progressColor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final symbol = appData.currency.symbol;
    final percent = goal.targetedAmount > 0 ? (goal.progress * 100).clamp(0, 100) : 0;

    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalDetailPage(goal: goal, appData: appData),
          ),
        );
        onChanged();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${percent.toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: _isComplete ? const Color(0xFF00B890) : Colors.black54),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            _isComplete ? _completeBar() : _progressBar(),

            SizedBox(height: 10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$symbol ${goal.savedAmount.toStringAsFixed(2)} saved',
                  style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                ),
                Text(
                  '$symbol ${goal.targetedAmount.toStringAsFixed(2)} goal',
                  style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}