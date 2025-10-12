import 'package:flutter/material.dart';
import 'package:myapp/widgets/detail_row.dart';
import 'package:myapp/widgets/hero_image.dart';
import 'package:myapp/widgets/logistics_button.dart';
import 'package:myapp/widgets/section_header.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Viaje a la Gran Sabana',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeroImage(
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD3CQicQ8NfRkIOEZjmbOi12_2zG1mOc5pF4y6aZTsQ4r22H_jbvtMCo3OjBXSkBLpr3wfQlaxdEgptsYNByIpowPr0CX3bKDa-50rRShKMG5lRmaasAVSBw6Bof0HbTKlOvQ2REZteR2pJd2fmWZYx8Qdi7NegNj2pJzHKlUAYKa0QvHi9KLMzzXq3LWrJnU7ILr9I5w0GRmKeZ5uPdH89BvDja-XnbtaTJLI70me8O58Daf64frYSqEw7U3pBsaZlHAzFVM5-kmV1',
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SectionHeader(title: 'Detalles del Viaje'),
                  SizedBox(height: 16),
                  DetailRow(
                    icon: Icons.calendar_today,
                    title: 'Fecha y Hora',
                    subtitle: '15 de Julio, 8:00 AM',
                  ),
                  DetailRow(
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDVUWNetDgR_Rqw2JpL7rWLvUB39MKeED4xioy4Aj5dSFpBdivWYXTOXrApE5c0J_lRyjvlRkQEeSjOL_cXjQdGiq_Usyl3939hBaN3bP9j0K5J9GEybwJ5el1JJ4Dyn5wSYejChmIl4NppRDmxJW3SjJCr5pQ7r0B7pJZHHgE4W-JKYx9x8Rme7gWbT4IGc-_R-vyvgxKRwhh7rC5kRDjTjQhumSsP2R3oHnf3qqB7Z7P36hNW58jGIgMNd-Q_FB0yuuCUaqYaA82E',
                    isImageCircular: true,
                    title: 'Organizador',
                    subtitle: 'Ricardo Mendoza',
                  ),
                  DetailRow(
                    icon: Icons.group,
                    title: 'Participantes',
                    subtitle: '12 participantes',
                  ),
                  SizedBox(height: 24),
                  SectionHeader(title: 'Logística'),
                  SizedBox(height: 8),
                  LogisticsButton(
                    icon: Icons.fastfood,
                    title: 'Comida',
                    actionText: 'Ver',
                  ),
                  LogisticsButton(
                    icon: Icons.luggage,
                    title: 'Equipaje',
                    actionText: 'Ver',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Unirse al Viaje', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Contactar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
