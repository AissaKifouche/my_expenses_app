import 'package:flutter/material.dart';
import 'package:my_expenses/main_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Expenses',
      home: MainShell(),
    );
  }
}

