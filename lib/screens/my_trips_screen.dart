import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/trips_provider.dart';
import 'package:myapp/widgets/trip_section.dart';
import 'package:myapp/models/trip.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserTrips();
  }

  Future<void> _loadUserTrips() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tripsProvider = Provider.of<TripsProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      await tripsProvider.loadUserTrips(authProvider.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final tripsProvider = Provider.of<TripsProvider>(context);

    if (authProvider.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Usuario no autenticado'),
        ),
      );
    }

    final userTrips = tripsProvider.userTrips;

    // Separar viajes por estado
    final upcomingTrips = userTrips.where((trip) =>
      trip.isUpcoming || trip.isCurrent).toList();
    final pastTrips = userTrips.where((trip) => trip.isPast).toList();

    // Convertir a formato para TripSection
    final upcomingTripItems = upcomingTrips.map((trip) {
      final isOrganizer = trip.organizerId == authProvider.currentUser!.id;
      return {
        'imageUrl': trip.imageUrl ?? 'https://picsum.photos/300/200?random=${trip.id.hashCode}',
        'title': trip.title,
        'subtitle': trip.formattedDate,
        'tag': {
          'label': isOrganizer ? 'Organizador' : 'Participante',
          'type': isOrganizer ? 'primary' : 'neutral'
        }
      };
    }).toList();

    final pastTripItems = pastTrips.map((trip) {
      final isOrganizer = trip.organizerId == authProvider.currentUser!.id;
      return {
        'imageUrl': trip.imageUrl ?? 'https://picsum.photos/300/200?random=${trip.id.hashCode}',
        'title': trip.title,
        'subtitle': trip.formattedDate,
        'tag': {
          'label': isOrganizer ? 'Organizador' : 'Participante',
          'type': isOrganizer ? 'primary' : 'neutral'
        }
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mis Viajes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: tripsProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  if (upcomingTripItems.isNotEmpty)
                    TripSection(
                      title: 'Viajes Programados (${upcomingTripItems.length})',
                      items: upcomingTripItems,
                    ),
                  if (upcomingTripItems.isNotEmpty && pastTripItems.isNotEmpty)
                    const SizedBox(height: 32),
                  if (pastTripItems.isNotEmpty)
                    Opacity(
                      opacity: 0.7,
                      child: TripSection(
                        title: 'Viajes Realizados (${pastTripItems.length})',
                        items: pastTripItems,
                      ),
                    ),
                  if (upcomingTripItems.isEmpty && pastTripItems.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'Aún no tienes viajes.\n¡Crea uno o únete a uno existente!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
    );
  }
}
