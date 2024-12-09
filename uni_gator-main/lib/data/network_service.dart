// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../resources/service_constants.dart';
import '/data/base_service.dart';
import '/utils/utils.dart';

class NetworkService extends BaseService {
  // CREATE USER WITH EMAIL & PASSWORD
  @override
  Future<bool> createUserWithEmailAndPassword(
    String email,
    String password,
    UserModel user,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      user.uid = uid;

      await storeUserData(user);

      Utils.flushBarErrorMessage("Account Created", context);
      return true;
    } on FirebaseAuthException catch (error) {
      String errorMessage;
      switch (error.code) {
        case 'email-already-in-use':
          errorMessage =
              "The email address is already in use by another account.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        case 'operation-not-allowed':
          errorMessage =
              "Email/password accounts are not enabled. Please contact support.";
          break;
        case 'weak-password':
          errorMessage =
              "The password is too weak. Please choose a stronger password.";
          break;
        case 'user-disabled':
          errorMessage =
              "This user account has been disabled. Please contact support.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many requests. Please try again later.";
          break;
        case 'network-request-failed':
          errorMessage =
              "Network error occurred. Please check your internet connection.";
          break;
        default:
          errorMessage = error.message.toString();
          break;
      }

      Utils.flushBarErrorMessage(errorMessage, context);
      return false;
    }
  }

  // SEND RESET EMAIL TO USER
  @override
  Future<void> sendResetEmailToUser(String email, BuildContext context) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      log("Error: ${e.message}");

      Utils.flushBarErrorMessage(e.message.toString(), context);
    }
  }

  @override
  Future<bool> signInWithEmailAndPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Utils.flushBarErrorMessage("Logged in", context);
      return auth.currentUser != null;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      log("Error: ${e.message} Code: ${e.code}");

      switch (e.code) {
        case 'invalid-email':
          errorMessage = "The email address is badly formatted.";
          break;
        case 'user-disabled':
          errorMessage = "This user account has been disabled.";
          break;
        case 'user-not-found':
          errorMessage = "No user found with this email address.";
          break;
        case 'invalid-credential':
          errorMessage = "The password is incorrect. Please try again.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many login attempts. Please try again later.";
          break;
        case 'network-request-failed':
          errorMessage =
              "Network error. Please check your internet connection.";
          break;
        default:
          errorMessage = e.message.toString();
          break;
      }

      Utils.flushBarErrorMessage(errorMessage.toString(), context);
      debugPrint(e.message);
      return false;
    }
  }

  // SIGN OUT
  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> storeUserData(UserModel user) async {
    try {
      await userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(user.toMap());
    } catch (error) {
      rethrow;
    }
  }

  // Verify OTP
  @override
  Future<void> verifyOtp(
    String verificationId,
    String otp,
    String phoneNum,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential).then((value) async {
        debugPrint("User: $value");
      });
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
    }
  }

  // Send Reset Password Email
  @override
  Future<void> sendResetPasswordEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
    }
  }

  // [SAVE USER DATA TO SHARED PREFERENCES]
  @override
  Future<void> saveUserDataToSharedPreferences(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }

  // [GET USER DATA FROM SHARED PREFERENCES]
  @override
  Future<UserModel?> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    UserModel? user;
    try {
      if (userJson != null) {
        debugPrint("Retrieved user data from SharedPreferences: $userJson");
        Map<String, dynamic> userMap = jsonDecode(userJson);
        user = UserModel.fromMap(userMap);
        debugPrint("User email: ${user.email}");
      } else {
        debugPrint("No user data found in SharedPreferences");
      }
    } catch (e) {
      debugPrint("Error retrieving user data: $e");
    }
    return user;
  }

  @override
  Future<UserModel?> fetchUserData(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
