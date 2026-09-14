import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/screens/goal_details.dart';

import '../models/goal.dart';

class GoalCard extends StatefulWidget {
  final AppData appData;
  final Goal goal;
  final VoidCallback onChanged;
  const GoalCard({super.key, required this.appData, required this.goal, required this.onChanged});

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {

  Widget completeLinearProgress(){
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        // Outer ambient aura - lower opacity and lighter green
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
          // Inner glowing edge illusion - subtle mint border
          border: Border.all(
            color: const Color(0xFF80FFB3).withValues(alpha: 0.5),
            width: 1.0,
          ),
          gradient: const RadialGradient(
            colors: [
              Colors.white,
              Color(0xFFE6FFFA), // Extremely light white-mint accent
            ],
            radius: 4.0, // Expanded radius to prioritize white center
          ),
        ),
      ),
    );
  }


  Widget uncompletedLinearProgress(Goal goal){
    Color color;

    if ( goal.savedAmount >= 6/7 * goal.targetedAmount ){
      color = Color(0xFF002017);
    } else if (goal.savedAmount >= 5/7 * goal.targetedAmount){
      color = Color(0xFF004231);
    } else if (goal.savedAmount >= 4/7 * goal.targetedAmount){
      color = Color(0xFF00674F);
    } else if (goal.savedAmount >= 3/7 * goal.targetedAmount){
      color = Color(0xFF008F6F);
    } else if (goal.savedAmount >= 2/7 * goal.targetedAmount){
      color = Color(0xFF00B890);
    } else if (goal.savedAmount >= 1/7 * goal.targetedAmount){
      color = Color(0xFF00E4B2);
    } else {
      color = Color(0xFFBAFFE5);
    }

    return LinearProgressIndicator(
      value: goal.savedAmount / goal.targetedAmount,
      backgroundColor: Color(0xFFD9D9D9),
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalDetailPage(goal: widget.goal, appData: widget.appData,),
          ),
        );
        widget.onChanged();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: BoxBorder.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.goal.title,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: 15.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$ ${widget.goal.savedAmount}",
                ),
                Text(
                  "\$ ${widget.goal.targetedAmount}",
                ),
              ],
            ),

            SizedBox(height: 10.h,),


            widget.goal.savedAmount / widget.goal.targetedAmount >= 1 ? completeLinearProgress() : uncompletedLinearProgress(widget.goal),

          ],
        ),
      ),
    );
  }
}
