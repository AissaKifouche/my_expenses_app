import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_expenses/widgets/currency.dart';

import '../buttom_clipper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Currency _selectedCurrency = currencies[0];
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light
      ),
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Color(0xFF219289),
          title: Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
            ),
          ),
        ),
        //backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [

                SizedBox(height: 30.h,),

                //no dark mode implementation for now
                /*Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.h),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: BoxBorder.all(color: Colors.grey)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Dark Mode",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp
                            ),
                          ),

                          Switch(
                            value: darkMode,
                            onChanged: (dark){
                              setState(() {
                                darkMode = dark;
                              });
                            },
                            activeThumbColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                ),*/

                SizedBox(height: 15.h,),

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 20.h),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: BoxBorder.all(color: Colors.grey)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Currency",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp
                          ),
                        ),

                        CurrencyContainerPicker(
                            selectedCurrency: _selectedCurrency,
                            onCurrencySelected: (currency) {
                              setState(() {
                                _selectedCurrency = currency;
                              });
                            }
                        ),

                      ],
                    ),
                  ),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}
