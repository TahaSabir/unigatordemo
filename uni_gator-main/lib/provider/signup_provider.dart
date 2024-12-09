// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../screens/update_level/update_class_level.dart';
import '../utils/utils.dart';
import '/data/network_service.dart';

class SignUpProvider with ChangeNotifier {
  // LOGIN
  bool _loginbtn = false;
  bool get isloginbtn => _loginbtn;

  // UPDATE ACCOUNT
  bool _updateAccountbtn = false;
  bool get updateAccountbtn => _updateAccountbtn;

  // STOER USER BUTTON
  bool _updateStoreUserbtn = false;
  bool get updateStoreUserbtn => _updateStoreUserbtn;
  // FORGOT PASSWORD LOADING
  bool _forgotPasswordLoading = false;
  bool get forgotPasswordLoading => _forgotPasswordLoading;

  // PHONE AUTHENTICATION
  bool _phoneAuthenticationLoading = false;
  bool get phoneAuthenticationLoading => _phoneAuthenticationLoading;

  // SET PHONE AUTHENTICATION LOADING
  void setPhoneAuthenticationLoading(bool value) {
    _phoneAuthenticationLoading = value;
    notifyListeners();
  }

  // SET UPDATE ACCOUNT LOADING
  void setUpdateAccountLoading(bool value) {
    _updateAccountbtn = value;
    notifyListeners();
  }

  // SET STORE USER DATA
  void setStoreUserDataLoading(bool value) {
    _updateStoreUserbtn = value;
    notifyListeners();
  }

  // SET FORGOT PASSWORD LOADING
  void setForgotPasswordLoading(bool value) {
    _forgotPasswordLoading = value;
    notifyListeners();
  }

  // SET BUTTON LOGIN LOADING
  void setBtnLoginLoading(bool value) {
    _loginbtn = value;
    notifyListeners();
  }

  // Controllers for the text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Dispose controllers when not in use
  void disposeControllers() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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
    roleController.clear();
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
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

  // CREATE ACCOUNT FOR USER
  Future<void> createUserAccount(
    String email,
    String password,
    UserModel user,
    BuildContext context,
  ) async {
    try {
      setUpdateAccountLoading(true);
      final isCreated = await networkService.createUserWithEmailAndPassword(
        email,
        password,
        user,
        context,
      );
      if (isCreated) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const UpdateClassLevelScreen(),
          ),
        );
      }
    } finally {
      setUpdateAccountLoading(false);
    }
  }

  // CREATE ACCOUNT FOR USER
  Future<void> storeUserDataInDatabase(
    UserModel user,
  ) async {
    try {
      setStoreUserDataLoading(true);
      await networkService.storeUserData(user);
    } finally {
      setStoreUserDataLoading(false);
    }
  }

  // SIGN OUT USER
  Future<void> logoutUser(
    void Function() navigateToNextScreen,
    BuildContext context,
  ) async {
    try {
      await networkService.signOut().then((value) {
        navigateToNextScreen();
        Utils.showSnackBar('Sign out', context);
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message.toString(), context);
    }
  }
}
