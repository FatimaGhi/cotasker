class Users {
  String? id;
  String firstName;
  String lastName;
  String N_tel;
  String email;
  String password;
  String type;

  Users({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.N_tel,
    required this.email,
    required this.password,
    required this.type,
  });

  // Convert a User object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'N_tel': N_tel,
      'email': email,
      'password': password,
      'type': type,
    };
  }

  // Create a User object from a Map object
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      N_tel: map['N_tel'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      type: map['type'] ?? '',
    );
  }
}
