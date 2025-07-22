import 'package:edu_mate/core/helper/FormValidator/Validator.dart';
import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:edu_mate/features/auth/presentation/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:edu_mate/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: SafeArea(
        child: InfoWidget(
          builder: (context, deviceinfo) => Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: deviceinfo.screenHeight * 0.045,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(deviceinfo.screenWidth * 0.07),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back',
                          style: textTheme.headlineMedium?.copyWith(
                            fontSize: deviceinfo.screenWidth * 0.065,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue learning',
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: deviceinfo.screenWidth * 0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceinfo.screenWidth * 0.05,
                      vertical: deviceinfo.screenHeight * 0.04,
                    ),
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AuthTextFormField(
                            label: 'Email',
                            hintText: 'Enter your email',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            deviceinfo: deviceinfo,
                            validator: ValidatorHelper.combineValidators([
                              ValidatorHelper.isNotEmpty,
                              ValidatorHelper.isValidEmail,
                            ]),
                            controller: context
                                .read<AuthCubit>()
                                .emailController,
                          ),
                          SizedBox(height: deviceinfo.screenHeight * 0.04),
                          AuthTextFormField(
                            label: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: true,
                            deviceinfo: deviceinfo,
                            validator: ValidatorHelper.combineValidators([
                              ValidatorHelper.isNotEmpty,
                              ValidatorHelper.isValidPassword,
                            ]),
                            controller: context
                                .read<AuthCubit>()
                                .passwordController,
                          ),
                          SizedBox(height: deviceinfo.screenHeight * 0.04),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                minimumSize: Size(
                                  deviceinfo.screenWidth * 0.8,
                                  deviceinfo.screenHeight * 0.06,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    deviceinfo.screenWidth * 0.05,
                                  ),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [colors.primary, colors.accent],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    deviceinfo.screenWidth * 0.03,
                                  ),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: deviceinfo.screenWidth * 0.8,
                                  height: deviceinfo.screenHeight * 0.06,
                                  child: Text(
                                    'Login',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontSize: deviceinfo.screenWidth * 0.05,
                                      color: colors.scaffoldBackground,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: deviceinfo.screenHeight * 0.03),
                          Center(
                            child: customTextButton(
                              onPressed: () {},
                              text: 'Forgot Password?',
                              width: deviceinfo.screenWidth * 0.5,
                              height: deviceinfo.screenHeight * 0.06,
                              textStyle: textTheme.bodyMedium?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: deviceinfo.screenWidth * 0.04,
                              ),
                            ),
                          ),
                          SizedBox(height: deviceinfo.screenHeight * 0.02),
                          Row(
                            children: [
                              Expanded(child: Divider(endIndent: 8.0)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: deviceinfo.screenWidth * 0.02,
                                ),
                                child: Text(
                                  'or',
                                  style: TextStyle(color: colors.secondaryText),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          SizedBox(height: deviceinfo.screenHeight * 0.02),
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: textTheme.titleMedium?.copyWith(
                                    fontSize: deviceinfo.screenWidth * 0.04,
                                  ),
                                ),
                                SizedBox(
                                  height: deviceinfo.screenHeight * 0.02,
                                ),
                                customTextButton(
                                  text: 'Create Account',
                                  onPressed: () {
                                    // Navigate to the registration screen
                                    // context.push(Routes.registrationScreen);
                                  },
                                  width: deviceinfo.screenWidth * 0.5,
                                  height: deviceinfo.screenHeight * 0.06,
                                  textStyle: textTheme.bodyMedium?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: deviceinfo.screenWidth * 0.04,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
