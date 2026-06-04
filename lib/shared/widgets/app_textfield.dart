import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({super.key, this.controller, this.hintText, this.maxLines = 1, required this.onChanged});

  final TextEditingController? controller;
  final String? hintText;
  final int maxLines;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s.,&/\-()+]'))],
      decoration: InputDecoration(hintText: hintText, border: const OutlineInputBorder()),
    );
  }
}
