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
}