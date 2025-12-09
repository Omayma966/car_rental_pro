class Agent {
  final String id;         // id de la table agents
  final String profileId;  // id dans profiles (optionnel pour plus tard)
  final String fullName;
  final String email;
  final String? phone;
  final bool active;

  Agent({
    required this.id,
    required this.profileId,
    required this.fullName,
    required this.email,
    this.phone,
    required this.active,
  });

  factory Agent.fromMap(Map<String, dynamic> map) {
    return Agent(
      id: map['id'] as String,
      profileId: map['profile_id'] as String,
      fullName: map['full_name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String?,
      active: map['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profile_id': profileId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'active': active,
    };
  }
}
