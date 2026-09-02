import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_expenses/widgets/day_stats.dart';
import 'package:my_expenses/widgets/month_stats.dart';
import 'package:my_expenses/widgets/week_stats.dart';
import 'package:my_expenses/widgets/year_stats.dart';


enum TimeFilter {day, week, month, year}


class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

  TimeFilter selectedFilter = TimeFilter.day;

  Widget _buildFilteredLayout(){
    switch(selectedFilter){
      case TimeFilter.day :
        return DayStats();
      case TimeFilter.week:
        return WeekStats();
      case TimeFilter.month:
        return MonthStats();
      case TimeFilter.year:
        return YearStats();
    }
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: TimeFilter.values.map((filter) {
                  final isSelected = selectedFilter == filter;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w), // Spacing between buttons
                      child: InkWell(
                        onTap: () => setState(() => selectedFilter = filter),
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isSelected ?  Color(0xFF438883) :  Colors.transparent, // Active vs Inactive card color
                            borderRadius: BorderRadius.circular(12.r), // Individual rounded box
                          ),
                          child: Text(
                            filter.name.capitalize(), // Displays Day, Week, Month, Year
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade600,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,

                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 30.h,),

              _buildFilteredLayout(),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}