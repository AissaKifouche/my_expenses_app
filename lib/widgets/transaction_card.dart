import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:flutter_utils/flutter_utils.dart';

class TransactionCard extends StatefulWidget {
  final Transaction transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  widget.transaction.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 6.h,),

                Text(
                  Times.formatRelativeDate(widget.transaction.dateTime),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            Text(
              ( widget.transaction.transactionType == TransactionType.expense ) ? "-\$ ${widget.transaction.amount}" : "\$ ${widget.transaction.amount}",
              style: TextStyle(
                fontSize: 20.sp,
                color: ( widget.transaction.transactionType == TransactionType.expense ) ? Colors.redAccent : Colors.greenAccent,
                fontWeight: FontWeight.w500
              ),
            )
          ],
        ),
      ),
    );
  }
}
