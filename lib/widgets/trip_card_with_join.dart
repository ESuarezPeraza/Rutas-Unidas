import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip.dart';
import '../providers/auth_provider.dart';
import '../providers/trips_provider.dart';

class TripCardWithJoin extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onJoinPressed;

  const TripCardWithJoin({
    super.key,
    required this.trip,
    this.onJoinPressed,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final tripsProvider = Provider.of<TripsProvider>(context);

    // Verificar si el usuario actual ya está participando
    final isCurrentUserOrganizer = authProvider.currentUser?.id == trip.organizerId;
    final isCurrentUserParticipant = tripsProvider.userTrips.any((userTrip) => userTrip.id == trip.id);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del viaje
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              trip.imageUrl ?? 'https://via.placeholder.com/300x200',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 150,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                );
              },
            ),
          ),

          // Contenido del card
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título y fecha
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        trip.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      trip.formattedDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Organizador
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Organizado por: ${trip.organizer?.name ?? 'Usuario'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Botón de unirse o estado
                SizedBox(
                  width: double.infinity,
                  child: _buildActionButton(context, isCurrentUserOrganizer, isCurrentUserParticipant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, bool isOrganizer, bool isParticipant) {
    if (isOrganizer) {
      // El usuario es el organizador
      return ElevatedButton.icon(
        onPressed: null, // No clickable
        icon: const Icon(Icons.star, size: 16),
        label: const Text('Eres el organizador'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade100,
          foregroundColor: Colors.amber.shade800,
          elevation: 0,
        ),
      );
    } else if (isParticipant) {
      // El usuario ya está participando
      return ElevatedButton.icon(
        onPressed: null, // No clickable
        icon: const Icon(Icons.check, size: 16),
        label: const Text('Ya estás participando'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade100,
          foregroundColor: Colors.green.shade800,
          elevation: 0,
        ),
      );
    } else {
      // El usuario puede unirse
      return ElevatedButton.icon(
        onPressed: onJoinPressed,
        icon: const Icon(Icons.add, size: 16),
        label: const Text('Unirme al viaje'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );
    }
  }
}