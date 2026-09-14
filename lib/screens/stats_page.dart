import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/data/app_data.dart';

import 'package:flutter_utils/flutter_utils.dart';


enum TimeFilter {day, week, month, year}


class StatsPage extends StatefulWidget {
  final AppData appData;
  const StatsPage({super.key, required this.appData});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  TimeFilter selectedFilter = TimeFilter.day;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF219289),
        title: Text(
          "Statistics",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}

