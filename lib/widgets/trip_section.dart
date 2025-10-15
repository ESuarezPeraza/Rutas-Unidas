import 'package:flutter/material.dart';

class TripSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const TripSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Image.network(
                  item['imageUrl']!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                title: Text(item['title']!),
                subtitle: Text(item['subtitle']!),
                trailing: Chip(
                  label: Text(item['tag']!['label']!),
                  backgroundColor: item['tag']!['type']! == 'primary'
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                      : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: item['tag']!['type']! == 'primary'
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
