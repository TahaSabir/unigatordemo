// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:uni_gator/screens/ome_screen.dart';
// import 'package:uni_gator/screens/profile_screen.dart';
// import 'package:uni_gator/screens/university_recommend.dart';

// class BottomNavScreen extends StatefulWidget {
//   const BottomNavScreen({super.key});

//   @override
//   _BottomNavScreenState createState() => _BottomNavScreenState();
// }

// class _BottomNavScreenState extends State<BottomNavScreen> {
//   int currentIndex = 0;
//   late List<Widget> _screens;

//   @override
//   void initState() {
//     super.initState();
//     _screens = [
//       const UniversityListScreen(),
//       //const UniversityRecommendation(),
//       const ProfilePage(),
//     ];
//   }

//   void _onBottomNavBarItemTapped(int index) {
//     setState(() {
//       currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: currentIndex,
//         children: _screens,
//       ),
//       bottomNavigationBar: Container(
//         height: 70,
//         decoration: const BoxDecoration(
//           color: Colors.black,
//         ),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             CustomPaint(
//               size: Size(MediaQuery.of(context).size.width, 90),
//               painter: BNBCustomPainter(),
//             ),
//             Center(
//               heightFactor: 0.3,
//               child: SizedBox(
//                 width: 60,
//                 height: 60,
//                 child: FloatingActionButton(
//                   onPressed: () {
//                     _onBottomNavBarItemTapped(1);
//                   },
//                   shape: const CircleBorder(),
//                   backgroundColor: Colors.transparent,
//                   elevation: 0,
//                   child: Container(
//                     width: 60,
//                     height: 60,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         colors: [
//                           Color.fromARGB(255, 255, 255, 255),
//                           Color(0xFF5BCCD9),
//                         ],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                     ),
//                     child: Center(
//                       child: Image.asset(
//                         'assets/icons/ai.png',
//                         width: 40,
//                         height: 40,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               height: 80,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   IconButton(
//                     icon: SvgPicture.asset(
//                       'assets/icons/home.svg',
//                       width: 28,
//                       height: 28,
//                     ),
//                     onPressed: () {
//                       _onBottomNavBarItemTapped(0);
//                     },
//                   ),
//                   const SizedBox(width: 35),
//                   IconButton(
//                     icon: SvgPicture.asset(
//                       'assets/icons/account.svg',
//                       width: 30,
//                       height: 30,
//                     ),
//                     onPressed: () {
//                       _onBottomNavBarItemTapped(2);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BNBCustomPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..shader = const LinearGradient(
//         begin: Alignment.centerLeft,
//         end: Alignment.centerRight,
//         colors: [
//           Color.fromARGB(255, 28, 28, 28),
//           Color.fromARGB(255, 28, 28, 28),
//         ],
//       ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
//       ..style = PaintingStyle.fill;

//     final Path path = Path();
//     path.moveTo(0, 0);
//     path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
//     path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
//     path.arcToPoint(
//       Offset(size.width * 0.60, 15),
//       radius: const Radius.circular(30.0),
//       clockwise: false,
//     );
//     path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
//     path.quadraticBezierTo(size.width * 0.80, 0, size.width, 0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.lineTo(0, 20);
//     canvas.drawShadow(path, Colors.black, 5, true);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uni_gator/screens/university_recommend.dart';
import 'package:uni_gator/screens/ome_screen.dart';
// import 'package:uni_gator/screens/profile_screen.dart';
import 'package:uni_gator/screens/profile_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      //       const UniversityListScreen(),
//       //const UniversityRecommendation(),
//       const ProfilePage(),
//     ];
      const UniversityListScreen(),
      UniversityRecommendation(), // Add the recommendation screen
      const ProfilePage(),
    ];
  }

  void _onBottomNavBarItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 90),
              painter: BNBCustomPainter(),
            ),
            Center(
              heightFactor: 0.3,
              child: SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    // Switch to the recommendation screen (index 1)
                    _onBottomNavBarItemTapped(1);
                  },
                  shape: const CircleBorder(),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          Color(0xFF5BCCD9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/ai.png', // Icon for the middle button
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/home.svg',
                      width: 28,
                      height: 28,
                    ),
                    onPressed: () {
                      // Switch to the home screen (index 0)
                      _onBottomNavBarItemTapped(0);
                    },
                  ),
                  const SizedBox(width: 35), // Placeholder for the middle button
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/account.svg',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      // Switch to the profile screen (index 2)
                      _onBottomNavBarItemTapped(2);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color.fromARGB(255, 28, 28, 28),
          Color.fromARGB(255, 28, 28, 28),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(
      Offset(size.width * 0.60, 15),
      radius: const Radius.circular(30.0),
      clockwise: false,
    );
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
