import 'package:flutter/material.dart';

class ImagePicker extends StatelessWidget {
  final String label;
  final IconData icon;
  final double aspectRatio;
  final String backgroundImageUrl;

  const ImagePicker({
    super.key,
    required this.label,
    required this.icon,
    this.aspectRatio = 16 / 9,
    required this.backgroundImageUrl,
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
        AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(backgroundImageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 48,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
