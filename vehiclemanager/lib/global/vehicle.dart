class Vehicle {
  final String name;
  final String plate;
  final int seats;

  const Vehicle(
    this.name,
    this.plate,
    this.seats,
  );

  factory Vehicle.fromMap(Map<String, dynamic> data) {
    return Vehicle(
      data['name'],
      data['plate'],
      data['seats'],
    );
  }
}
