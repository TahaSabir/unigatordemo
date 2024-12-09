// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';

// // class CustomDrawerHeader extends StatelessWidget {
// //   const CustomDrawerHeader({super.key});

// //   Future<Map<String, dynamic>?> getUserData(String userId) async {
// //     DocumentSnapshot snapshot =
// //         await FirebaseFirestore.instance.collection('users').doc(userId).get();
// //     if (snapshot.exists) {
// //       return snapshot.data() as Map<String, dynamic>?;
// //     }
// //     return null;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       height: 220,
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //           colors: [Colors.blue.shade700, Colors.blue.shade900],
// //         ),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: FutureBuilder<Map<String, dynamic>?>(
// //           future: getUserData(FirebaseAuth.instance.currentUser!.uid),
// //           builder: (context, snapshot) {
// //             if (snapshot.connectionState == ConnectionState.waiting) {
// //               return const Center(
// //                 child: CircularProgressIndicator(
// //                   color: Colors.white,
// //                 ),
// //               );
// //             }

// //             if (snapshot.hasError) {
// //               return Center(child: Text("Error: ${snapshot.error}"));
// //             }

// //             // Default static values
// //             String name = "Name";
// //             String email = "Email";
// //             String profile =
// //                 "https://stcpanania.syd.catholic.edu.au/wp-content/uploads/sites/2/2019/07/ProfileUnavailable-400x333.jpg";

// //             // If user data is available, use it
// //             if (snapshot.hasData && snapshot.data != null) {
// //               name = snapshot.data!['name'] ?? name;
// //               email = snapshot.data!['email'] ?? email;
// //               profile = snapshot.data!['imageUrl'] == ""
// //                   ? profile
// //                   : snapshot.data!['imageUrl'];
// //             }

// //             return Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               mainAxisAlignment: MainAxisAlignment.end,
// //               children: [
// //                 Center(
// //                   child: Hero(
// //                     tag: 'profileImage',
// //                     child: Container(
// //                       width: 100,
// //                       height: 100,
// //                       decoration: BoxDecoration(
// //                         shape: BoxShape.circle,
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black.withOpacity(0.2),
// //                             blurRadius: 10,
// //                             offset: const Offset(0, 5),
// //                           ),
// //                         ],
// //                       ),
// //                       child: ClipOval(
// //                         child: Image.network(
// //                           profile,
// //                           fit: BoxFit.cover,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 16),
// //                 Center(
// //                   child: Column(
// //                     children: [
// //                       Text(
// //                         name,
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 24,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 4),
// //                       Text(
// //                         email,
// //                         style: TextStyle(
// //                           color: Colors.white.withOpacity(0.8),
// //                           fontSize: 16,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class CustomDrawerHeader extends StatelessWidget {
//   const CustomDrawerHeader({super.key});

//   Future<Map<String, dynamic>?> getUserData(String userId) async {
//     DocumentSnapshot snapshot =
//         await FirebaseFirestore.instance.collection('users').doc(userId).get();
//     if (snapshot.exists) {
//       return snapshot.data() as Map<String, dynamic>?;
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 240,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.blue.shade700, Colors.blue.shade900],
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<Map<String, dynamic>?>(
//           future: getUserData(FirebaseAuth.instance.currentUser!.uid),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                 ),
//               );
//             }

//             if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             }

//             String name = "Name";
//             String email = "Email";
//             String profile = "https://stcpanania.syd.catholic.edu.au/wp-content/uploads/sites/2/2019/07/ProfileUnavailable-400x333.jpg";

//             if (snapshot.hasData && snapshot.data != null) {
//               name = snapshot.data!['name'] ?? name;
//               email = snapshot.data!['email'] ?? email;
//               profile = snapshot.data!['imageUrl'] == ""
//                   ? profile
//                   : snapshot.data!['imageUrl'];
//             }

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Center(
//                   child: Hero(
//                     tag: 'profileImage',
//                     child: Container(
//                       width: 110,
//                       height: 110,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 3),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 12,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: ClipOval(
//                         child: Image.network(
//                           profile,
//                           fit: BoxFit.cover,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) return child;
//                             return Center(
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes != null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                         loadingProgress.expectedTotalBytes!
//                                     : null,
//                                 color: Colors.white,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ).animate()
//                     .fadeIn(duration: 600.ms)
//                     .scale(delay: 200.ms),
//                 const SizedBox(height: 16),
//                 Center(
//                   child: Column(
//                     children: [
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.5,
//                         ),
//                       ).animate()
//                           .fadeIn(duration: 600.ms)
//                           .slideX(begin: -0.2, end: 0),
//                       const SizedBox(height: 8),
//                       Text(
//                         email,
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.9),
//                           fontSize: 16,
//                           letterSpacing: 0.3,
//                         ),
//                       ).animate()
//                           .fadeIn(duration: 600.ms)
//                           .slideX(begin: 0.2, end: 0),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key});

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade700, Colors.blue.shade900],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: getUserData(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            String name = "Name";
            String email = "Email";
            String profile = "https://stcpanania.syd.catholic.edu.au/wp-content/uploads/sites/2/2019/07/ProfileUnavailable-400x333.jpg";

            if (snapshot.hasData && snapshot.data != null) {
              name = snapshot.data!['name'] ?? name;
              email = snapshot.data!['email'] ?? email;
              profile = snapshot.data!['imageUrl'] == ""
                  ? profile
                  : snapshot.data!['imageUrl'];
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        profile,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
