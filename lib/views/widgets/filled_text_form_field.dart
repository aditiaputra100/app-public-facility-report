import 'package:flutter/material.dart';

class FilledTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? obscureText;
  final Icon prefixIcon;
  final Widget? suffixIcon;
  final String? error;
  final TextInputType? inputType;
  final FormFieldValidator<String> validator;

  const FilledTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText,
    this.error,
    this.inputType,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText ?? false,
      keyboardType: inputType,
      decoration: InputDecoration(
        errorText: error,
        isDense: true,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );
  }
}
