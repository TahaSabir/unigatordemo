// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '/utils/utils.dart';

class EditUserProvider extends ChangeNotifier {
  Future saveUserCredentials({
    required String email,
    required String username,
    required String phone,
    required String date,
    required String gender,
    required String cnic,
    required String role,
    required String address,
    required BuildContext context,
  }) async {
    final firebaseAuth = FirebaseAuth.instance;

    final user = firebaseAuth.currentUser;
    try {
      final firebaseDatabase = FirebaseDatabase.instance.ref('users');

      await firebaseDatabase.child(user!.uid).set({
        "username": username,
        "userId": user.uid,
        "email": email,
        "address": address,
        "phone": phone,
        "date": date,
        "cninc": cnic,
        "gender": gender,
        "role": role,
        "Timestamp": DateTime.now().toString(),
      }).then(
          (value) => Utils.flushBarErrorMessage("Profile Updated", context));
    } catch (e) {
      Utils.flushBarErrorMessage(e.toString(), context);
    }
  }
}
