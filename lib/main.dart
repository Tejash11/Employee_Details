import 'package:employee_lists/providers/employee_provider.dart';
import 'package:employee_lists/screens/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/employee.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => EmployeeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Details',
      home: EmployeeListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}