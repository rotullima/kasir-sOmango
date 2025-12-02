class CashierCustModel {
  final String? id;
  final String name;
  final String email;
  final int points; 

  CashierCustModel({
    this.id,
    required this.name,
    required this.email,
    required this.points,
  });

  int get rupiahFromPoints => points; 
}
