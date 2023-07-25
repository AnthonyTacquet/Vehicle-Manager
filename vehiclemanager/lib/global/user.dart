class User {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const User(
    this.email,
    this.password,
    this.firstName,
    this.lastName,
  );

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      data['email'],
      data['password'],
      data['first_name'],
      data['last_name'],
    );
  }

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      parsedJson['email'],
      parsedJson['password'],
      parsedJson['first_name'],
      parsedJson['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName
    };
  }
}
