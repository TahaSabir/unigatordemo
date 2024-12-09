// File: lib/screens/university_list_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/model/university_model.dart';
import '/screens/widgets/drawer.dart';
import '/widgets/university_card.dart';

class UniversityListScreen extends StatefulWidget {
  const UniversityListScreen({super.key});

  @override
  State<UniversityListScreen> createState() => _UniversityListScreenState();
}

class _UniversityListScreenState extends State<UniversityListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<University> universities = [];
  List<University> filteredUniversities = [];
  List<String> categories = [
    'Medical',
    'Computer Science',
    'Business',
    'Engineering',
  ];
  String searchQuery = '';
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadFavoriteCount();
    loadUniversities();
  }

  Future<void> loadUniversities() async {
    List<University> tempUniversities = [];
    List<String> jsonFiles = [
      'assets/Medical.json',
      'assets/Engineering.json',
      'assets/Computer Science.json',
      'assets/Business.json'
    ];

    for (String file in jsonFiles) {
      final String response = await rootBundle.loadString(file);
      final List<dynamic> data = json.decode(response);

      for (var uni in data) {
        // Normalize 'Specialization' to 'programs'
        if (uni.containsKey('Specialization')) {
          uni['programs'] = [uni['Specialization']];
        }

        // Ensure contact info is included or empty
        if (!uni.containsKey('contact')) {
          uni['contact'] = {
            'phone': uni['contact.phone'] ?? '',
            'email': uni['contact.email'] ?? '',
            'website': uni['contact.website'] ?? '',
          };
        }
      }

      tempUniversities.addAll(
        List<University>.from(data.map((json) => University.fromJson(json))),
      );
    }

    setState(() {
      universities = tempUniversities;
      filteredUniversities = universities;
    });
  }

  void filterUniversities({String? query, String? category}) {
    setState(() {
      searchQuery = query ?? searchQuery;
      selectedCategory = category;

      filteredUniversities = universities.where((university) {
        bool matchesSearch = university.name
            .toLowerCase()
            .contains(searchQuery.toLowerCase());

        bool matchesCategory = selectedCategory == null ||
            _matchesProgram(university.programs, selectedCategory);

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  bool _matchesProgram(List<String> programs, String? category) {
    return programs.any((program) => 
        program.toLowerCase().contains(category?.toLowerCase() ?? ''));
  }

  int favoriteCount = 0;

  Future<void> _loadFavoriteCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favoriteIds') ?? [];
    setState(() {
      favoriteCount = favoriteIds.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            _buildCategoryFilter(),
            Expanded(
              child: _buildUniversityList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const Icon(Icons.menu, color: Colors.blue, size: 30),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: const Icon(Icons.favorite_outline, color: Colors.blue, size: 30),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {},
                child: const Icon(Icons.compare_arrows_rounded, color: Colors.blue, size: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by University\'s Name or Program',
          prefixIcon: const Icon(Icons.search, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.blue.withOpacity(0.1),
        ),
        onChanged: (query) => filterUniversities(query: query),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildFilterChip('All', null);
          }
          return _buildFilterChip(categories[index - 1], categories[index - 1]);
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, String? category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: selectedCategory == category,
        onSelected: (bool selected) {
          filterUniversities(category: selected ? category : null);
        },
      ),
    );
  }

  Widget _buildUniversityList() {
    return ListView.builder(
      itemCount: filteredUniversities.length,
      itemBuilder: (context, index) {
        return UniversityCard(university: filteredUniversities[index]);
      },
    );
  }
}
