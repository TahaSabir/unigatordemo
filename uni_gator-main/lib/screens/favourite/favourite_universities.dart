import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../university_details_screen.dart';
import '/model/university_model.dart';

class FavouriteUniversityScreen extends StatefulWidget {
  const FavouriteUniversityScreen({super.key});

  @override
  State<FavouriteUniversityScreen> createState() =>
      _FavouriteUniversityScreenScreenState();
}

class _FavouriteUniversityScreenScreenState
    extends State<FavouriteUniversityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<University> universities = [];
  List<University> filteredUniversities = [];
  List<String> categories = [
    'Medical',
    'Computer Science',
    'Business',
    'Engineering',
    'Social Sciences',
    'Natural Sciences',
    'Arts',
    'Law'
  ];
  String searchQuery = '';
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    loadFavoriteUniversities();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadFavoriteUniversities();
  }

  Future<void> loadFavoriteUniversities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favoriteIds') ?? [];

    // Load all universities
    final String response =
        await rootBundle.loadString('assets/university_data.json');
    final data = await json.decode(response);

    setState(() {
      universities =
          List<University>.from(data.map((json) => University.fromJson(json)));

      // Filter universities based on favorite IDs
      filteredUniversities = universities
          .where(
              (university) => favoriteIds.contains(university.rank.toString()))
          .toList();
    });
  }

  String normalizeProgram(String program) {
    program = program.toLowerCase();
    if (program.contains('computer') ||
        program.contains('software') ||
        program.contains('it') ||
        program.contains('artificial intelligence')) {
      return 'computer science';
    } else if (program.contains('business') ||
        program.contains('bba') ||
        program.contains('management')) {
      return 'business';
    } else if (program.contains('engineer')) {
      return 'engineering';
    } else if (program.contains('medic') ||
        program.contains('health') ||
        program.contains('pharma')) {
      return 'medical';
    } else if (program.contains('social') ||
        program.contains('econom') ||
        program.contains('psycholog')) {
      return 'social sciences';
    } else if (program.contains('physics') ||
        program.contains('chemistry') ||
        program.contains('biology') ||
        program.contains('math')) {
      return 'natural sciences';
    } else if (program.contains('art') ||
        program.contains('design') ||
        program.contains('music')) {
      return 'arts';
    } else if (program.contains('law') || program.contains('legal')) {
      return 'law';
    }
    return program;
  }

  void filterUniversities({String? query, String? category}) {
    setState(() {
      searchQuery = query ?? searchQuery;
      selectedCategory = category;

      filteredUniversities = universities.where((university) {
        bool matchesSearch =
            university.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                university.programs.any((program) =>
                    program.toLowerCase().contains(searchQuery.toLowerCase()));

        bool matchesCategory = selectedCategory == null ||
            university.programs.any((program) {
              String normalizedProgram = normalizeProgram(program);
              return normalizedProgram == selectedCategory!.toLowerCase();
            });

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Favourites'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildUniversityList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUniversityList() {
    return ListView.builder(
      itemCount: filteredUniversities.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UniversityDetailScreen(
                        university: filteredUniversities[index]),
                  ),
                ).then((_) {
                  loadFavoriteUniversities();
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 250,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                      items: filteredUniversities[index].images.map((image) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Image.asset(
                              image,
                              fit: BoxFit.fill,
                              width: double.infinity,
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  // University Information
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0x005ecde1).withOpacity(0.9),
                            const Color(0x005ecde1).withOpacity(0.3),
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12))),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // University Name and Rank
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  filteredUniversities[index].name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.white, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Rank ${filteredUniversities[index].rank}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Programs
                          Row(
                            children: [
                              const Icon(Icons.school,
                                  color: Colors.indigo, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Diverse Programs Available",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Campuses and Duration
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.red, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        filteredUniversities[index]
                                            .campus
                                            ,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700]),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.timer,
                                      color: Colors.green, size: 20),
                                  const SizedBox(width: 4),
                                  Text(
                                    '4 years',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
