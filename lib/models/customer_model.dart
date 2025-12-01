class CustomerModel {
  final String id;
  final String name;
  final String email;
  final int points; 

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.points,
  });

  int get rupiahFromPoints => points; 
}
