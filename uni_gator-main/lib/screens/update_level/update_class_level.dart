import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_gator/widgets/custom_button.dart';

import '../../resources/service_constants.dart';
import '../bottomnav_bar.dart';

class UpdateClassLevelScreen extends StatefulWidget {
  const UpdateClassLevelScreen({super.key});

  @override
  State<UpdateClassLevelScreen> createState() => _UpdateClassLevelScreenState();
}

class _UpdateClassLevelScreenState extends State<UpdateClassLevelScreen> {
  String? selectedLevel;
  double? selectedPercentage;

  Future<void> _showInputDialog(String level) async {
    final TextEditingController percentageController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Enter Percentage for $level",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          content: TextField(
            controller: percentageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter percentage"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedLevel = level;
                  selectedPercentage =
                      double.tryParse(percentageController.text);
                });
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClassContainer(String level, Color color) {
    return GestureDetector(
      onTap: () => _showInputDialog(level),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            level,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                "assets/images/unigatorr.png",
                height: 100,
              ),
              const SizedBox(height: 100),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildClassContainer("A Level", Colors.blue),
                    _buildClassContainer("O Level", Colors.green),
                    _buildClassContainer("Matric", Colors.orange),
                    _buildClassContainer("Inter", Colors.purple),
                  ],
                ),
              ),
              if (selectedLevel != null && selectedPercentage != null)
                Column(
                  children: [
                    Text(
                      "Selected Level: $selectedLevel\nPercentage: $selectedPercentage%",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Continue",
                      onPressed: () async {
                        if (selectedLevel != null &&
                            selectedPercentage != null) {
                          await userCollection
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "class": selectedLevel,
                            "percentage": selectedPercentage,
                          }).then(
                            (value) => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const BottomNavScreen(),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please select both class level and percentage."),
                            ),
                          );
                        }
                      },
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
