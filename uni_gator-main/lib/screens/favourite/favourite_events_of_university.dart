import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/model/university_model.dart';

class FavouriteEventsOfUniversityScreen extends StatefulWidget {
  const FavouriteEventsOfUniversityScreen({super.key});

  @override
  State<FavouriteEventsOfUniversityScreen> createState() =>
      _FavouriteUniversityEventsOfScreenScreenState();
}

class _FavouriteUniversityEventsOfScreenScreenState
    extends State<FavouriteEventsOfUniversityScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<University> universities = [];
  List<University> filteredUniversities = [];

  @override
  void initState() {
    super.initState();
    loadFavoriteUniversities();
  }

  Future<void> loadFavoriteUniversities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favoriteIds') ?? [];

    final String response =
        await rootBundle.loadString('assets/university_data.json');
    final data = await json.decode(response);

    setState(() {
      universities =
          List<University>.from(data.map((json) => University.fromJson(json)));

      filteredUniversities = universities
          .where(
              (university) => favoriteIds.contains(university.rank.toString()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Favourite Events'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: filteredUniversities.length,
          itemBuilder: (context, index) {
            final university = filteredUniversities[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // University Image Carousel
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 1.0,
                        autoPlay: true,
                      ),
                      items: university.images.map((image) {
                        return Image.asset(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      }).toList(),
                    ),
                    // University Details
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // University Name and Rank
                          Text(
                            university.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rank: ${university.rank}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Event Details Section
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Upcoming Event',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.event, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text(
                                      'Admissions',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                      'Start Date: 20-08-2024',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'End Date: 20-10-2024',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Test Date: 10-11-2024',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
