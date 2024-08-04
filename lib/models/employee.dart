class Employee {
  final String id;
  final String name;
  final String address;
  final int contact;
  final String email;

  Employee({required this.id, required this.name, required this.address, required this.contact, required this.email});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      contact: json['contact'],
      email: json['email'],
    );
  }
}