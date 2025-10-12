import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/apple_style_card.dart';
import 'package:myapp/widgets/apple_style_badge.dart';

class TripCardApple extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String? badgeLabel;
  final BadgeType? badgeType;
  final VoidCallback? onTap;

  const TripCardApple({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.badgeLabel,
    this.badgeType,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppleStyleCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppTheme.spacing12),
      child: Row(
        children: [
          // Imagen con bordes redondeados
          Hero(
            tag: 'trip-image-$title',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Container(
                width: 100,
                height: 75,
                decoration: BoxDecoration(
                  color: AppTheme.gray5,
                ),
                child: Image.network(
                  imageUrl,
                  width: 100,
                  height: 75,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppTheme.gray5,
                      child: const Icon(
                        CupertinoIcons.photo,
                        color: AppTheme.gray2,
                        size: 30,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppTheme.gray5,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.gray2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing16),
          
          // Información del viaje
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacing4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.gray1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Badge
          if (badgeLabel != null && badgeType != null) ...[
            const SizedBox(width: AppTheme.spacing12),
            AppleStyleBadge(
              label: badgeLabel!,
              type: badgeType!,
            ),
          ],
          
          // Flecha indicadora
          const SizedBox(width: AppTheme.spacing8),
          Icon(
            CupertinoIcons.chevron_forward,
            size: 16,
            color: AppTheme.gray2,
          ),
        ],
      ),
    );
  }
}