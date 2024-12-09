import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_gator/model/user_model.dart';

import '/provider/signup_provider.dart';
import '/utils/app_colors.dart';
import '/widgets/app_text_style.dart';
import '/widgets/custom_textformfield.dart';
import 'sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TOP HEADER WIDGET
                  _topHeaderWidget(constraints, context),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Consumer<SignUpProvider>(
                      builder: (context, signUpProvider, child) {
                        return Column(
                          children: [
                            //Select Role
                            CustomTextFormField(
                              hintText: 'Select Role',
                              controller: signUpProvider.roleController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            // Full Name
                            CustomTextFormField(
                              hintText: 'Full Name',
                              controller: signUpProvider.fullNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            // Email
                            CustomTextFormField(
                              hintText: 'Email',
                              controller: signUpProvider.emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            // Phone
                            CustomTextFormField(
                              hintText: 'Phone',
                              controller: signUpProvider.phoneController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            // Password
                            CustomTextFormField(
                              hintText: 'Password',
                              keyboardType: TextInputType.visiblePassword,
                              controller: signUpProvider.passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            Consumer<SignUpProvider>(
                              builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        UserModel user = UserModel(
                                          email: signUpProvider
                                              .emailController.text
                                              .toString(),
                                          name: signUpProvider
                                              .fullNameController.text
                                              .toString(),
                                          phone: signUpProvider
                                              .phoneController.text
                                              .toString(),
                                          imageUrl: "",
                                          uid: "",
                                          userType: signUpProvider
                                              .roleController.text
                                              .toString(),
                                        );

                                        await signUpProvider.createUserAccount(
                                          signUpProvider.emailController.text
                                              .toString()
                                              .toString(),
                                          signUpProvider.passwordController.text
                                              .toString()
                                              .toString(),
                                          user,
                                          context,
                                        );
                                        signUpProvider.clearForm();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      minimumSize:
                                          const Size(double.infinity, 48),
                                      shape: const StadiumBorder(),
                                    ),
                                    child: value.updateAccountbtn
                                        ? const SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text("Sign Up"),
                                  ),
                                );
                              },
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account?",
                                  style: AppTextTheme.getLightTextTheme(context)
                                      .bodyLarge,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignInScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Sign in",
                                    style:
                                        AppTextTheme.getLightTextTheme(context)
                                            .bodyLarge!
                                            .copyWith(
                                              color: AppColors.primary,
                                            ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Column _topHeaderWidget(BoxConstraints constraints, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: constraints.maxHeight * 0.08),
        Image.asset(
          "assets/images/unigatorr.png",
          height: 100,
        ),
        SizedBox(height: constraints.maxHeight * 0.02),
        Center(
          child: Text("Sign Up",
              style: AppTextTheme.getLightTextTheme(context).headlineLarge),
        ),
      ],
    );
  }
}
