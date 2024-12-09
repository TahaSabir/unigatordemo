import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/sign_in_provider.dart';
import '/screens/bottomnav_bar.dart';
import '/utils/app_colors.dart';
import '/widgets/app_text_style.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_textformfield.dart';
import 'forgot_password.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.08),
                    Image.asset(
                      "assets/images/unigatorr.png",
                      height: 100,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                    Center(
                      child: Text(
                        "Sign In",
                        style: AppTextTheme.getLightTextTheme(context)
                            .headlineLarge!
                            .copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.05),
                    Form(
                      key: _formKey,
                      child: Consumer<SignInProvider>(
                        builder: (context, signUpProvider, child) {
                          return Column(
                            children: [
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
                              SizedBox(height: constraints.maxHeight * 0.01),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style:
                                        AppTextTheme.getLightTextTheme(context)
                                            .bodyMedium!
                                            .copyWith(
                                              color: AppColors.primary,
                                            ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              Consumer<SignInProvider>(
                                builder: (context, value, child) =>
                                    CustomButton(
                                  text: "Sign In",
                                  isLoading: value.isloginbtn,
                                  onPressed: () {
                                    value.signIn(
                                      value.emailController.text.toString(),
                                      value.passwordController.text.toString(),
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BottomNavScreen(),
                                          ),
                                        ).then(
                                          (value) => {
                                            value.emailController.clear(),
                                            value.passwordController.clear()
                                          },
                                        );
                                      },
                                      context,
                                    );
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't have an account?",
                                    style:
                                        AppTextTheme.getLightTextTheme(context)
                                            .bodyLarge,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpScreen()));
                                    },
                                    child: Text("Sign Up",
                                        style: AppTextTheme.getLightTextTheme(
                                                context)
                                            .bodyLarge!
                                            .copyWith(
                                                color: AppColors.primary)),
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
      ),
    );
  }
}
