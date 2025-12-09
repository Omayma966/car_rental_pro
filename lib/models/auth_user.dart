class AuthUser {
  final String id;
  final String email;
  final String prenom;
  final String nom;
  final String role;

  AuthUser({
    required this.id,
    required this.email,
    required this.prenom,
    required this.nom,
    required this.role,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      prenom: json['prenom'] as String? ?? '',
      nom: json['nom'] as String? ?? '',
      role: json['role'] as String? ?? 'agent',
    );
  }
}
