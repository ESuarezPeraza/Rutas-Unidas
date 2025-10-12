import 'package:flutter/material.dart';

class ImagePicker extends StatelessWidget {
  final String label;
  final IconData icon;
  final double aspectRatio;
  final String backgroundImageUrl;
  final Function(String)? onImageSelected;

  const ImagePicker({
    super.key,
    required this.label,
    required this.icon,
    this.aspectRatio = 16 / 9,
    required this.backgroundImageUrl,
    this.onImageSelected,
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
          child: InkWell(
            onTap: () {
              // Por ahora solo mostramos un mensaje
              // TODO: Implementar selección de imagen real
              if (onImageSelected != null) {
                // Simular selección de imagen con URL de placeholder
                onImageSelected!('https://via.placeholder.com/300x200?text=Imagen+Seleccionada');
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(backgroundImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Toca para cambiar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
