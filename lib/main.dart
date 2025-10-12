import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/cupertino.dart';
import 'package:myapp/config/supabase_config.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/trips_provider.dart';
import 'package:myapp/screens/create_trip_screen.dart';
import 'package:myapp/screens/my_trips_screen.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/auth_wrapper.dart';
import 'package:myapp/widgets/trip_card_with_join.dart';
import 'package:myapp/services/storage_service.dart';
import 'package:provider/provider.dart';

import 'widgets/header.dart';
import 'widgets/horizontal_chip_list.dart';
import 'widgets/search_bar.dart';
import 'widgets/section_header.dart';
import 'widgets/trip_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  await StorageService.initializeStorage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => TripsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Rutas Unidas',
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: themeProvider.themeMode,
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ExploreScreen(),
    const MyTripsScreen(),
    const CreateTripScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerTheme.color ?? AppTheme.gray4,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search),
              label: 'Explorar',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.map),
              label: 'Mis Viajes',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.add_circled),
              label: 'Crear Viaje',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Perfil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: AppTheme.gray1,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Inicializar animaciones con un item básico
    _updateAnimations(4); // Header, SearchBar, ChipList, SectionHeader
    _animationController.forward();

    // Cargar datos iniciales después de que el widget esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tripsProvider = Provider.of<TripsProvider>(context, listen: false);

    if (authProvider.isAuthenticated && authProvider.currentUser != null) {
      await tripsProvider.loadUserTrips(authProvider.currentUser!.id);
    }

    await tripsProvider.loadExploreTrips();

    if (mounted) {
      // Actualizar animaciones con el número real de viajes
      final totalItems = 4 + tripsProvider.exploreTrips.length;
      _updateAnimations(totalItems);
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  void _updateAnimations(int totalItems) {
    _fadeAnimations = [];
    _slideAnimations = [];

    for (int i = 0; i < totalItems; i++) {
      final start = (i * 0.08).clamp(0.0, 0.8);
      final end = (start + 0.3).clamp(0.0, 1.0);

      _fadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );

      _slideAnimations.add(
        Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start, end, curve: Curves.easeOutCubic),
          ),
        ),
      );
    }
  }

  Widget _buildAnimatedItem(Widget child, int index) {
    final safeIndex = index.clamp(0, _fadeAnimations.length - 1);
    return SlideTransition(
      position: _slideAnimations[safeIndex],
      child: FadeTransition(
        opacity: _fadeAnimations[safeIndex],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripsProvider = Provider.of<TripsProvider>(context);

    return Column(
      children: [
        _buildAnimatedItem(const Header(title: 'Explorar'), 0),
        _buildAnimatedItem(const SearchBar(), 1),
        _buildAnimatedItem(const HorizontalChipList(), 2),
        Expanded(
          child: tripsProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  _buildAnimatedItem(const SectionHeader(title: 'Próximos Viajes'), 3),
                  const SizedBox(height: 16),
                  if (tripsProvider.exploreTrips.isEmpty)
                    _buildAnimatedItem(
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text(
                            'No hay viajes disponibles.\n¡Sé el primero en crear uno!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      4,
                    )
                  else
                    ...tripsProvider.exploreTrips.asMap().entries.map((entry) {
                      final index = entry.key;
                      final trip = entry.value;
                      final tripCardWithJoin = TripCardWithJoin(
                        trip: trip,
                        onJoinPressed: () async {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          final tripsProvider = Provider.of<TripsProvider>(context, listen: false);

                          if (authProvider.currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Debes iniciar sesión para unirte a viajes')),
                            );
                            return;
                          }

                          final success = await tripsProvider.joinTrip(trip.id, authProvider.currentUser!.id);

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('¡Te has unido al viaje "${trip.title}"!')),
                            );
                            // Recargar viajes del usuario para actualizar la UI
                            await tripsProvider.loadUserTrips(authProvider.currentUser!.id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(tripsProvider.error ?? 'Error al unirse al viaje')),
                            );
                          }
                        },
                      );
                      return _buildAnimatedItem(
                        Column(
                          children: [
                            tripCardWithJoin,
                            if (index < tripsProvider.exploreTrips.length - 1)
                              const SizedBox(height: 16),
                          ],
                        ),
                        4 + index,
                      );
                    }).toList(),
                ],
              ),
        ),
      ],
    );
  }
}
