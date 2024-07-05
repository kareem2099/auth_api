import 'dart:async';

import 'package:auth_api/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../component/password_form_field.dart';
import '../component/text_form_field.dart';
import '../component/validator.dart';
import 'reg_screen.dart'; // Import the registration screen

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const String routeName = '/login';

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final StreamController<String> emailValidationController = StreamController<String>.broadcast();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationLoading) {
              _showLoadingDialog(context);
            } else {
              _hideLoadingDialog(context);
            }

            if (state is AuthenticationError) {
              if (state.message == "User not found. Please register.") {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('User Not Found'),
                    content: const Text(
                        'This email is not registered. Would you like to register?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, RegistrationScreen.routeName);
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            } else if (state is AuthenticationSuccess) {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            }
          },
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: emailController,
                      label: 'Email',
                      validator: validateEmail,
                      focusNode: emailFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                      validationController: emailValidationController,
                    ),
                    PasswordFormField(
                      controller: passwordController,
                      label: 'Password',
                      validator: validateLoginPassword,
                      focusNode: passwordFocusNode,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            LoginEvent(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RegistrationScreen.routeName);
                      },
                      child: const Text("Don't have an account? Register"),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
