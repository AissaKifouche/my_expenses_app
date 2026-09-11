import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:my_expenses/screens/transaction_details.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final Function(String) onDelete;
  const TransactionCard({super.key, required this.transaction, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15.r),
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailPage(transaction: transaction, onDelete: onDelete,),
            )
        );
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
                  transaction.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 6.h,),

                Text(
                  Times.formatRelativeDate(transaction.dateTime),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),

            Text(
              ( transaction.transactionType == TransactionType.expense ) ? "-\$ ${transaction.amount}" : "+\$ ${transaction.amount}",
              style: TextStyle(
                fontSize: 20.sp,
                color: ( transaction.transactionType == TransactionType.expense ) ? Colors.redAccent : Colors.greenAccent,
                fontWeight: FontWeight.w500
              ),
            )
          ],
        ),
      ),
    );
  }
}
