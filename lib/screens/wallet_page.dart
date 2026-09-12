import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';
import 'package:my_expenses/models/wallet.dart';
import 'package:my_expenses/widgets/goal_card.dart';

class WalletPage extends StatefulWidget {
  final AppData appData;
  const WalletPage({super.key, required this.appData});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF219289),
        title: Text(
          "Wallet",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 45.h),
          child: Column(
            children: [

              //the wallet card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: widget.appData.wallet.balance >= 0 ? Color(0xFF296D68) : Colors.red,
                  borderRadius: BorderRadius.circular(20.r)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.appData.wallet.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.sp,
                      ),
                    ),

                    SizedBox(height: 30.h,),

                    Text(
                      "\$ ${widget.appData.wallet.balance}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34.sp,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 60.h,),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Goals',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.sp,
                  ),
                ),
              ),

              SizedBox(height: 30.h,),

              GoalCard(),
            ],
          ),
        ),
      ),
    );
  }
}
