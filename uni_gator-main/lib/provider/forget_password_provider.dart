// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/data/network_service.dart';
import '/utils/utils.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  // FORGOT PASSWORD LOADING
  bool _forgotPasswordLoading = false;
  bool get forgotPasswordLoading => _forgotPasswordLoading;

  // SET FORGOT PASSWORD LOADING
  void setForgotPasswordLoading(bool value) {
    _forgotPasswordLoading = value;
    notifyListeners();
  }

  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  final NetworkService networkService = NetworkService();

  // SEND RESET LINK
  Future<void> sendResetLink(String email, BuildContext context) async {
    try {
      setForgotPasswordLoading(true);
      await networkService.sendResetEmailToUser(email, context).then((value) {
        setForgotPasswordLoading(false);
      });
      Utils.flushBarErrorMessage("Check your Email", context);
    } on FirebaseAuthException catch (e) {
      setForgotPasswordLoading(false);
      log("Error: ${e.message}");
      Utils.flushBarErrorMessage(e.message.toString(), context);
    }
  }
}
