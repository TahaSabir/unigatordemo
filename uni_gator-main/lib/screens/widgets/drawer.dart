import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uni_gator/data/network_service.dart';
import 'package:uni_gator/screens/splash/onboarding_screen.dart';
import 'package:uni_gator/screens/widgets/equivalency_calculator.dart';

import '../../utils/utils.dart';
import '../hostel/university_hostel.dart';
import '../profile_screen.dart';
import '/screens/widgets/drawerheader.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            const CustomDrawerHeader(),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                children: <Widget>[
                  _buildAnimatedListTile(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () => Navigator.pop(context),
                    index: 0,
                  ),
                  _buildAnimatedListTile(
                    icon: Icons.bed,
                    title: 'Hostels',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UniversityHostelScreen(),
                        ),
                      );
                    },
                    index: 1,
                  ),
                  _buildAnimatedListTile(
                    icon: Icons.school,
                    title: 'Universities',
                    onTap: () => Navigator.pop(context),
                    index: 2,
                  ),
                  _buildAnimatedListTile(
                    icon: Icons.calculate_rounded,
                    title: 'Equivalency Calculator',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EquivalencyCalculator(),
                        ),
                      );
                    },
                    index: 3,
                  ),
                  _buildAnimatedListTile(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    index: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.blue.shade200,
                    ),
                  ).animate().fadeIn(delay: 800.ms),
                  _buildAnimatedListTile(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () => Navigator.pop(context),
                    index: 5,
                  ),
                  _buildAnimatedListTile(
                    icon: Icons.exit_to_app,
                    title: 'Logout',
                    onTap: () async {
                      await NetworkService().signOut().then((value) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const OnBoardingScreen(),
                        ));
                        Utils.flushBarErrorMessage('Signed out', context);
                      });
                    },
                    index: 6,
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required int index,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red.shade700 : Colors.blue.shade700,
          size: 26,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red.shade700 : Colors.blue.shade900,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        tileColor: Colors.transparent,
        hoverColor: Colors.blue.withOpacity(0.1),
        selectedTileColor: Colors.blue.withOpacity(0.2),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 100 * index))
        .slideX(begin: -0.2, end: 0);
  }
}
