import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final IconData? icon;
  final String? imageUrl;
  final bool isImageCircular;
  final String title;
  final String subtitle;

  const DetailRow({
    super.key,
    this.icon,
    this.imageUrl,
    this.isImageCircular = false,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, color: Theme.of(context).colorScheme.secondary)
          else if (imageUrl != null)
            isImageCircular
                ? CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl!),
                    radius: 16,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.secondary)),
            ],
          ),
        ],
      ),
    );
  }
}
