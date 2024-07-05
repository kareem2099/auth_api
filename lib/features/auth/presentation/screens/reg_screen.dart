import 'dart:async';
import 'dart:io';

import 'package:auth_api/features/auth/presentation/component/permission_handler.dart';
import 'package:auth_api/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../bloc/auth_bloc.dart';
import '../component/password_form_field.dart';
import '../component/text_form_field.dart';
import '../component/validator.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController coordinatesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _profileImage;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confPasswordFocusNode = FocusNode();
  final FocusNode locNameFocusNode = FocusNode();
  final FocusNode locAdressFocusNode = FocusNode();
  final FocusNode locCoorFocusNode = FocusNode();
  final StreamController<String> emailValidationController =
      StreamController<String>.broadcast();
  final StreamController<String> nameValidationController =
      StreamController<String>.broadcast();
  final StreamController<String> phoneValidationController =
      StreamController<String>.broadcast();
  final StreamController<String> locNameValidationController =
      StreamController<String>.broadcast();
  final StreamController<String> locAdressValidationController =
      StreamController<String>.broadcast();
  final StreamController<String> locCoorValidationController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    locationNameController.dispose();
    addressController.dispose();
    coordinatesController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    confPasswordFocusNode.dispose();
    locNameFocusNode.dispose();
    locAdressFocusNode.dispose();
    locCoorFocusNode.dispose();
    emailValidationController.close();
    nameValidationController.close();
    phoneValidationController.close();
    locNameValidationController.close();
    locAdressValidationController.close();
    locCoorValidationController.close();
    super.dispose();
  }

  Future<void> _pickImage() async {
    bool hasPermission = await PermissionHandlerUtil.requestStoragePermission();

    if (hasPermission) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Storage Permission Required'),
          content: const Text(
              'This app needs storage access to upload images. Please grant the permission.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                PermissionHandlerUtil.openAppSettings();
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    bool hasPermission =
        await PermissionHandlerUtil.requestLocationPermission();

    if (hasPermission) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          locationNameController.text = place.country ?? '';
          addressController.text =
              '${place.street}, ${place.locality}, ${place.country}';
          coordinatesController.text =
              '${position.latitude}, ${position.longitude}';
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'This app needs location access to auto-fill your location details. Please grant the permission.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                PermissionHandlerUtil.openAppSettings();
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationLoading) {
            _showLoadingDialog(context);
          } else {
            _hideLoadingDialog(context);
          }

          if (state is AuthenticationError) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Registration Error'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else if (state is AuthenticationSuccess) {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: nameController,
                    label: 'Name',
                    validator: validateName,
                    focusNode: nameFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(emailFocusNode);
                    },
                    validationController: nameValidationController,
                  ),
                  CustomTextFormField(
                    controller: emailController,
                    label: 'Email',
                    validator: validateEmail,
                    focusNode: emailFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(phoneFocusNode);
                    },
                    validationController: emailValidationController,
                  ),
                  CustomTextFormField(
                    controller: phoneController,
                    label: 'Phone',
                    validator: validatePhone,
                    focusNode: phoneFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    },
                    validationController: phoneValidationController,
                  ),
                  PasswordFormField(
                    controller: passwordController,
                    label: 'Password',
                    validator: validateRegistrationPassword,
                    focusNode: passwordFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(confPasswordFocusNode);
                    },
                  ),
                  PasswordFormField(
                    controller: confirmPasswordController,
                    label: 'Confirm Password',
                    validator: (value) =>
                        validateConfirmPassword(value, passwordController.text),
                    focusNode: confPasswordFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(locNameFocusNode);
                    },
                  ),
                  CustomTextFormField(
                    controller: locationNameController,
                    label: 'Location Name',
                    validator: validateLocName,
                    focusNode: locNameFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(locAdressFocusNode);
                    },
                    validationController: locNameValidationController,
                  ),
                  CustomTextFormField(
                    controller: addressController,
                    label: 'Location Address',
                    validator: validateAddress,
                    focusNode: locAdressFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(locCoorFocusNode);
                    },
                    validationController: locAdressValidationController,
                  ),
                  CustomTextFormField(
                    controller: coordinatesController,
                    label: 'Location Coordinates (comma separated)',
                    validator: validateCoordinates,
                    focusNode: locCoorFocusNode,
                    textInputAction: TextInputAction.done,
                    validationController: locCoorValidationController,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Upload Profile Image'),
                  ),
                  if (_profileImage != null)
                    Image.file(
                      _profileImage!,
                      height: 100,
                      width: 100,
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          RegisterEvent(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
                            location: {
                              'name': locationNameController.text,
                              'address': addressController.text,
                              'coordinates': coordinatesController.text
                                  .split(',')
                                  .map((e) => double.parse(e.trim()))
                                  .toList(),
                            },
                            profilePic: _profileImage,
                          ),
                        );
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
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
