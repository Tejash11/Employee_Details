import 'package:employee_lists/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/employee.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final String id;

  EmployeeDetailScreen({required this.id}) {
    // Debug statement to check received employee.id
    print('Received Employee ID: $id');
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                await employeeProvider.deleteEmployee(id);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Employee deleted successfully'),
                ));
                Navigator.pop(context, true); // Indicate successful deletion
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Failed to delete employee: $e'),
                ));
              }
            },
          ),
        ],
      ),

      body: FutureBuilder(
        future: employeeProvider.fetchEmployeeById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final employee = snapshot.data! as Employee;
            print(
                'Fetched Employee: ${employee.id}, ${employee.name}, ${employee.address}, ${employee.contact}, ${employee.email}');
            return each_employee(context, employee);
          }
        },
      ),
    );
  }

  Widget each_employee(BuildContext context, Employee employee) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Id: ${employee.id}', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('Name: ${employee.name}', style: TextStyle(fontSize: 14)),
          SizedBox(
            height: 8,
          ),
          Text('Address: ${employee.address}', style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          Text('Contact: ${employee.contact}', style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          Text('Email: ${employee.email}', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}