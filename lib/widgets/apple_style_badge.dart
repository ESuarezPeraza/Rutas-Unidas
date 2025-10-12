import 'package:flutter/material.dart';
import 'package:myapp/theme/app_theme.dart';

enum BadgeType { primary, secondary, success, warning, error, neutral }

class AppleStyleBadge extends StatelessWidget {
  final String label;
  final BadgeType type;
  final IconData? icon;
  final bool small;

  const AppleStyleBadge({
    Key? key,
    required this.label,
    this.type = BadgeType.neutral,
    this.icon,
    this.small = false,
  }) : super(key: key);

  Color _getBackgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    switch (type) {
      case BadgeType.primary:
        return AppTheme.primaryBlue.withOpacity(isDark ? 0.3 : 0.15);
      case BadgeType.secondary:
        return AppTheme.secondaryPurple.withOpacity(isDark ? 0.3 : 0.15);
      case BadgeType.success:
        return AppTheme.successGreen.withOpacity(isDark ? 0.3 : 0.15);
      case BadgeType.warning:
        return AppTheme.warningOrange.withOpacity(isDark ? 0.3 : 0.15);
      case BadgeType.error:
        return AppTheme.errorRed.withOpacity(isDark ? 0.3 : 0.15);
      case BadgeType.neutral:
        return isDark ? AppTheme.darkSurface2 : AppTheme.gray5;
    }
  }

  Color _getTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    switch (type) {
      case BadgeType.primary:
        return isDark ? AppTheme.primaryBlue : AppTheme.primaryBlue;
      case BadgeType.secondary:
        return isDark ? AppTheme.secondaryPurple : AppTheme.secondaryPurple;
      case BadgeType.success:
        return isDark ? AppTheme.successGreen : AppTheme.successGreen;
      case BadgeType.warning:
        return isDark ? AppTheme.warningOrange : AppTheme.warningOrange;
      case BadgeType.error:
        return isDark ? AppTheme.errorRed : AppTheme.errorRed;
      case BadgeType.neutral:
        return isDark ? AppTheme.gray1 : AppTheme.gray1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor(context);
    final textColor = _getTextColor(context);
    final fontSize = small ? 11.0 : 13.0;
    final horizontalPadding = small ? 8.0 : 12.0;
    final verticalPadding = small ? 4.0 : 6.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize + 2,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: textColor,
              letterSpacing: -0.08,
            ),
          ),
        ],
      ),
    );
  }
}