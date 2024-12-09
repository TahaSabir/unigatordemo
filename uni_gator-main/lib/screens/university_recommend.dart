import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UniversityRecommendation extends StatefulWidget {
  const UniversityRecommendation({Key? key}) : super(key: key);

  @override
  _UniversityRecommendationState createState() => _UniversityRecommendationState();
}

class _UniversityRecommendationState extends State<UniversityRecommendation> {
  String? selectedField;
  String? selectedFeeRange;
  String? selectedCity;
  String? selectedSSC;
  String? selectedHSC;

  List<dynamic> universities = [];
  List<dynamic> filteredUniversities = [];

  final List<String> fields = ["Computer Science", "Medical", "Business", "Engineering"];
  final List<String> feeRanges = ["PKR 100,000 - 200,000", "PKR 200,000 - 400,000", "PKR 400,000 - 600,000"];
  final List<String> percentages = ["50%", "60%", "70%", "80%"];
  final List<String> cities = ["Karachi", "Lahore", "Islamabad", "Faisalabad", "Jamshoro"];

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadUniversities(String field) async {
    String fileName = '';
    if (field == "Computer Science") fileName = "assets/Computer Science.json";
    if (field == "Medical") fileName = "assets/Medical.json";
    if (field == "Business") fileName = "assets/Business.json";
    if (field == "Engineering") fileName = "assets/Engineering.json";

    final String response = await rootBundle.loadString(fileName);
    setState(() {
      universities = json.decode(response);
    });
  }

  void filterUniversities() {
    setState(() {
      // Filter based on all conditions
      filteredUniversities = universities.where((university) {
        bool feeMatch = _isInFeeRange(university['Fee Structure'], selectedFeeRange);
        bool sscMatch = _meetsPercentageCriteria(university['Minimum SSC'], selectedSSC);
        bool hscMatch = _meetsPercentageCriteria(university['Minimum HSC'], selectedHSC);
        bool cityMatch = selectedCity == null || university['Location'] == selectedCity;

        // Return only if all filters are satisfied
        return feeMatch && sscMatch && hscMatch && cityMatch;
      }).toList();

      // Sort filtered universities by rank first, then by fee
      filteredUniversities.sort((a, b) {
        int rankComparison = (a['Rank'] as int).compareTo(b['Rank'] as int);
        if (rankComparison != 0) return rankComparison;

        // If ranks are equal, prefer the university with lower fees
        return _extractFee(a['Fee Structure']).compareTo(_extractFee(b['Fee Structure']));
      });

      // Limit results to the top 3 universities
      filteredUniversities = filteredUniversities.take(3).toList();
    });
  }

  bool _isInFeeRange(String? universityFee, String? selectedRange) {
    if (selectedRange == null || universityFee == null) return false;

    try {
      int maxFee = int.parse(universityFee.split('-')[1].replaceAll(RegExp(r'[^\d]'), ''));
      int selectedMaxFee = int.parse(selectedRange.split('-')[1].replaceAll(RegExp(r'[^\d]'), ''));

      return maxFee <= selectedMaxFee; // Maximum fee must be within range
    } catch (e) {
      print('Error parsing fee range: $e');
      return false;
    }
  }

  bool _meetsPercentageCriteria(String? universityPercentage, String? selectedPercentage) {
    if (selectedPercentage == null || universityPercentage == null) return true;

    try {
      int universityValue = int.parse(universityPercentage.replaceAll('%', ''));
      int selectedValue = int.parse(selectedPercentage.replaceAll('%', ''));

      return universityValue <= selectedValue; // University percentage should be <= selected percentage
    } catch (e) {
      print('Error parsing percentage criteria: $e');
      return false;
    }
  }

  int _extractFee(String feeRange) {
    return int.parse(feeRange.split('-')[0].replaceAll(RegExp(r'[^\d]'), ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("University Recommendation")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: "Select Field"),
              items: fields.map((field) {
                return DropdownMenuItem(value: field, child: Text(field));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedField = value as String?;
                  loadUniversities(selectedField!);
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: "Select Fee Range"),
              items: feeRanges.map((range) {
                return DropdownMenuItem(value: range, child: Text(range));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFeeRange = value as String?;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: "Select SSC Percentage"),
              items: percentages.map((percentage) {
                return DropdownMenuItem(value: percentage, child: Text(percentage));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSSC = value as String?;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: "Select HSC Percentage"),
              items: percentages.map((percentage) {
                return DropdownMenuItem(value: percentage, child: Text(percentage));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedHSC = value as String?;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: "Select City (Optional)"),
              items: cities.map((city) {
                return DropdownMenuItem(value: city, child: Text(city));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value as String?;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: filterUniversities,
              child: const Text("Get Recommendations"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredUniversities.isEmpty
                  ? const Center(child: Text("No recommendations found"))
                  : ListView.builder(
                      itemCount: filteredUniversities.length,
                      itemBuilder: (context, index) {
                        final university = filteredUniversities[index];
                        return UniversityCard(university: university);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class UniversityCard extends StatelessWidget {
  final dynamic university;

  const UniversityCard({Key? key, required this.university}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(university['University'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Rank: ${university['Rank']}"),
        trailing: Text(
          university['Fee Structure'] ?? "Fee info not available",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
