class UserModel {
  final int id;
  final String name;
  final String role;
  final String imagePath; 
  
  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.imagePath,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? role,
    String? imagePath,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
