import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_expenses/widgets/transaction_card.dart';

import '../models/transaction.dart';

class WeekStats extends StatefulWidget {
  const WeekStats({super.key});

  @override
  State<WeekStats> createState() => _WeekStatsState();
}

class _WeekStatsState extends State<WeekStats> {

  final List<Transaction> transactions = [
    Transaction(title: "title", transactionType: TransactionType.expense, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.expense, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.income, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.expense, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.expense, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.expense, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.income, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.expense, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.expense, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.expense, category: Category.bills, dateTime: DateTime.now(), amount: 85),

  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "This Week's Transactions",
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
/*
        TransactionCard(transaction: transactions[0],),
        SizedBox(height: 15.h,),
        TransactionCard(transaction: transactions[1],),
        SizedBox(height: 15.h,),
        TransactionCard(transaction: transactions[2],),
        SizedBox(height: 15.h,),
        TransactionCard(transaction: transactions[3],),
        SizedBox(height: 15.h,),
        TransactionCard(transaction: transactions[4],),
        SizedBox(height: 15.h,),
        TransactionCard(transaction: transactions[5],),
        SizedBox(height: 15.h,),
        TransactionCard(transaction: transactions[6],),
        SizedBox(height: 15.h,),
        TransactionCard(transaction: transactions[7],),
        SizedBox(height: 15.h,),
        TransactionCard(transaction: transactions[8],),
        SizedBox(height: 15.h,),
        TransactionCard(transaction: transactions[09],),
        SizedBox(height: 15.h,),*/


      ],
    );
  }
}
