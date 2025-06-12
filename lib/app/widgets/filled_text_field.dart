import 'package:flutter/material.dart';

class FilledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon? prefixIcon;
  final int? maxLines;
  final TextInputType? inputType;

  const FilledTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.maxLines,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: maxLines ?? 1,
    );
  }
}
