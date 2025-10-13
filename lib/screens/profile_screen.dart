import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/trips_provider.dart';
import 'package:myapp/widgets/experience_bar.dart';
import 'package:myapp/widgets/profile_header.dart';
import 'package:myapp/widgets/trip_history.dart';
import 'package:myapp/models/trip.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
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

    final user = authProvider.currentUser!;
    final userTrips = tripsProvider.userTrips;

    // Separar viajes pasados y futuros
    final pastTrips = userTrips.where((trip) => trip.isPast).toList();
    final futureTrips = userTrips.where((trip) => trip.isUpcoming || trip.isCurrent).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Perfil',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ProfileHeader(
                avatarUrl: user.avatarUrl ?? 'https://picsum.photos/150/150?random=${user.id.hashCode}',
                name: user.name ?? user.email.split('@')[0],
                role: user.role ?? 'Viajero',
                memberSince: 'Miembro desde ${user.createdAt.year}',
              ),
              const SizedBox(height: 32),
              ExperienceBar(
                label: 'Nivel de Experiencia',
                experience: user.experience,
              ),
              const SizedBox(height: 32),
              if (tripsProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                TripHistory(
                  title: 'Viajes',
                  tabs: ['Pasados (${pastTrips.length})', 'Futuros (${futureTrips.length})'],
                  activeTab: 0,
                  trips: [
                    // Viajes pasados
                    ...pastTrips.map((trip) => {
                      'imageUrl': trip.imageUrl ?? 'https://picsum.photos/300/200?random=${trip.id.hashCode}',
                      'title': trip.title,
                      'subtitle': trip.formattedDate,
                    }).toList(),
                    // Viajes futuros
                    ...futureTrips.map((trip) => {
                      'imageUrl': trip.imageUrl ?? 'https://picsum.photos/300/200?random=${trip.id.hashCode}',
                      'title': trip.title,
                      'subtitle': trip.formattedDate,
                    }).toList(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
