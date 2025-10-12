import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/cupertino.dart';
import 'package:myapp/screens/create_trip_screen.dart';
import 'package:myapp/screens/my_trips_screen_apple.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'widgets/header.dart';
import 'widgets/horizontal_chip_list.dart';
import 'widgets/search_bar.dart';
import 'widgets/section_header.dart';
import 'widgets/trip_card.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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
      home: const MyHomePage(),
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

  static const List<Widget> _widgetOptions = <Widget>[
    ExploreScreen(),
    MyTripsScreenApple(),
    CreateTripScreen(),
    ProfileScreen(),
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

  final _tripCards = const [
    TripCard(
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAeClE2gYVcTjdqXUTpX7z0rsGA-38ioPFpdWvHbVLRlBXzCdiLjbFcFJTHs2wOUgPxrsI6t1RtcZJSjM5kNnRjygBOrCnVBYAV-edgZ7gk44lsyM9ULpcsnnghBqnWWRao2LwcYh5vAaF_3YvDr5ewtPmAV0WxVblyL2G9kz7_iv6n0RFmHdMxAttBv-q3p_h7txQe5VHhTRqDYvtc2eGgelU56sB4_UAF0huMDmq6E6JyPHe2Gjo5oIX3mCI-mLSVPqzZ1GryN6aP',
      title: 'Ruta de los Andes',
      subtitle: 'Organizado por: Ricardo',
      trailingText: '25/07/24',
    ),
    SizedBox(height: 16),
    TripCard(
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuB0UYvq03--TL90Sz8FbL8QeeSzEb79marmcCYXuYRyJyf6outS5RGX2QCWqYYhUUJc_EvOWllHJ44jd5huSjd9U9mLRTRUtC7d7HQ76Mi-srr8JJLiNodj5Af3mdP1tunKaVU4_cM6DHkU3atvvDOXzkyJtghsStWopy0-ToHJNZFA5qINqUraSOeLHwS-Zx7JQhvLs7-QtTFbOpHGXdvynab2ZV5dWCMS_eieypSHa4ORiktZatZOPnGKPBzm3rCb86wE3BVK5M50',
      title: 'Carretera Panamericana',
      subtitle: 'Organizado por: Gabriela',
      trailingText: '15/08/24',
    ),
    SizedBox(height: 16),
    TripCard(
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuArDcXKmTC2_iJ3QXMmUq3yLVAw2AWNWZ8_wskUVki25W95Q_qe-6Um2szIvCGAiNw_2CmV26e1ieqRKG8rjBl0aO2dcWn03WV5em_jYYqYKOY-lfYQO7mp9K_Fl5p7i_odXM8DPetnXCfsJohQj4eZ2FeN7wdEtfCu4_PWn6kn7QmuVl2CfrWvbMMAdrR41C61xX4IXzPYftk6KJ7sDJ4ZwA2TeAU0pvQi0FuZQ52OBzZuL8P1GUIBz76COAwU8A9yC2cXjftFEYab',
      title: 'Costa Oriental',
      subtitle: 'Organizado por: Alejandro',
      trailingText: '05/09/24',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    final totalItems = 4 + _tripCards.length;
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

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    return Column(
      children: [
        _buildAnimatedItem(const Header(title: 'Explorar'), 0),
        _buildAnimatedItem(const SearchBar(), 1),
        _buildAnimatedItem(const HorizontalChipList(), 2),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              _buildAnimatedItem(const SectionHeader(title: 'Próximos Viajes'), 3),
              const SizedBox(height: 16),
              ..._tripCards.asMap().entries.map((entry) {
                final index = entry.key;
                final widget = entry.value;
                return _buildAnimatedItem(widget, 4 + index);
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
