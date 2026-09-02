import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_expenses/widgets/transaction_card.dart';

class YearStats extends StatefulWidget {
  const YearStats({super.key});

  @override
  State<YearStats> createState() => _YearStatsState();
}

class _YearStatsState extends State<YearStats> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "This Year's Transactions",
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
