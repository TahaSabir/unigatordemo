import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '/model/university_model.dart';
import '/widgets/app_text_style.dart';

class UniversityDetailScreen extends StatefulWidget {
  final University university;

  const UniversityDetailScreen({super.key, required this.university});

  @override
  State<UniversityDetailScreen> createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageCarousel(
                images: widget.university.images,
                universityID: widget.university.rank,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.university.name,
                      style:
                          AppTextTheme.getLightTextTheme(context).headlineLarge,
                    ),
                    const SizedBox(height: 16),
                    InfoCard(
                      title: 'Rank and Campus',
                      child:
                          _RankAndCampusesInfo(university: widget.university),
                    ),
                    const SizedBox(height: 16),
                    InfoCard(
                      title: 'Minimum Marks',
                      child: _MinimumMarksInfo(university: widget.university),
                    ),
                    const SizedBox(height: 16),
                    InfoCard(
                      title: 'Contact Information',
                      child: _ContactInfo(contact: widget.university.contact),
                    ),
                    const SizedBox(height: 16),
                    InfoCard(
                      title: 'Programs Offered',
                      child:
                          _ProgramsList(programs: widget.university.programs),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  final List<String> images;
  final int universityID;

  const _ImageCarousel({required this.images, required this.universityID});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  Future<void> _toggleFavorite(int universityID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favoriteIds') ?? [];

    if (favoriteIds.contains(universityID.toString())) {
      favoriteIds.remove(universityID.toString());
    } else {
      favoriteIds.add(universityID.toString());
    }

    await prefs.setStringList('favoriteIds', favoriteIds);
    setState(() {});
  }

  Future<bool> _isFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteIds = prefs.getStringList('favoriteIds') ?? [];
    return favoriteIds.contains(widget.universityID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            viewportFraction: 1,
            autoPlay: true,
          ),
          items: widget.images.map((image) {
            return Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Image not found'));
              },
            );
          }).toList(),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        FutureBuilder<bool>(
          future: _isFavorite(),
          builder: (context, snapshot) {
            final isFavorite = snapshot.data == true;
            return Positioned(
              top: 16,
              right: 16,
              child: CircleAvatar(
                backgroundColor: isFavorite ? Colors.red : Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await _toggleFavorite(widget.universityID);
                    setState(() {});
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const InfoCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.purple.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextTheme.getLightTextTheme(context)
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _RankAndCampusesInfo extends StatelessWidget {
  final University university;

  const _RankAndCampusesInfo({required this.university});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            Text(
              'Rank: ${university.rank}',
              style: AppTextTheme.getLightTextTheme(context).bodyLarge,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Campus:',
          style: AppTextTheme.getLightTextTheme(context).bodyLarge,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                university.campus,
                style: AppTextTheme.getLightTextTheme(context).bodyLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MinimumMarksInfo extends StatelessWidget {
  final University university;

  const _MinimumMarksInfo({required this.university});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMarkInfo(context, 'Min. SSC', university.minimumSSC),
        _buildMarkInfo(context, 'Min. HSC', university.minimumHSC),
      ],
    );
  }

  Widget _buildMarkInfo(BuildContext context, String title, String marks) {
    return Column(
      children: [
        Text(title, style: AppTextTheme.getLightTextTheme(context).bodyLarge),
        const SizedBox(height: 8),
        Text(
          marks,
          style: AppTextTheme.getLightTextTheme(context)
              .bodyLarge
              ?.copyWith(color: Colors.blue),
        ),
      ],
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final Contact contact;

  const _ContactInfo({required this.contact});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (contact.phone.isNotEmpty)
          _buildContactItem(
              context, Icons.phone, contact.phone, 'tel:${contact.phone}'),
        if (contact.email.isNotEmpty)
          _buildContactItem(
              context, Icons.email, contact.email, 'mailto:${contact.email}'),
        if (contact.website.isNotEmpty)
          _buildContactItem(context, Icons.web, contact.website, 'https://${contact.website}'),
      ],
    );
  }

  Widget _buildContactItem(
      BuildContext context, IconData icon, String text, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextTheme.getLightTextTheme(context)
                  .bodyLarge
                  ?.copyWith(color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class _ProgramsList extends StatelessWidget {
  final List<String> programs;

  const _ProgramsList({required this.programs});

  @override
  Widget build(BuildContext context) {
    return programs.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: programs
                .map((program) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.school, color: Colors.indigo, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              program,
                              style: AppTextTheme.getLightTextTheme(context)
                                  .bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          )
        : const Center(child: Text('No programs available'));
  }
}
