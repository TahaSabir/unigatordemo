// // import 'dart:async';
// // import 'dart:convert';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';

// // class UniversityRecomended extends StatefulWidget {
// //   const UniversityRecomended({super.key});

// //   @override
// //   State<UniversityRecomended> createState() =>
// //       _UniversityRecomendedState();
// // }

// // class _UniversityRecomendedState
// //     extends State<UniversityRecomended> {
// //   List<dynamic> universities = [];
// //   List<dynamic> filteredUniversities = [];
// //   TextEditingController searchController = TextEditingController();
// //   List<String> selectedCampuses = [];
// //   List<String> selectedPrograms = [];
// //   String selectedSSC = "";
// //   String selectedHSC = "";

// //   bool isLoading = false;
// //   bool searchPerformed = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadJsonData();
// //   }

// //   Future<void> loadJsonData() async {
// //     final String response =
// //         await rootBundle.loadString('assets/university_data.json');
// //     final data = await json.decode(response);
// //     setState(() {
// //       universities = data;
// //       filteredUniversities = universities;
// //     });
// //   }

// //   void _startSearchProcess() {
// //     setState(() {
// //       isLoading = true;
// //     });

// //     Future.delayed(const Duration(seconds: 3), () {
// //       filterUniversities();
// //       setState(() {
// //         isLoading = false;
// //         searchPerformed = true;
// //       });
// //     });
// //   }

// //   void filterUniversities() {
// //     List<dynamic> tempUniversities = universities.where((university) {
// //       bool matchesSearch = university['universityName']
// //               ?.toLowerCase()
// //               ?.contains(searchController.text.toLowerCase()) ??
// //           false;

// //       bool matchesCampuses = selectedCampuses.isEmpty ||
// //           (university['campuses'] != null &&
// //               university['campuses']
// //                   .any((campus) => selectedCampuses.contains(campus)));

// //       bool matchesPrograms = selectedPrograms.isEmpty ||
// //           (university['programs'] != null &&
// //               university['programs']
// //                   .any((program) => selectedPrograms.contains(program)));

// //       bool matchesSSC = selectedSSC.isEmpty ||
// //           (university['minimumSSC'] != null &&
// //               university['minimumSSC'] == selectedSSC);

// //       bool matchesHSC = selectedHSC.isEmpty ||
// //           (university['minimumHSC'] != null &&
// //               university['minimumHSC'] == selectedHSC);

// //       return matchesSearch &&
// //           matchesCampuses &&
// //           matchesPrograms &&
// //           matchesSSC &&
// //           matchesHSC;
// //     }).toList();

// //     setState(() {
// //       filteredUniversities = tempUniversities;
// //     });
// //   }

// //   void resetFilters() {
// //     setState(() {
// //       selectedCampuses.clear();
// //       selectedPrograms.clear();
// //       selectedSSC = "";
// //       selectedHSC = "";
// //       searchController.clear();
// //       filteredUniversities = universities;
// //       searchPerformed = false;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: TextField(
// //           controller: searchController,
// //           decoration: const InputDecoration(
// //             hintText: 'Search Universities...',
// //             border: InputBorder.none,
// //           ),
// //           onChanged: (text) {},
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: const Icon(Icons.filter_list),
// //             onPressed: () {
// //               showDialog(
// //                 context: context,
// //                 builder: (BuildContext context) {
// //                   return _buildFilterDialog(context);
// //                 },
// //               );
// //             },
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.refresh),
// //             onPressed: resetFilters,
// //           ),
// //         ],
// //       ),
// //       body: isLoading ? _buildLoadingAnimation() : _buildUniversityList(),
// //     );
// //   }

// //   Widget _buildLoadingAnimation() {
// //     return const Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           CircularProgressIndicator(),
// //           SizedBox(height: 20),
// //           Text(
// //             'Applying Model...',
// //             style: TextStyle(fontSize: 18),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildUniversityList() {
// //     if (filteredUniversities.isEmpty && searchPerformed) {
// //       return const Center(
// //           child: Text('No universities match your search criteria.'));
// //     }

// //     return ListView.builder(
// //       itemCount: filteredUniversities.length,
// //       itemBuilder: (context, index) {
// //         var university = filteredUniversities[index];
// //         return Card(
// //           margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
// //           elevation: 6,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(15),
// //           ),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               ClipRRect(
// //                 borderRadius: const BorderRadius.only(
// //                   topLeft: Radius.circular(15),
// //                   topRight: Radius.circular(15),
// //                 ),
// //                 child: Image.asset(
// //                   university['images'][0],
// //                   height: 200,
// //                   width: double.infinity,
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.all(12),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       university['universityName'] ?? "",
// //                       style: const TextStyle(
// //                         fontSize: 20,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.black87,
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     Text(
// //                       'Programs: ${university['programs'].take(3).join(", ")}',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         color: Colors.grey[700],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       'Campuses: ${university['campuses'].join(", ")}',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         color: Colors.grey[700],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       'Minimum SSC: ${university['minimumSSC'] ?? "N/A"}',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         color: Colors.grey[700],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       'Minimum HSC: ${university['minimumHSC'] ?? "N/A"}',
// //                       style: TextStyle(
// //                         fontSize: 16,
// //                         color: Colors.grey[700],
// //                       ),
// //                     ),
// //                     const SizedBox(height: 8),
// //                     Row(
// //                       children: [
// //                         const Icon(
// //                           Icons.phone,
// //                           size: 16,
// //                           color: Colors.blueGrey,
// //                         ),
// //                         const SizedBox(width: 5),
// //                         Text(
// //                           university['contact']['phone'],
// //                           style: const TextStyle(fontSize: 15),
// //                         ),
// //                       ],
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Row(
// //                       children: [
// //                         const Icon(
// //                           Icons.language,
// //                           size: 16,
// //                           color: Colors.blueGrey,
// //                         ), // Website icon
// //                         const SizedBox(width: 5),
// //                         Text(
// //                           university['contact']['website'],
// //                           style:
// //                               const TextStyle(fontSize: 15, color: Colors.blue),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildFilterDialog(BuildContext context) {
// //     return AlertDialog(
// //       title: const Text('Filter Options'),
// //       content: SingleChildScrollView(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const Text('Select Campuses:'),
// //             Wrap(
// //               spacing: 5.0,
// //               children: _buildCheckboxes(
// //                   ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Foreign']),
// //             ),
// //             const SizedBox(height: 10),
// //             const Text('Select Programs:'),
// //             Wrap(
// //               spacing: 5.0,
// //               children: _buildCheckboxes([
// //                 'MBBS',
// //                 'BScN',
// //                 'BEd',
// //                 'BBA',
// //                 'BS Computer Science',
// //                 'BS Data Science'
// //               ]),
// //             ),
// //             const SizedBox(height: 10),
// //             const Text('Select SSC Percentage:'),
// //             DropdownButton<String>(
// //               value: selectedSSC.isEmpty ? null : selectedSSC,
// //               hint: const Text('Choose SSC %'),
// //               onChanged: (String? value) {
// //                 setState(() {
// //                   selectedSSC = value!;
// //                 });
// //               },
// //               items: ['30%', '50%', '60%'].map((String value) {
// //                 return DropdownMenuItem<String>(
// //                   value: value,
// //                   child: Text(value),
// //                 );
// //               }).toList(),
// //             ),
// //             const SizedBox(height: 10),
// //             const Text('Select HSC Percentage:'),
// //             DropdownButton<String>(
// //               value: selectedHSC.isEmpty ? null : selectedHSC,
// //               hint: const Text('Choose HSC %'),
// //               onChanged: (String? value) {
// //                 setState(() {
// //                   selectedHSC = value!;
// //                 });
// //               },
// //               items: ['30%', '50%', '60%', '65%'].map((String value) {
// //                 return DropdownMenuItem<String>(
// //                   value: value,
// //                   child: Text(value),
// //                 );
// //               }).toList(),
// //             ),
// //           ],
// //         ),
// //       ),
// //       actions: [
// //         TextButton(
// //           child: const Text('Apply'),
// //           onPressed: () {
// //             Navigator.of(context).pop();
// //             _startSearchProcess();
// //           },
// //         ),
// //       ],
// //     );
// //   }

// //   List<Widget> _buildCheckboxes(List<String> options) {
// //     return options.map((option) {
// //       return FilterChip(
// //         label: Text(option),
// //         selected: selectedCampuses.contains(option) ||
// //             selectedPrograms.contains(option),
// //         onSelected: (bool selected) {
// //           setState(() {
// //             if (options.contains(option)) {
// //               if (selected) {
// //                 selectedCampuses.add(option);
// //               } else {
// //                 selectedCampuses.remove(option);
// //               }
// //             } else {
// //               if (selected) {
// //                 selectedPrograms.add(option);
// //               } else {
// //                 selectedPrograms.remove(option);
// //               }
// //             }
// //           });
// //         },
// //       );
// //     }).toList();
// //   }
// // }

// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:uni_gator/widgets/custom_button.dart';
// import 'package:uni_gator/widgets/university_card.dart';

// import '/model/university_model.dart';

// class UniversityRecommendation extends StatefulWidget {
//   const UniversityRecommendation({Key? key}) : super(key: key);

//   @override
//   _UniversityRecommendationState createState() =>
//       _UniversityRecommendationState();
// }

// class _UniversityRecommendationState extends State<UniversityRecommendation> {
//   List<University> universities = [];
//   List<University> filteredUniversities = [];
//   String? selectedCity;
//   String? selectedProgram;
//   String? selectedFees;
//   String? selectedSSC;
//   String? selectedHSC;
//   bool isLoading = false;

//   final List<String> cityOptions = [
//     'Karachi',
//     'Lahore',
//     'Islamabad',
//     'Faisalabad'
//   ];
//   final List<String> programOptions = [
//     'MBBS',
//     'BBA',
//     'BS Computer Science',
//     'BS Engineering'
//   ];
//   final List<String> feeRangeOptions = [
//     '50,000 - 100,000',
//     '100,000 - 200,00',
//     '350,000 - 10,00,000'
//   ];
//   final List<String> percentageOptions = ['50%', '60%', '70%', '80%'];

//   @override
//   void initState() {
//     super.initState();
//     loadJsonData();
//   }

//   Future<void> loadJsonData() async {
//     final String response =
//         await rootBundle.loadString('assets/university_data.json');
//     final data = await json.decode(response);
//     setState(() {
//       universities =
//           (data as List).map((item) => University.fromJson(item)).toList();
//     });
//   }

//   void _showRecommendationDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//           return AlertDialog(
//             title: Text('Recommend a University'),
//             content: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildDropdown('City', selectedCity, cityOptions, (newValue) {
//                     setState(() => selectedCity = newValue);
//                   }),
//                   _buildDropdown('Program', selectedProgram, programOptions,
//                       (newValue) {
//                     setState(() => selectedProgram = newValue);
//                   }),
//                   _buildDropdown('Fee Range', selectedFees, feeRangeOptions,
//                       (newValue) {
//                     setState(() => selectedFees = newValue);
//                   }),
//                   _buildDropdown(
//                       'SSC Percentage', selectedSSC, percentageOptions,
//                       (newValue) {
//                     setState(() => selectedSSC = newValue);
//                   }),
//                   _buildDropdown(
//                       'HSC Percentage', selectedHSC, percentageOptions,
//                       (newValue) {
//                     setState(() => selectedHSC = newValue);
//                   }),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 child: Text('Submit'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _getRecommendations();
//                 },
//               ),
//             ],
//           );
//         });
//       },
//     );
//   }

//   Widget _buildDropdown(String label, String? selectedValue, List<String> items,
//       Function(String?) onChanged) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(labelText: label),
//       value: selectedValue,
//       onChanged: onChanged,
//       items: items.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }

//   void _getRecommendations() {
//     setState(() {
//       isLoading = true;
//     });

//     // Simulate API call
//     Future.delayed(const Duration(seconds: 2), () {
//       filteredUniversities = universities.where((university) {
//         return (selectedCity == null ||
//                 university.campuses.contains(selectedCity)) &&
//             (selectedProgram == null ||
//                 university.programs.contains(selectedProgram)) &&
//             (selectedFees == null ||
//                 _isInFeeRange(university.feeStructure, selectedFees!)) &&
//             (selectedSSC == null ||
//                 _meetsPercentageCriteria(
//                     university.minimumSSC, selectedSSC!)) &&
//             (selectedHSC == null ||
//                 _meetsPercentageCriteria(university.minimumHSC, selectedHSC!));
//       }).toList();

//       filteredUniversities.sort((a, b) => a.rank.compareTo(b.rank));

//       // Ensure at least 3 universities are shown
//       if (filteredUniversities.length < 3) {
//         var remainingUniversities = universities
//             .where((university) => !filteredUniversities.contains(university))
//             .toList();
//         remainingUniversities.sort((a, b) => a.rank.compareTo(b.rank));
//         filteredUniversities.addAll(
//             remainingUniversities.take(3 - filteredUniversities.length));
//       }

//       filteredUniversities = filteredUniversities.take(3).toList();

//       setState(() {
//         isLoading = false;
//       });
//     });
//   }

//   bool _isInFeeRange(String universityFee, String selectedRange) {
//     int fee = int.parse(universityFee);
//     List<int> range = selectedRange
//         .split(' - ')
//         .map((e) => int.parse(e.replaceAll(',', '')))
//         .toList();
//     return fee >= range[0] && fee <= range[1];
//   }

//   bool _meetsPercentageCriteria(
//       String? universityPercentage, String selectedPercentage) {
//     if (universityPercentage == null) return true;
//     return int.parse(universityPercentage.replaceAll('%', '')) <=
//         int.parse(selectedPercentage.replaceAll('%', ''));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const Text(
//                   'Recommend me a university',
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 CustomButton(
//                   width: 180,
//                   text: 'Get Recommendations',
//                   onPressed: _showRecommendationDialog,
//                 ),
//                 const SizedBox(height: 20),
//                 if (isLoading)
//                   const CircularProgressIndicator()
//                 else if (filteredUniversities.isNotEmpty)
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: filteredUniversities.length,
//                       itemBuilder: (context, index) {
//                         return UniversityCard(
//                             university: filteredUniversities[index]);
//                       },
//                     ),
//                   )
//                 else if (selectedCity != null ||
//                     selectedProgram != null ||
//                     selectedFees != null ||
//                     selectedSSC != null ||
//                     selectedHSC != null)
//                   _buildNoResultsMessage()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNoResultsMessage() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.school_outlined, size: 80, color: Colors.grey[400]),
//         const SizedBox(height: 20),
//         Text(
//           'Oops! We couldn\'t find a perfect match.',
//           style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[700]),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 10),
//         Text(
//           'But don\'t worry, your dream university is out there!',
//           style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 20),
//         CustomButton(
//           width: 200,
//           text: 'Try Different Criteria',
//           onPressed: _showRecommendationDialog,
//         ),
//         const SizedBox(height: 10),
//         TextButton(
//           onPressed: () {
//             // Reset all filters
//             setState(() {
//               selectedCity = null;
//               selectedProgram = null;
//               selectedFees = null;
//               selectedSSC = null;
//               selectedHSC = null;
//               filteredUniversities = [];
//             });
//           },
//           child: Text('Clear All Filters',
//               style: TextStyle(color: Colors.blue[700])),
//         ),
//       ],
//     );
//   }
// }
