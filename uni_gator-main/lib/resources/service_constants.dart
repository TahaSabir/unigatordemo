import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = FirebaseAuth.instance.currentUser;
final DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref().child('users');

DatabaseReference usersDatabase = FirebaseDatabase.instance.ref('users');

final CollectionReference<Map<String, dynamic>> userCollection =
    FirebaseFirestore.instance.collection('users');

final FirebaseFirestore firestore = FirebaseFirestore.instance;
