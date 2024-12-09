// File: lib/model/university_model.dart

class University {
  final int rank;
  final String name;
  final List<String> campuses;
  final List<String> programs;
  final int? minMarksSsc;
  final int minMarksHsc;
  final List<String> images;
  final String? feeStructure;  // Added from university_compare_model.dart

  University({
    required this.rank,
    required this.name,
    required this.campuses,
    required this.programs,
    this.minMarksSsc,
    required this.minMarksHsc,
    required this.images,
    this.feeStructure,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      rank: json['rank'] ?? 0,
      name: json['name'] ?? '',
      campuses: List<String>.from(json['campuses'] ?? []),
      programs: List<String>.from(json['programs'] ?? []),
      minMarksSsc: json['minMarksSsc'],
      minMarksHsc: json['minMarksHsc'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      feeStructure: json['feeStructure'],
    );
  }
}

