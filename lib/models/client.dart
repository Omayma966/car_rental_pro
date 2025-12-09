class Client {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String type;
  final String segment;
  final String? address;
  final String? cin;

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.type,
    required this.segment,
    this.address,
    this.cin,
  });

  String get fullName => '$firstName $lastName';

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      type: map['type'] as String,
      segment: map['segment'] as String,
      address: map['address'] as String?,
      cin: map['cin'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'type': type,
      'segment': segment,
      'address': address,
      'cin': cin,
    };
  }
}
