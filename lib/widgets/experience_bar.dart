import 'package:flutter/material.dart';
import '../services/experience_service.dart';

class ExperienceBar extends StatelessWidget {
  final String label;
  final int experience;
  final bool showLevel;

  const ExperienceBar({
    super.key,
    required this.label,
    required this.experience,
    this.showLevel = true,
  });

  @override
  Widget build(BuildContext context) {
    final level = ExperienceService.calculateLevel(experience);
    final progress = ExperienceService.levelProgress(experience);
    final nextLevelExp = ExperienceService.experienceForNextLevel(level);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              showLevel ? '$label - Nivel $level' : label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '$experience/$nextLevelExp XP',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Theme.of(context).colorScheme.surface,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        if (showLevel) ...[
          const SizedBox(height: 4),
          Text(
            'Próximo nivel: ${nextLevelExp - experience} XP más',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }
}
