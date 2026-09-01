import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetCard extends StatefulWidget {
  const BudgetCard({super.key});

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {

  double budget = 3500;
  double spent = 1562;
  double get left => budget - spent;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Color(0xFF296D68),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 15.r,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
        ]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric( horizontal: 20.0.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Spent This Month",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),

            SizedBox(height: 4.h,),

            Text(
              " \$${spent.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 30.sp,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 18.h,),

            //row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Budget: ${budget.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),

                Text(
                  "Remaining: ${left.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                )
              ],
            ),

            SizedBox(height: 15.h,),

            LinearProgressIndicator(
              value: (spent / budget).clamp(0, 1),
              backgroundColor: Color(0xFF47B943),
              color: Colors.white,
              minHeight: 10.h,
              borderRadius: BorderRadius.circular(20.r),
            ),

            SizedBox(height: 15.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${((spent / budget).clamp(0, 1) * 100).toStringAsFixed(2)}% used",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white
                  ),
                ),
                Text(
                  "9 days left",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
