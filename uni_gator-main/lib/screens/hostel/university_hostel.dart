import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/model/hostel_model.dart';
import '/screens/widgets/drawer.dart';
import 'hostel_card.dart';

class UniversityHostelScreen extends StatefulWidget {
  const UniversityHostelScreen({super.key});

  @override
  State<UniversityHostelScreen> createState() => _UniversityHostelScreenState();
}

class _UniversityHostelScreenState extends State<UniversityHostelScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Hostel> hostels = [];
  List<Hostel> filteredHostels = [];
  List<String> categories = [
    'Boys',
    'Girls',
    'Mixed',
  ];
  String searchQuery = '';
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    loadHostels();
  }

  Future<void> loadHostels() async {
    final String response =
        await rootBundle.loadString('assets/university_hostel.json');
    final data = await json.decode(response);
    setState(() {
      hostels = List<Hostel>.from(data.map((json) => Hostel.fromJson(json)));
      filteredHostels = hostels;
    });
  }

  void filterHostels({String? query}) {
    setState(() {
      searchQuery = query ?? searchQuery;

      filteredHostels = hostels.where((hostel) {
        bool matchesSearch =
            hostel.name.toLowerCase().contains(searchQuery.toLowerCase());

        return matchesSearch;
      }).toList();
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
            _buildSearchBar(),
            _buildCategoryFilter(),
            Expanded(
              child: _buildHostelList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by Hostel\'s Name or Category',
          prefixIcon: const Icon(Icons.search, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.blue.withOpacity(0.1),
        ),
        onChanged: (query) => filterHostels(query: query),
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
          filterHostels(query: selected ? category : null);
        },
      ),
    );
  }

  Widget _buildHostelList() {
    return ListView.builder(
      itemCount: filteredHostels.length,
      itemBuilder: (context, index) {
        return HostelCard(hostel: filteredHostels[index]);
      },
    );
  }
}
