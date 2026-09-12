import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/models/monthly_budget.dart';
import 'package:intl/intl.dart';

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

    int i = widget.appData.budgets.indexWhere((b) => b.year == now.year && b.month == now.month);
    if( i == -1 ){

    }
    else{
      monthlyBudget = widget.appData.budgets[i];
    }




    return (monthlyBudget == null)? noBudgetExist() : budgetExists(monthlyBudget);

  }



  Widget budgetExists(MonthlyBudget budget){
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
              " \$${budget.spent.toStringAsFixed(2)}",
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
                  "Budget: \$${budget.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),

                Text(
                  "Remaining: \$${budget.remaining.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                )
              ],
            ),

            SizedBox(height: 15.h,),

            LinearProgressIndicator(
              value: (budget.spent / budget.amount).clamp(0, 1),
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
                  "${((budget.spent / budget.amount).clamp(0, 1) * 100).toStringAsFixed(2)}% used",
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

  Widget noBudgetExist(){
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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat("MMMM yyyy").format(now),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp
            ),
          ),

          SizedBox(height: 20.h,),

          Text(
            "No budget set",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp
            ),
          ),

          SizedBox(height: 20.h,),


          InkWell(
            onTap: (){

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Icon(Icons.add, color: Colors.white,),

                SizedBox(width: 10.w,),

                Text(
                  "Set monthly budget",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
