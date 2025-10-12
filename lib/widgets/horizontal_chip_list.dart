import 'package:flutter/material.dart' hide Chip;

import 'custom_chip.dart';

class HorizontalChipList extends StatelessWidget {
  const HorizontalChipList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Row(
        children: const [
          CustomChip(label: Text('Destino')),
          SizedBox(width: 8),
          CustomChip(label: Text('Fecha')),
          SizedBox(width: 8),
          CustomChip(label: Text('Tipo')),
        ],
      ),
    );
  }
}
