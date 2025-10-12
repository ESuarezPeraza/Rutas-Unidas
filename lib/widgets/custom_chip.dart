import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Widget label;
  const CustomChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: label,
      ),
    );
  }
}
