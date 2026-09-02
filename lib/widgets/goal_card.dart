import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoalCard extends StatefulWidget {
  const GoalCard({super.key});

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
            color: const Color(0xFF80FFB3).withOpacity(0.35),
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
            color: const Color(0xFF80FFB3).withOpacity(0.5),
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: (){
        //TBD
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
                "Car",
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
                  "\$ 30000",
                ),
                Text(
                  "\$ 30000",
                ),
              ],
            ),

            SizedBox(height: 10.h,),

            completeLinearProgress(),
          ],
        ),
      ),
    );
  }
}
