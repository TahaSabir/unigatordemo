// File: lib/model/university_model.dart

class University {
  final int rank;
  final String name;
  final List<String> programs; // List of programs
  final String campus; // Single campus, taken from 'Location'
  final List<String> images;
  final Contact contact;
  final String feeStructure;
  final String minimumSSC;
  final String minimumHSC;
  int score = 0; // New field for scoring

  University({
    required this.rank,
    required this.name,
    required this.programs,
    required this.campus,
    required this.images,
    required this.contact,
    required this.feeStructure,
    required this.minimumSSC,
    required this.minimumHSC,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      rank: json['Rank'] ?? 0,
      name: json['University'] ?? '',
      programs: _normalizeList(json['Specialization'] ?? json['programs']),
      campus: json['Location'] ?? '',
      images: _normalizeList(json['images']),
      contact: Contact.fromJson(json['contact'] ?? {}),
      feeStructure: json['Fee Range']?.toString() ?? '',
      minimumSSC: json['Minimum SSC']?.toString() ?? '',
      minimumHSC: json['Minimum HSC']?.toString() ?? '',
    );
  }

  static List<String> _normalizeList(dynamic value) {
    if (value == null) {
      return [];
    } else if (value is String) {
      return [value]; // Convert string to list of one item
    } else if (value is List) {
      return List<String>.from(value); // Already a list, return it
    } else {
      return [];
    }
  }
}

class Contact {
  final String phone;
  final String email;
  final String website;

  Contact({
    required this.phone,
    required this.email,
    required this.website,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
    );
  }
}
