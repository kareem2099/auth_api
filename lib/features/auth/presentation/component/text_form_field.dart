import 'dart:async';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final StreamController<String> validationController;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    required this.validationController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            validator: validator,
            focusNode: focusNode,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            onChanged: (value) {
              if (validator != null) {
                validationController.add(validator!(value) ?? '');
              }
            },
          ),
          StreamBuilder<String>(
            stream: validationController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Text(
                  snapshot.data!,
                  style: const TextStyle(color: Colors.red),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
