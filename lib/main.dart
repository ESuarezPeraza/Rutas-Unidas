import 'package:flutter/material.dart' hide SearchBar;
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/screens/create_trip_screen.dart';
import 'package:myapp/screens/profile_screen.dart';
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
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFD45211),
        scaffoldBackgroundColor: const Color(0xFFF8F6F6),
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xFF221610),
                displayColor: const Color(0xFF221610),
              ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFD45211),
          surface: Color(0xFFF8F6F6),
          onSurface: const Color(0xFF221610),
          secondary: Color.fromRGBO(34, 22, 16, 0.7),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFD45211),
        scaffoldBackgroundColor: const Color(0xFF221610),
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: const Color(0xFFF8F6F6),
                displayColor: const Color(0xFFF8F6F6),
              ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD45211),
          surface: Color(0xFF221610),
          onSurface: const Color(0xFFF8F6F6),
          secondary: Color.fromRGBO(248, 246, 246, 0.7),
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: const MyHomePage(),
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
    Text('Mis Viajes'), // Placeholder
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mis Viajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Crear Viaje',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).colorScheme.surface,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Header(title: 'Explorar'),
        const SearchBar(),
        const HorizontalChipList(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: const [
              SectionHeader(title: 'Próximos Viajes'),
              SizedBox(height: 16),
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
            ],
          ),
        ),
      ],
    );
  }
}
