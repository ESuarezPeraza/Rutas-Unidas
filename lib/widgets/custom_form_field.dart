import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool multiline;
  final int lines;
  final TextInputType inputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomFormField({
    super.key,
    required this.label,
    required this.placeholder,
    this.multiline = false,
    this.lines = 1,
    this.inputType = TextInputType.text,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: inputType,
          maxLines: multiline ? lines : 1,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary.withOpacity(0.2)),
            ),
          ),
        ),
      ],
    );
  }
}
