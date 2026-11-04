import 'package:flutter/material.dart';
import 'package:my_expenses/main_shell.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'database/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //create one database instance
  final database = AppDatabase();



  runApp(
    Provider<AppDatabase>(
      create: (_) => database,
      dispose: (_, db) => db.close(),
      child: MyApp(),
    ),
  );
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

