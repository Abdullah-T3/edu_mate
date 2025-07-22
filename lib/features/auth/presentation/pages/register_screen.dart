import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/helper/FormValidator/Validator.dart';
import 'package:edu_mate/core/helper/cherryToast/CherryToastMsgs.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:edu_mate/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:edu_mate/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:edu_mate/features/auth/presentation/widgets/custom_auth_button.dart';
import 'package:edu_mate/features/auth/presentation/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    String? retypePasswordValidator(String? value) {
      return ValidatorHelper.isPasswordConfirmed(
        context.read<AuthCubit>().passwordController.text,
        value,
      );
    }

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: SafeArea(
        child: InfoWidget(
          builder: (context, deviceinfo) => Center(
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthError) {
                  isLoading = false;
                  CherryToastMsgs.CherryToastError(
                    context: context,
                    info: deviceinfo,
                    title: 'Registration Failed',
                    description: state.message,
                  ).show(context);
                } else if (state is Authenticated) {
                  isLoading = false;
                  String firstName = '';
                  if (state.user.displayName != null &&
                      state.user.displayName!.isNotEmpty) {
                    firstName = state.user.displayName!.split(' ').first;
                  }
                  CherryToastMsgs.CherryToastSuccess(
                    context: context,
                    info: deviceinfo,
                    title: 'Registration Successful',
                    description: 'Welcome to EduMate, $firstName!',
                  ).show(context);
                  GoRouter.of(context).go(Routes.homeScreen);
                } else if (state is AuthLoading) {
                  isLoading = true;
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceinfo.screenWidth * 0.05,
                    vertical: deviceinfo.screenHeight * 0.04,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceinfo.screenWidth * 0.05,
                      vertical: deviceinfo.screenHeight * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'Create Account',
                                style: textTheme.headlineMedium?.copyWith(
                                  fontSize: deviceinfo.screenWidth * 0.06,
                                ),
                              ),
                              SizedBox(height: deviceinfo.screenHeight * 0.01),
                              Text(
                                'Join EduMate and start learning',
                                style: textTheme.titleMedium?.copyWith(
                                  fontSize: deviceinfo.screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: deviceinfo.screenHeight * 0.04),
                        AuthTextFormField(
                          label: 'Full Name',
                          hintText: 'Enter your full name',
                          controller: context
                              .read<AuthCubit>()
                              .fullNameController,
                          prefixIcon: Icons.person_outline,
                          deviceinfo: deviceinfo,
                          validator: ValidatorHelper.isNotEmpty,
                        ),
                        SizedBox(height: deviceinfo.screenHeight * 0.025),
                        AuthTextFormField(
                          label: 'Email',
                          hintText: 'Enter your email',
                          controller: context.read<AuthCubit>().emailController,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          deviceinfo: deviceinfo,
                          validator: ValidatorHelper.combineValidators([
                            ValidatorHelper.isNotEmpty,
                            ValidatorHelper.isValidEmail,
                          ]),
                        ),
                        SizedBox(height: deviceinfo.screenHeight * 0.025),
                        AuthTextFormField(
                          label: 'Password',
                          hintText: 'Create a password',
                          controller: context
                              .read<AuthCubit>()
                              .passwordController,
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                          deviceinfo: deviceinfo,
                          validator: ValidatorHelper.combineValidators([
                            ValidatorHelper.isNotEmpty,
                            ValidatorHelper.isValidPassword,
                          ]),
                        ),
                        SizedBox(height: deviceinfo.screenHeight * 0.025),
                        AuthTextFormField(
                          label: 'Confirm Password',
                          hintText: 'Confirm your password',
                          controller: context
                              .read<AuthCubit>()
                              .confirmPasswordController,
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                          deviceinfo: deviceinfo,
                          validator: ValidatorHelper.combineValidators([
                            ValidatorHelper.isNotEmpty,
                            retypePasswordValidator,
                          ]),
                        ),
                        SizedBox(height: deviceinfo.screenHeight * 0.035),
                        customAuthButton(
                          isLoading: isLoading,
                          text: 'Create Account',
                          onPressed: () {
                            context.read<AuthCubit>().register();
                          },
                          theme: Theme.of(context),
                          colors: colors,
                          textTheme: textTheme,
                          deviceinfo: deviceinfo,
                        ),
                        SizedBox(height: deviceinfo.screenHeight * 0.02),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'By creating an account, you agree to our Terms of Service and Privacy Policy',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.tertiaryText,
                                  fontSize: deviceinfo.screenWidth * 0.03,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: deviceinfo.screenHeight * 0.02),
                              Divider(),
                              SizedBox(height: deviceinfo.screenHeight * 0.01),
                              Text(
                                'Already have an account?',
                                style: textTheme.titleMedium?.copyWith(
                                  fontSize: deviceinfo.screenWidth * 0.04,
                                ),
                              ),
                              customTextButton(
                                text: 'Sign In',
                                onPressed: () {
                                  GoRouter.of(context).go(Routes.loginScreen);
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
