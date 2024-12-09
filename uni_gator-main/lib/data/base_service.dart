import 'package:flutter/material.dart';

import '/model/user_model.dart';

abstract class BaseService {
  // SIGN IN WITH EMAIL AND PASSWORD
  Future<bool> signInWithEmailAndPassword(
      String email, String password, BuildContext context);

  // CREATE USER WITH EMAIL AND PASSWORD
  Future<bool> createUserWithEmailAndPassword(
    String email,
    String password,
    UserModel user,
    BuildContext context,
  );

  // VERIFY THE OTP
  Future<void> verifyOtp(String verificationId, String otp, String phoneNum);

  // SIGN OUT
  Future<void> signOut();

  Future<void> sendResetEmailToUser(String email, BuildContext context);

  Future<void> sendResetPasswordEmail(String email);

  // STORE USER DATA
  Future<void> storeUserData(UserModel user);

  Future<void> saveUserDataToSharedPreferences(UserModel user);

  // [GET USER DATA FROM DEVICE]
  Future<UserModel?> getUserDataFromSharedPreferences();

  // [FETCH USER DATA]
  Future<UserModel?> fetchUserData(String userId);
}
