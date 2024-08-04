class Employee {
  String? id;
  String? name;
  String? address;
  int? contact;
  String? email;

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