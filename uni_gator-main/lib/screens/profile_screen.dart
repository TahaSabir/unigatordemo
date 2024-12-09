

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:iconly/iconly.dart';
// import 'package:uni_gator/screens/profile/profile_details_view.dart';
// import 'package:uni_gator/utils/app_colors.dart';

// import '../../resources/service_constants.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   late Future<DocumentSnapshot> _userDataFuture;

//   @override
//   void initState() {
//     super.initState();
//     _userDataFuture = _getUserData();
//   }

//   Future<DocumentSnapshot> _getUserData() async {
//     return await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
//   }


// Widget _buildAppBar(Map<String, dynamic> userData) {
//     return SliverAppBar(
//       expandedHeight: 180, // Reduced height
//       floating: false,
//       pinned: true,
//       stretch: true,
//       // backgroundColor: AppColors.primary,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 AppColors.primary,
//                 AppColors.secondary,
//               ],
//             ),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(20),
//               bottomRight: Radius.circular(20),
//             ),
//           ),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // Optional: Add a pattern or overlay
//               ClipRRect(
              
//                 child: Opacity(
//                   opacity: 0.7,
//                   child: Image.network(
//                     'https://www.transparenttextures.com/patterns/cubes.png',
//                     repeat: ImageRepeat.repeat,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.edit, color: Colors.white),
//           onPressed: () async {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ProfileDetailsView(userData: userData),
//               ),
//             ).then((_) => setState(() {
//                   _userDataFuture = _getUserData();
//                 }));
//           },
//         ),
//       ],
//     );
//   }

// // Update the build method:
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.grey[100], // Light background color
//     body: FutureBuilder<DocumentSnapshot>(
//       future: _userDataFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }

//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return const Center(child: Text("No user data found."));
//         }

//         final userData = snapshot.data!.data() as Map<String, dynamic>;

//         return Stack(
//           children: [
//             CustomScrollView(
//               slivers: [
//                 _buildAppBar(userData),
//                 SliverToBoxAdapter(
//                   child: Container(
//                     padding: const EdgeInsets.only(top: 75), // Space for overlapping avatar
//                     child: Column(
//                       children: [
//                         // const SizedBox(height: 10),
//                         Text(
//                           userData['name'] ?? "No Name",
//                           style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.primary,
//                               ),
//                         ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
//                         // const SizedBox(height: 8),
//                         Text(
//                           userData['email'] ?? "No Email",
//                           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                 color: Colors.grey[600],
//                                 fontWeight: FontWeight.w500,
//                               ),
//                         ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
//                         const SizedBox(height: 24),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: _buildInfoSection(userData),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // Overlapping Profile Image
//             Positioned(
//               top: 130, // Adjust this value to position the avatar
//               left: 0,
//               right: 0,
//               child: Center(
//                 child: Hero(
//                   tag: 'profileImage',
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: Colors.white, width: 4),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 20,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 60,
//                       backgroundColor: AppColors.secondary,
//                       child: userData['imageUrl'] == ""
//                           ? Text(
//                               userData['name'] != null && userData['name'].isNotEmpty
//                                   ? userData['name'][0].toUpperCase()
//                                   : '',
//                               style: const TextStyle(
//                                 fontSize: 40,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             )
//                           : CircleAvatar(
//                               radius: 60,
//                               backgroundImage: NetworkImage(userData['imageUrl']),
//                             ),
//                     ),
//                   ),
//                 ).animate().scale(delay: 200.ms),
//               ),
//             ),
//           ],
//         );
//       },
//     ),
//   );
// }

// // Update the _buildInfoCard method for better aesthetics:
// Widget _buildInfoCard(String title, String value, IconData icon) {
//   return Container(
//     margin: const EdgeInsets.symmetric(vertical: 8),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.1),
//           blurRadius: 10,
//           spreadRadius: 2,
//         ),
//       ],
//     ),
//     child: ListTile(
//       contentPadding: const EdgeInsets.all(16),
//       leading: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: AppColors.primary.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Icon(icon, color: AppColors.primary),
//       ),
//       title: Text(
//         title,
//         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//       ),
//       subtitle: Padding(
//         padding: const EdgeInsets.only(top: 8),
//         child: Text(
//           value,
//           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 color: AppColors.primary,
//                 fontWeight: FontWeight.bold,
//               ),
//         ),
//       ),
//     ),
//   );
// }



//   Widget _buildProfileHeader(Map<String, dynamic> userData) {
//     return Column(
//       children: [
//         Hero(
//           tag: 'profileImage',
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                 ),
//               ],
//             ),
//             child: CircleAvatar(
//               radius: 75,
//               backgroundColor: AppColors.secondary,
//               child: userData['imageUrl'] == ""
//                   ? Text(
//                       userData['name'] != null && userData['name'].isNotEmpty
//                           ? userData['name'][0].toUpperCase()
//                           : '',
//                       style: const TextStyle(
//                         fontSize: 50,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     )
//                   : CircleAvatar(
//                       radius: 75,
//                       backgroundImage: NetworkImage(userData['imageUrl']),
//                     ),
//             ),
//           ),
//         ).animate().scale(delay: 200.ms),
//         // const SizedBox(height: 8),
//         Text(
//           userData['email'] ?? "No Email",
//           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//         ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
//       ],
//     );
//   }

//   Widget _buildInfoSection(Map<String, dynamic> userData) {
//     return Column(
//       children: [
//         _buildInfoCard(
//           "Phone",
//           userData['phone']?.toString() ?? "N/A",
//           IconlyBold.call,
//         ),
//         _buildInfoCard(
//           "Class",
//           userData['class']?.toString() ?? "N/A",
//           IconlyBold.work,
//         ),
//         _buildInfoCard(
//           "Percentage",
//           "${userData['percentage']?.toString() ?? "N/A"}%",
//           IconlyBold.chart,
//         ),
//       ].animate(interval: 200.ms).fadeIn().slideX(),
//     );
//   }

 
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';
import 'package:uni_gator/screens/profile/profile_details_view.dart';
import 'package:uni_gator/utils/app_colors.dart';

import '../../resources/service_constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Stream<DocumentSnapshot> _userDataStream;

  @override
  void initState() {
    super.initState();
    _userDataStream = _getUserDataStream();
  }

  Stream<DocumentSnapshot> _getUserDataStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();
    return userCollection.doc(user.uid).snapshots();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildErrorState(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            "Error: ${error.toString()}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {
              _userDataStream = _getUserDataStream();
            }),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(Map<String, dynamic> userData) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                child: Opacity(
                  opacity: 0.7,
                  child: Image.network(
                    'https://www.transparenttextures.com/patterns/cubes.png',
                    repeat: ImageRepeat.repeat,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileDetailsView(userData: userData),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileImage(Map<String, dynamic> userData) {
    return Positioned(
      top: 130,
      left: 0,
      right: 0,
      child: Center(
        child: Hero(
          tag: 'profileImage',
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.secondary,
              child: userData['imageUrl'] == "" || userData['imageUrl'] == null
                  ? Text(
                      userData['name'] != null && userData['name'].isNotEmpty
                          ? userData['name'][0].toUpperCase()
                          : '',
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(userData['imageUrl']),
                    ),
            ),
          ),
        ).animate().scale(delay: 200.ms),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(Map<String, dynamic> userData) {
    // Format percentage to show only 2 decimal places if it exists
    String percentageValue = "N/A";
    if (userData['percentage'] != null) {
      double percentage = userData['percentage'] is int 
          ? (userData['percentage'] as int).toDouble() 
          : userData['percentage'] as double;
      percentageValue = "${percentage.toStringAsFixed(2)}%";
    }

    return Column(
      children: [
        _buildInfoCard(
          "Phone",
          userData['phone']?.toString() ?? "N/A",
          IconlyBold.call,
        ),
        _buildInfoCard(
          "Class",
          userData['class']?.toString() ?? "N/A",
          IconlyBold.work,
        ),
        _buildInfoCard(
          "Percentage",
          percentageValue,
          IconlyBold.chart,
        ),
      ].animate(interval: 200.ms).fadeIn().slideX(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<DocumentSnapshot>(
        stream: _userDataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error);
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No user data found."));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _buildAppBar(userData),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(top: 75),
                      child: Column(
                        children: [
                          Text(
                            userData['name'] ?? "No Name",
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
                          Text(
                            userData['email'] ?? "No Email",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _buildInfoSection(userData),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _buildProfileImage(userData),
            ],
          );
        },
      ),
    );
  }
}