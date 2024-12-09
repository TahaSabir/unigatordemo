import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_gator/screens/widgets/drawer.dart';
import 'package:uni_gator/utils/app_colors.dart';

import '../../resources/service_constants.dart';

class EquivalencyCalculator extends StatefulWidget {
  final Function(double)? onPercentageCalculated;
  final String? heroTag; // Add heroTag parameter

  const EquivalencyCalculator({
    super.key,
    this.onPercentageCalculated,
    this.heroTag, // Initialize heroTag
  });

  @override
  _EquivalencyCalculatorState createState() => _EquivalencyCalculatorState();
}

class _EquivalencyCalculatorState extends State<EquivalencyCalculator> {
  int _numberOfSubjects = 1;
  final List<String> _grades = ['A*', 'A', 'B', 'C', 'D', 'E'];
  late List<String?> _selectedGrades;
  double _equivalencyResult = 0.0;
  double _percentageResult = 0.0;
  String _selectedLevel = 'O levels';
  String calculationType = 'Punjab Board';
  final TextEditingController _obtainedMarksController =
      TextEditingController();
  final TextEditingController _totalMarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedGrades = List.filled(_numberOfSubjects, null);
  }

  @override
  void dispose() {
    _obtainedMarksController.dispose();
    _totalMarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        drawer: widget.heroTag != null
            ? Hero(
                tag: "${widget.heroTag}_drawer",
                child: const CustomDrawer(),
              )
            : const CustomDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildHeader(textTheme),
                  const SizedBox(height: 20),
                  _buildCalculationTypeSelector(textTheme),
                  const SizedBox(height: 20),
                  _buildResultCard(textTheme),
                  const SizedBox(height: 20),
                  if (calculationType == 'Punjab Board') ...[
                    _buildLevelSelector(textTheme),
                    const SizedBox(height: 20),
                    _buildSubjectSelector(textTheme),
                    const SizedBox(height: 20),
                    ..._buildGradeSelectors(textTheme),
                    _buildEquivalencyButton(textTheme),
                  ] else ...[
                    _buildPercentageCalculator(textTheme),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        Text(
          calculationType == 'Punjab Board'
              ? 'Equivalency Calculator'
              : 'Percentage Calculator',
          style: textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildGlassCard(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  Future<void> _saveToProfile(double percentage) async {
    if (!mounted) return;

    // Validate percentage
    if (percentage < 0 || percentage > 100) {
      _showMessage('Invalid percentage value', isError: true);
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        );
      },
    );

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pop(context); // Close loading indicator
        _showMessage('Please login to save your percentage', isError: true);
        return;
      }

      // Get current timestamp
      final timestamp = DateTime.now();

      // Create data map
      final data = {
        'percentage': percentage,
        'calculationType': calculationType,
        'timestamp': timestamp,
        'calculationDetails': {
          'type': calculationType,
          'level': _selectedLevel,
          'numberOfSubjects': _numberOfSubjects,
          'grades': _selectedGrades,
          'obtainedMarks': _obtainedMarksController.text,
          'totalMarks': _totalMarksController.text,
        },
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await userCollection.doc(user.uid).update(data);

      // Close loading indicator
      if (mounted) Navigator.pop(context);

      // Show success message
      _showMessage('Percentage saved to profile successfully!');
    } catch (e) {
      // Close loading indicator
      if (mounted) Navigator.pop(context);

      // Show error message
      _showMessage('Error saving percentage: $e', isError: true);
    }
  }

// Helper method for showing messages
  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isError ? Colors.red : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _calculateEquivalency() {
    if (_numberOfSubjects == 0) return;

    final Map<String, double> gradePoints = {
      'A*': 5.5,
      'A': 5.0,
      'B': 4.0,
      'C': 3.0,
      'D': 2.0,
      'E': 1.0,
    };

    double totalPoints = _selectedGrades
        .where((grade) => grade != null)
        .map((grade) => gradePoints[grade]!)
        .fold(0.0, (sum, points) => sum + points);

    setState(() {
      _equivalencyResult =
          _numberOfSubjects > 0 ? totalPoints / _numberOfSubjects : 0.0;
      double percentage = _convertToPercentage(_equivalencyResult);
      debugPrint(percentage.toString());
      widget.onPercentageCalculated?.call(percentage);
      calculationType = 'Cambridge';
      debugPrint(calculationType + "sss");
    });
  }

  void _calculatePercentage() {
    double obtained = double.tryParse(_obtainedMarksController.text) ?? 0;
    double total = double.tryParse(_totalMarksController.text) ?? 1;

    setState(() {
      _percentageResult = (obtained / total) * 100;
      widget.onPercentageCalculated?.call(_percentageResult);
    });
  }

  double _convertToPercentage(double equivalency) {
    return (equivalency / 5.5) * 100;
  }

// Update type button to handle text overflow
  Widget _buildTypeButton(String text, bool isSelected, TextTheme textTheme) {
    return Expanded(
      // Wrap with Expanded
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GestureDetector(
          onTap: () => setState(() => calculationType = text),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center, // Center the text
              overflow: TextOverflow.ellipsis, // Handle text overflow
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

// Update subject selector with proper text theme and styling
  Widget _buildSubjectSelector(TextTheme textTheme) {
    return _buildGlassCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '   Number of Subjects:',
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: DropdownButton<int>(
              value: _numberOfSubjects,
              isExpanded: true,
              dropdownColor: AppColors.primary,
              style: textTheme.bodyLarge?.copyWith(color: Colors.white),
              underline: const SizedBox(),
              onChanged: (newValue) {
                setState(() {
                  _numberOfSubjects = newValue!;
                  _selectedGrades = List.filled(newValue, null);
                  _calculateEquivalency();
                });
              },
              items: List.generate(8, (index) => index + 1).map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    '$value ${value == 1 ? 'Subject' : 'Subjects'}',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

// Update grade selectors with proper text theme
  List<Widget> _buildGradeSelectors(TextTheme textTheme) {
    return List.generate(_numberOfSubjects, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _buildGlassCard(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '  Subject ${index + 1} Grade:',
                style: textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButton<String>(
                  value: _selectedGrades[index],
                  isExpanded: true,
                  dropdownColor: AppColors.primary,
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                  underline: const SizedBox(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGrades[index] = newValue;
                      _calculateEquivalency();
                    });
                  },
                  items: _grades.map((String grade) {
                    return DropdownMenuItem<String>(
                      value: grade,
                      child: Text(grade),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCalculationTypeSelector(TextTheme textTheme) {
    return _buildGlassCard(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTypeButton(
              'Punjab Board', calculationType == 'Punjab Board', textTheme),
          _buildTypeButton(
              'Sindh Board', calculationType == 'Sindh Board', textTheme),
        ],
      ),
    );
  }

// Add an equivalency button
  Widget _buildEquivalencyButton(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: ElevatedButton(
        onPressed: () {
          if (calculationType == 'Punjab Board') {
            _calculateEquivalency();
            _showMessage('Equivalency Calculated: $_equivalencyResult');
          } else {
            _calculatePercentage();
            _showMessage('Percentage Calculated: $_percentageResult');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          'Calculate Equivalency',
          style: textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildResultCard(TextTheme textTheme) {
    // Determine the result to display based on the calculation type
    double displayResult = calculationType == 'Cambridge'
        ? _convertToPercentage(_equivalencyResult)
        : _percentageResult;

    return _buildGlassCard(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title: "Your Result"
          Text(
            'Your Result',
            style: textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Display the result as a percentage
          Text(
            '${displayResult.toStringAsFixed(2)}%',
            style: textTheme.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // "Save to Profile" button
          ElevatedButton(
            onPressed: () => _saveToProfile(displayResult),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Save to Profile',
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelSelector(TextTheme textTheme) {
    return _buildGlassCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '   Select Level:',
            style: textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 10),
          _buildDropdownContainer(
            DropdownButton<String>(
              value: _selectedLevel,
              isExpanded: true,
              dropdownColor: AppColors.primary,
              style: textTheme.bodyLarge?.copyWith(color: Colors.white),
              underline: const SizedBox(),
              onChanged: (newValue) {
                setState(() {
                  _selectedLevel = newValue!;
                  _calculateEquivalency();
                });
              },
              items: ['O levels', 'A levels'].map((String level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownContainer(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: textTheme.bodyLarge?.copyWith(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.secondary.withOpacity(0.1),
            border: _buildTextFieldBorder(),
            enabledBorder:
                _buildTextFieldBorder(color: Colors.white.withOpacity(0.3)),
            focusedBorder: _buildTextFieldBorder(color: Colors.white),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildTextFieldBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: color != null ? BorderSide(color: color) : BorderSide.none,
    );
  }

  Widget _buildPercentageCalculator(TextTheme textTheme) {
    return _buildGlassCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
              '  Obtained Marks', _obtainedMarksController, textTheme),
          const SizedBox(height: 16),
          _buildTextField('  Total Marks', _totalMarksController, textTheme),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _calculatePercentage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary.withOpacity(0.2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Calculate',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
