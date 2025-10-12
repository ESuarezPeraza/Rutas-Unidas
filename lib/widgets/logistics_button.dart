import 'package:flutter/material.dart';

class LogisticsButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String actionText;

  const LogisticsButton({
    super.key,
    required this.icon,
    required this.title,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const Spacer(),
          Text(actionText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
          Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}
