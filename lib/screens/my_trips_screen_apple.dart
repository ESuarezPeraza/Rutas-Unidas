import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/widgets/trip_card_apple.dart';
import 'package:myapp/widgets/apple_style_badge.dart';
import 'package:myapp/screens/trip_detail_screen.dart';

class MyTripsScreenApple extends StatefulWidget {
  const MyTripsScreenApple({super.key});

  @override
  State<MyTripsScreenApple> createState() => _MyTripsScreenAppleState();
}

class _MyTripsScreenAppleState extends State<MyTripsScreenApple>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  final List<Map<String, dynamic>> _scheduledTrips = [
    {
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCxCu3i_M0mZfioxOYw1eH0FgcyTOstL5cy2PnLLtOVJRUcJV0JOVfi3zjkcepGxFZP3oGpTERRjg89jtDTIiBJbbK_AqP7hFb4uYVJN76NvjsY8o01Sl24HUcw22IWTpdWOavAHMQo1Qzoe6qT3BBjBFsjCd0pCT74AB5gu1Flu2LhgnmKymN9U-zt_LuM9IasqeMRM1Z2dkrjZooioAwztd4Xw1ZE2AJHSs48t_BAXGU4ueQp7FGfdfCVQUqCrHfJH9aWp0jQfbdR',
      'title': 'Ruta de los Andes',
      'subtitle': '15 de Julio, 2024',
      'badgeLabel': 'Organizador',
      'badgeType': BadgeType.primary,
    },
    {
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCPRKLM4Bgl8Zgl_XYUGQPcN4rQb3n8viDNqT_O7v9QsAqaCIBnzdDwILSMlfQpqaJFZOEf4_vzklNFUHUZpvKmJkLzOu5YvkT-SUC_-xpFA3HgEtuSRUxoQ-kH-LfIOhjjfjuf1fitOGXk5IYKNSKga7fc_2gAP_KN4SWJ_DGaOp0U1HK62WaKDLa0wjcv4pS99dCPlz-zZKAaVk1xFnVW071lSO6ul9z_jhp0kX6l9-h23-nD-inw17P_oircUubCt1RjpVfyD80a',
      'title': 'Carretera del Sur',
      'subtitle': '22 de Julio, 2024',
      'badgeLabel': 'Participante',
      'badgeType': BadgeType.neutral,
    },
  ];

  final List<Map<String, dynamic>> _completedTrips = [
    {
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDiKZ_dFvhC43qLpokoMKzzhAbGGbavqXhPxfTPoIeYG71m_DfRM6HX0VSGcDyqXhwCLRR095NiRp_F7xqhMS8urtxQijx2ey08xyN-a6I_HKflq-IFhRVoZRCRpGji9HzUxOHAqvKhcG76pUwkWVTMUk1LpsiLZB2rv3Y3b-3_laJBl5DyXH28ICJRG7E1b0geQbwoPbbSg881-GavNF2oqQNJ8UuJCzW_XO2-65Aci8JM28sFqO-oz5Hqz_PSC4pIHkBfPWuSfc4c',
      'title': 'Costa Oriental',
      'subtitle': '10 de Junio, 2024',
      'badgeLabel': 'Participante',
      'badgeType': BadgeType.neutral,
    },
    {
      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuArDJmYhrORWAA7ASPyGXEQlaXOtLJrbDpmsTvyQLuQxiFDQG2-QjO-VpO-PItiRIfBCWXdGN21EKz-R0DTJFB9n1sesYDtoMHSN_0dHsIoviyMsX5AJbRtSf3uFib47xidZJLlXxuHMH_fO9O2XpeY6ecfDg2C8tr7-URoNixTx1_J3KfR61YkkfCShx2687XL2qu7qJBMsxnwSdfV9qKipWV7d5dW2-7JJQLj3o8wNYI56cfUbPzaHxxrJC0_W08VWQ2PAW5sbcHG',
      'title': 'Llanos Centrales',
      'subtitle': '5 de Mayo, 2024',
      'badgeLabel': 'Organizador',
      'badgeType': BadgeType.primary,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Crear animaciones para cada elemento
    final totalAnimatedItems = 1 + // Título "Viajes Programados"
        _scheduledTrips.length +
        1 + // Divider
        1 + // Título "Viajes Realizados"
        _completedTrips.length;
    _fadeAnimations = [];
    _slideAnimations = [];

    for (int i = 0; i < totalAnimatedItems; i++) {
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
    // Asegurarnos de que el índice esté dentro del rango
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // AppBar estilo iOS
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                CupertinoIcons.arrow_left,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(
                left: AppTheme.spacing20,
                bottom: AppTheme.spacing16,
              ),
              title: Text(
                'Mis Viajes',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),

          // Contenido
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Viajes Programados
                _buildAnimatedItem(
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppTheme.spacing8,
                      bottom: AppTheme.spacing16,
                    ),
                    child: Text(
                      'Viajes Programados',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  0,
                ),

                // Lista de viajes programados
                ..._scheduledTrips.asMap().entries.map((entry) {
                  final index = entry.key;
                  final trip = entry.value;
                  return _buildAnimatedItem(
                    TripCardApple(
                      imageUrl: trip['imageUrl'],
                      title: trip['title'],
                      subtitle: trip['subtitle'],
                      badgeLabel: trip['badgeLabel'],
                      badgeType: trip['badgeType'],
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const TripDetailScreen(),
                          ),
                        );
                      },
                    ),
                    index + 1,
                  );
                }).toList(),

                // Espaciado y divider
                const SizedBox(height: AppTheme.spacing32),
                _buildAnimatedItem(
                  const Divider(height: 1),
                  _scheduledTrips.length + 1,
                ),
                const SizedBox(height: AppTheme.spacing32),

                // Viajes Realizados
                _buildAnimatedItem(
                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      'Viajes Realizados',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  _scheduledTrips.length + 2,
                ),
                const SizedBox(height: AppTheme.spacing16),

                // Lista de viajes realizados
                ..._completedTrips.asMap().entries.map((entry) {
                  final index = entry.key;
                  final trip = entry.value;
                  return _buildAnimatedItem(
                    Opacity(
                      opacity: 0.7,
                      child: TripCardApple(
                        imageUrl: trip['imageUrl'],
                        title: trip['title'],
                        subtitle: trip['subtitle'],
                        badgeLabel: trip['badgeLabel'],
                        badgeType: trip['badgeType'],
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const TripDetailScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    _scheduledTrips.length + 3 + index,
                  );
                }).toList(),

                // Espaciado final
                const SizedBox(height: AppTheme.spacing32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}