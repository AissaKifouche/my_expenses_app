import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_expenses/widgets/transaction_card.dart';

class DayStats extends StatefulWidget {
  const DayStats({super.key});

  @override
  State<DayStats> createState() => _DayStatsState();
}

class _DayStatsState extends State<DayStats> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Transactions",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500
              ),
            ),
            GestureDetector(
              child: SvgPicture.asset("assets/images/arrow-down-wide-narrow.svg"),
              onTap: (){
                //TBD
              },
            ),
          ],
        ),

        SizedBox(height: 25.h,),

        TransactionCard(),
        SizedBox(height: 15.h,),
        TransactionCard(),
        SizedBox(height: 15.h,),
        TransactionCard(),
        SizedBox(height: 15.h,),
        TransactionCard(),
        SizedBox(height: 15.h,),
        TransactionCard(),
        SizedBox(height: 15.h,),

      ],
    );
  }
}
