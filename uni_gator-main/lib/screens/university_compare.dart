// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:uni_gator/model/university_compare_model.dart';
// import 'package:uni_gator/utils/app_colors.dart';
// import 'package:uni_gator/widgets/university_card.dart';

// class UniversityComparisonScreen extends StatefulWidget {
//   @override
//   _UniversityComparisonScreenState createState() =>
//       _UniversityComparisonScreenState();
// }

// class _UniversityComparisonScreenState
//     extends State<UniversityComparisonScreen> {
//   List<University> universities = [];
//   List<University> filteredUniversities = [];
//   List<University?> selectedUniversities = [null, null];
//   TextEditingController searchController = TextEditingController();
//   bool isSearching = false;

//   @override
//   void initState() {
//     super.initState();
//     loadUniversities();
//   }

//   Future<void> loadUniversities() async {
//     final String response =
//         await rootBundle.loadString('assets/university_data.json');
//     final data = await json.decode(response);
//     setState(() {
//       universities =
//           List<University>.from(data.map((json) => University.fromJson(json)));
//     });
//   }

//   void filterUniversities(String query) {
//     setState(() {
//       isSearching = query.isNotEmpty;
//       filteredUniversities = universities
//           .where((university) =>
//               university.name.toLowerCase().contains(query.toLowerCase()) ||
//               university.programs.any((program) =>
//                   program.toLowerCase().contains(query.toLowerCase())))
//           .toList();
//     });
//   }

//   void selectUniversity(University university) {
//     setState(() {
//       if (selectedUniversities[0] == null) {
//         selectedUniversities[0] = university;
//       } else if (selectedUniversities[1] == null) {
//         selectedUniversities[1] = university;
//       } else {
//         selectedUniversities[0] = university;
//       }
//       searchController.clear();
//       isSearching = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('University Comparison',
//             style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: searchController,
//                 decoration: const InputDecoration(
//                   labelText: 'Search Universities',
//                   labelStyle: TextStyle(color: AppColors.primary),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     borderSide: BorderSide(color: AppColors.primary),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     borderSide: BorderSide(color: AppColors.primary),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     borderSide: BorderSide(color: AppColors.primary, width: 2),
//                   ),
//                   prefixIcon: Icon(Icons.search, color: AppColors.primary),
//                 ),
//                 onChanged: filterUniversities,
//               ),
//               const SizedBox(height: 16),
//               if (isSearching)
//                 Container(
//                   height: 200,
//                   child: ListView.builder(
//                     itemCount: filteredUniversities.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(filteredUniversities[index].name),
//                         subtitle:
//                             Text('Rank: ${filteredUniversities[index].rank}'),
//                         onTap: () =>
//                             selectUniversity(filteredUniversities[index]),
//                       );
//                     },
//                   ),
//                 ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildSelectedUniversityIndicator(0),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: _buildSelectedUniversityIndicator(1),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               if (selectedUniversities[0] != null &&
//                   selectedUniversities[1] != null)
//                 _buildComparisonView(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSelectedUniversityIndicator(int index) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: AppColors.primary),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         selectedUniversities[index]?.name ?? 'Select University ${index + 1}',
//         style: TextStyle(fontWeight: FontWeight.bold),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   Widget _buildComparisonView() {
//     return Column(
//       children: [
//         for (int i = 0; i < 2; i++)
//           if (selectedUniversities[i] != null)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16),
//               child: UniversityCard(university: selectedUniversities[i]),
//             ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_gator/model/university_model.dart'; // Use the unified model
import 'package:uni_gator/utils/app_colors.dart';
import 'package:uni_gator/widgets/university_card.dart';

class UniversityComparisonScreen extends StatefulWidget {
  const UniversityComparisonScreen({super.key});

  @override
  _UniversityComparisonScreenState createState() =>
      _UniversityComparisonScreenState();
}

class _UniversityComparisonScreenState
    extends State<UniversityComparisonScreen> {
  List<University> universities = [];
  List<University> filteredUniversities = [];
  List<University?> selectedUniversities = [null, null];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    loadUniversities();
  }

  Future<void> loadUniversities() async {
    final String response =
        await rootBundle.loadString('assets/university_data.json');
    final data = await json.decode(response);
    setState(() {
      universities =
          List<University>.from(data.map((json) => University.fromJson(json)));
    });
  }

  void filterUniversities(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      filteredUniversities = universities
          .where((university) =>
              university.name.toLowerCase().contains(query.toLowerCase()) ||
              university.programs.any((program) =>
                  program.toLowerCase().contains(query.toLowerCase())))
          .toList();
    });
  }

  void selectUniversity(University university) {
    setState(() {
      if (selectedUniversities[0] == null) {
        selectedUniversities[0] = university;
      } else if (selectedUniversities[1] == null) {
        selectedUniversities[1] = university;
      } else {
        selectedUniversities[0] = university;
      }
      searchController.clear();
      isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' University Comparison',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search Universities',
                  labelStyle: TextStyle(color: AppColors.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                ),
                onChanged: filterUniversities,
              ),
              const SizedBox(height: 16),
              if (isSearching)
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: filteredUniversities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredUniversities[index].name),
                        subtitle:
                            Text('Rank: ${filteredUniversities[index].rank}'),
                        onTap: () =>
                            selectUniversity(filteredUniversities[index]),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectedUniversityIndicator(0),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSelectedUniversityIndicator(1),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (selectedUniversities[0] != null &&
                  selectedUniversities[1] != null)
                _buildComparisonView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedUniversityIndicator(int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        selectedUniversities[index]?.name ?? 'Select University ${index + 1}',
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildComparisonView() {
    return Column(
      children: [
        for (int i = 0; i < 2; i++)
          if (selectedUniversities[i] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: UniversityCard(university: selectedUniversities[i]!),
            ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
