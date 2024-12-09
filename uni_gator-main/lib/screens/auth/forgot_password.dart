import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_gator/provider/forget_password_provider.dart';
import 'package:uni_gator/utils/utils.dart';

import '/utils/app_colors.dart';
import '/widgets/app_text_style.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_textformfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Forgot Password",
                    style: AppTextTheme.getLightTextTheme(context).titleLarge,
                  ),
                  const SizedBox(width: 50),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/images/unigatorr.png",
                  height: 100,
                ),
              ),
              const SizedBox(height: 40),
              const WelcomeText(
                title: "Forgot password",
                text:
                    "Enter your email address and we will send you a reset instructions.",
              ),
              const SizedBox(height: 16),
              const ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  final String title, text;

  const WelcomeText({super.key, required this.title, required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({super.key});

  @override
  State<ForgotPassForm> createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email Field
          Consumer<ForgetPasswordProvider>(
            builder: (context, value, child) {
              return CustomTextFormField(
                hintText: 'Email',
                controller: value.emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              );
            },
          ),
          const SizedBox(height: 10),

          // Reset password Button
          Consumer<ForgetPasswordProvider>(
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CustomButton(
                  text: "Continue",
                  isLoading: value.forgotPasswordLoading,
                  onPressed: () async {
                    if (value.emailController.text == "") {
                      Utils.flushBarErrorMessage("Enter Email First", context);
                      return;
                    }
                    await value.sendResetLink(
                      value.emailController.text.toString(),
                      context,
                    );
                  },
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
