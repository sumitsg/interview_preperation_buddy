import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({super.key, this.controller, this.hintText, this.maxLines = 1});

  final TextEditingController? controller;
  final String? hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(hintText: hintText, border: const OutlineInputBorder()),
    );
  }
}
