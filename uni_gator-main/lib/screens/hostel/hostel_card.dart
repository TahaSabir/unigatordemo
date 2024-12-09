import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '/model/hostel_model.dart';

class HostelCard extends StatelessWidget {
  final Hostel hostel;

  const HostelCard({super.key, required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hostel.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Rent: ${hostel.rent}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.location_on, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hostel.address,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.phone, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  hostel.contact.phone,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.email, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  hostel.contact.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // CarouselSlider - Images Section
            if (hostel.images.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                  ),
                  items: hostel.images
                      .map((image) => Image.asset(
                            image,
                            fit: BoxFit.cover,
                          ))
                      .toList(),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
