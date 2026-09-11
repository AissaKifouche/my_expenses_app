import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/buttom_clipper.dart';
import 'package:my_expenses/models/transaction.dart';
import 'package:my_expenses/screens/add_transaction_sheet.dart';
import 'package:my_expenses/widgets/budget_card.dart';
import 'package:my_expenses/widgets/transaction_card.dart';


class HomePage extends StatefulWidget {
  final void Function(int) onNavigateToTab;
  const HomePage({super.key, required this.onNavigateToTab});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Transaction> transactions = [
    Transaction(title: "title", transactionType: TransactionType.expense, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.expense, category: Category.bills, dateTime: DateTime.now(), amount: 85),
    Transaction(title: "title", transactionType: TransactionType.income, category: Category.salary, dateTime: DateTime.now(), amount: 85),
  ];

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top ;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newTransaction = await showModalBottomSheet<Transaction>(
              useSafeArea: true,
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7 ,
              ),
              context: context,
              builder: (context) {
                return AddTransactionSheet();
              }
            );

            if(newTransaction != null){
              setState(() {
                transactions.insert(0, newTransaction);
              });
            }
          },
          backgroundColor: Color(0xFF2F948D),
          child: Icon(Icons.add, color: Colors.white, size: 40.h,),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      //the top green container
                      ClipPath(
                        clipper: BottomCurveClipper(),
                        child: Container(
                          height: 300.h,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal:  20.w, vertical: 35.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF429690),
                                Color(0xFF058E84),
                              ]
                            )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h,),
                              Text(
                                'Good morning',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                      // a white space to show the budget card and leave a space between it and other elements
                      SizedBox(height: 70.h,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        child: Column(
                          children: [
                            //row of Recent transactions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recent Transactions",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),

                                TextButton(
                                  onPressed: (){
                                    widget.onNavigateToTab(1);
                                  },
                                  child: Text(
                                    "See all",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.sp
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 25.h,),

                            //recent transactions
                            if (transactions.isEmpty)
                              Text(
                                'No transaction at the moment',
                              )
                            else
                              ...transactions.map((transaction) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 15.h),
                                  child: TransactionCard(transaction: transaction),
                                );
                              }),
                          ],
                        ),
                      ),

                    ],
                  ),
                  Positioned(
                    top: 120.h,
                    left: 0.w,
                    right: 0.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: BudgetCard(),
                    ),
                  ),
                ],
              ),
            ),

            //status bar's background color
            Container(
              height: statusBarHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withAlpha(90),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
