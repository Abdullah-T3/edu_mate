// user_profile_page.dart
// UI for user profile page

import 'package:edu_mate/core/helper/FormValidator/Validator.dart';
import 'package:flutter/gestures.dart';
import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:edu_mate/features/auth/presentation/widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: deviceinfo.screenHeight * 0.05,
                    horizontal: deviceinfo.screenWidth * 0.05,
                  ),
                  width: deviceinfo.screenWidth * 0.9,
                  constraints: BoxConstraints(
                    maxWidth: deviceinfo.screenWidth * 0.95,
                    minHeight: deviceinfo.screenHeight * 0.8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(
                      deviceinfo.screenWidth * 0.07,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
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
                            ),
                            SizedBox(height: deviceinfo.screenHeight * 0.04),
                            SizedBox(
                              width: double.infinity,
                              height: deviceinfo.screenHeight * 0.07,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [colors.primary, colors.accent],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      deviceinfo.screenWidth * 0.04,
                                    ),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Sign In',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            deviceinfo.screenWidth * 0.045,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: deviceinfo.screenHeight * 0.03),
                            Center(
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  'Forgot Password?',
                                  style: textTheme.labelMedium?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: deviceinfo.screenWidth * 0.04,
                                  ),
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
                                    style: TextStyle(
                                      color: colors.secondaryText,
                                    ),
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
                                  InkWell(
                                    onTap: () {},
                                    child: Text(
                                      'Create Account',
                                      style: textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: deviceinfo.screenWidth * 0.04,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
