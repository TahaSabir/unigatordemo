// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '/data/network_service.dart';

class SignInProvider with ChangeNotifier {
  // LOGIN
  bool _loginbtn = false;
  bool get isloginbtn => _loginbtn;

  // SET BUTTON LOGIN LOADING
  void setBtnLoginLoading(bool value) {
    _loginbtn = value;
    notifyListeners();
  }

  // Controllers for the text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Dispose controllers when not in use
  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  // Method to validate and save form data
  bool validateAndSaveForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      return true;
    }
    return false;
  }

  // Optional: Clear form fields
  void clearForm() {
    emailController.clear();
    passwordController.clear();
  }

  final NetworkService networkService = NetworkService();

  //  SIGN IN USER
  Future<void> signIn(
    String email,
    String password,
    void Function() navigateToNextScreen,
    BuildContext context,
  ) async {
    try {
      setBtnLoginLoading(true);
      bool loggedIn = await networkService.signInWithEmailAndPassword(
        email,
        password,
        context,
      );
      debugPrint(loggedIn.toString());
      if (loggedIn) {
        setBtnLoginLoading(false);
        navigateToNextScreen();
      }
    } finally {
      setBtnLoginLoading(false);
    }
  }
}
