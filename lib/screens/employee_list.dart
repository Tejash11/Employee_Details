import 'package:employee_lists/providers/employee_provider.dart';
import 'package:employee_lists/screens/add_employee.dart';
import 'package:employee_lists/screens/employee_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/employee.dart';

class EmployeeListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Employees List')),
      body: FutureBuilder<List<Employee>>(
          future: employeeProvider.fetchEmployees(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No employees found'));
            } else {
              final list = snapshot.data!;
              return finallist(context, list);
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEmployeeScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget finallist(BuildContext context, List<Employee> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final employee = list[index];
        return ListTile(
          title: Text(employee.name!),
          subtitle: Text(employee.id!),
          trailing: Text(employee.address!),
          onTap: () {
            // Debuging statement to check employee.id
            print('Navigating to details of Employee ID: ${employee.id}');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeDetailScreen(id: employee.id),
              ),
            );
          },
        );
      },
    );
  }
}