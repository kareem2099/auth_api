import 'dart:async';
import 'dart:io';
import 'package:auth_api/features/auth/presentation/component/error_handler.dart';
import 'package:auth_api/features/auth/presentation/component/permission_handler.dart';
import 'package:auth_api/features/auth/presentation/component/secure_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/auth_bloc.dart';
import '../component/text_form_field.dart';
import '../component/validator.dart';

class UpdateUserScreen extends StatefulWidget {
  static const String routeName = '/update';

  const UpdateUserScreen({super.key});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update User')),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationLoading) {
            _showLoadingDialog(context);
          } else {
            _hideLoadingDialog(context);
          }
          if (state is UserUpdateError) {
            handleError(context, state.message);
          } else if (state is UserUpdateSuccess) {
            Navigator.pop(context);
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
                      FocusScope.of(context).requestFocus(phoneFocusNode);
                    },
                    validationController: nameValidationController,
                  ),
                  CustomTextFormField(
                    controller: phoneController,
                    label: 'Phone',
                    validator: validatePhone,
                    focusNode: phoneFocusNode,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(locNameFocusNode);
                    },
                    validationController: phoneValidationController,
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
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final token = await SecureStorageHelper.readToken();
                        if (token != null) {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            UpdateUserEvent(
                              name: nameController.text,
                              phone: phoneController.text,
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
                      }
                    },
                    child: const Text('Update'),
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