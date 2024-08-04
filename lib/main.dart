import 'package:employee_lists/providers/employee_provider.dart';
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

//class to fetch and show the list of employees on the screen
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

//class to fetch and show the employee details on the screen
class EmployeeDetailScreen extends StatelessWidget {
  final String id;

  EmployeeDetailScreen({required this.id}){
    // Debug statement to check received employee.id
    print('Received Employee ID: $id');
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Employee Details')),
      body: FutureBuilder(
        future: employeeProvider.fetchEmployeeById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final employee = snapshot.data! as Employee;
            print('Fetched Employee: ${employee.id}, ${employee.name}, ${employee.address}, ${employee.contact}, ${employee.email}');
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
          Text('Name: ${employee.name}',
              style: TextStyle(fontSize: 14)),
          SizedBox(
            height: 8,
          ),
          Text('Address: ${employee.address}',
              style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          Text('Contact: ${employee.contact}',
              style: TextStyle(fontSize: 14)),
          SizedBox(height: 8),
          Text('Email: ${employee.email}',
              style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

//class to AddEmployeeDetails by user
class AddEmployeeScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Add Employee')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newEmployee = Employee(
                        id: '',
                        // ID will be generated by the server
                        name: _nameController.text,
                        address: _positionController.text,
                        contact: int.parse(_contactController.text),
                        email: _emailController.text);
                    employeeProvider.createEmployee(newEmployee);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
