class Hostel {
  final String name;
  final String address;
  final Contact contact;
  final String rent;
  final String emailAddress;
  final List<String> images;

  Hostel({
    required this.name,
    required this.address,
    required this.contact,
    required this.rent,
    required this.emailAddress,
    required this.images,
  });

  factory Hostel.fromJson(Map<String, dynamic> json) {
    return Hostel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      contact: Contact.fromJson({
        'phone': json['contactNo'] ?? '',
        'email': json['emailAddress'] ?? '',
      }),
      rent: json['rent'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}

class Contact {
  final String phone;
  final String email;

  Contact({
    required this.phone,
    required this.email,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
