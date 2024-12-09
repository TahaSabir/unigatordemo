class Users {
  String name;
  String email;
  double? sscPercent;
  double? hscPercent;
  double? cgpa;
  List<String> interests;

  Users({
    required this.name,
    required this.email,
    this.sscPercent,
    this.hscPercent,
    this.cgpa,
    required this.interests,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      sscPercent: _parseDouble(json['sscPercent']),
      hscPercent: _parseDouble(json['hscPercent']),
      cgpa: _parseDouble(json['cgpa']),
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'sscPercent': sscPercent,
      'hscPercent': hscPercent,
      'cgpa': cgpa,
      'interests': interests,
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        print('Error parsing double value: $value');
        return null;
      }
    }
    return null;
  }
}
