import 'package:flutter/material.dart';
import '../model/university_model.dart';

class UniversityCard extends StatelessWidget {
  final University university;

  const UniversityCard({Key? key, required this.university}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Rank and Name
            Text(
              '${university.rank}. ${university.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Display Fee Range
            Text(
              'Fee Range: ${university.feeStructure}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            
            // Display Contact Information
            Text(
              'Phone: ${university.contact.phone}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Email: ${university.contact.email}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Website: ${university.contact.website}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
