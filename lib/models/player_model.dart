
class Player {
  String? id;
  final String name;
  final String? photoUrl; // Keeping for backward compatibility if needed
  final String? imageBase64; // New field for Base64 image
  final String phone;
  final String email;
  final String? battingHand;
  final String? bowlingHand;
  final String? role; // New field for Player Role
  final DateTime? dob;

  Player({
    this.id,
    required this.name,
    this.photoUrl,
    this.imageBase64,
    required this.phone,
    required this.email,
    this.battingHand,
    this.bowlingHand,
    this.role,
    this.dob,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoUrl': photoUrl,
      'imageBase64': imageBase64,
      'phone': phone,
      'email': email,
      'battingHand': battingHand,
      'bowlingHand': bowlingHand,
      'role': role,
      'dob': dob?.toIso8601String(),
    };
  }

  factory Player.fromMap(Map<String, dynamic> map, String id) {
    return Player(
      id: id,
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      imageBase64: map['imageBase64'],
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      battingHand: map['battingHand'],
      bowlingHand: map['bowlingHand'],
      role: map['role'],
      dob: map['dob'] != null ? DateTime.tryParse(map['dob']) : null,
    );
  }
}
