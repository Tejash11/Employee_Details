import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/employee.dart';

class EmployeeProvider with ChangeNotifier {
  final baseUrl =
      'https://free-ap-south-1.cosmocloud.io/development/api/employee_info';

  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(
      Uri.parse('$baseUrl?limit=200&offset=0'),
      headers: {
        'Content-Type': 'application/json',
        'projectId': '66aa089339e2fdc09bbba300',
        // Ensure you add the correct headers
        'environmentId': '66aa089339e2fdc09bbba301',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> employeesJson = data['data'];
      return employeesJson.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<Employee> fetchEmployeeById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl$id'));
    if (response.statusCode == 200) {
      return Employee.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load employee');
    }
  }

  Future<void> createEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {
        'Content-Type': 'application/json',
        'projectId': '66aa089339e2fdc09bbba300',
        'environmentId': '66aa089339e2fdc09bbba301',
      },
      body: json.encode({
        'name': employee.name,
        'address': employee.address,
        'contact': employee.contact,
        'email': employee.email,
      }),
    );

    if (response.statusCode == 201) {
      // Employee created successfully
      fetchEmployees(); // Refresh the list of employees
    } else {
      throw Exception('Failed to create employee');
    }
  }
}
