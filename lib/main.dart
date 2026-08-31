import 'package:flutter/material.dart';
import 'package:my_expenses/main_shell.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 917),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'My Expenses',
        home: MainShell(),
      ),
    );
  }
}

