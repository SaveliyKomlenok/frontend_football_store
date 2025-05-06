class UserResponse {
  final int id;
  final String username;
  final String firstname;
  final String lastname;
  final DateTime dateOfCreation;

  UserResponse({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.dateOfCreation,
  });

  factory UserResponse.fromMap(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      username: json['username'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      dateOfCreation: DateTime.parse(json['dateOfCreation']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'firstname': firstname,
      'lastname': lastname,
      'dateOfCreation': dateOfCreation.toIso8601String(),
    };
  }
}