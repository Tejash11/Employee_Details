class Employee {
  // final String id;
  // final String name;
  // final String address;
  // final int contact;
  // final String email;

  String? id;
  String? name;
  String? address;
  int? contact;
  String? email;

  Employee({
     this.id,
     this.name,
     this.address,
     this.contact,
     this.email,
  });

  Employee.fromJson(Map<String, dynamic> json) {

      id: json['id'];
      name: json['name'];
      address: json['address'];
      contact: json['contact'];
      email: json['email'];
  }
}
