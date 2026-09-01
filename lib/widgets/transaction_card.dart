import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionCard extends StatefulWidget {
  const TransactionCard({super.key});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: (){
          //tbd, opens the full details of a transaction
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: BoxBorder.all(color: Colors.black.withAlpha(25))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Food",
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 6.h,),

                  Text(
                    "Yesterday",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),

              Text(
                "-\$ 85.00",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
