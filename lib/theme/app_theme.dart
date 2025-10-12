import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colores principales inspirados en Apple
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color secondaryPurple = Color(0xFF5856D6);
  static const Color successGreen = Color(0xFF34C759);
  static const Color warningOrange = Color(0xFFFF9500);
  static const Color errorRed = Color(0xFFFF3B30);
  
  // Escala de grises
  static const Color gray1 = Color(0xFF8E8E93);
  static const Color gray2 = Color(0xFFC7C7CC);
  static const Color gray3 = Color(0xFFD1D1D6);
  static const Color gray4 = Color(0xFFE5E5EA);
  static const Color gray5 = Color(0xFFEFEFF4);
  static const Color gray6 = Color(0xFFF2F2F7);
  
  // Colores para modo oscuro
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF1C1C1E);
  static const Color darkSurface2 = Color(0xFF2C2C2E);
  static const Color darkSurface3 = Color(0xFF3A3A3C);
  
  // Sistema tipográfico inspirado en SF Pro
  static TextTheme _buildTextTheme(BuildContext context, Color textColor) {
    // Usamos Inter como alternativa a SF Pro
    final baseTheme = GoogleFonts.interTextTheme(Theme.of(context).textTheme);
    
    return baseTheme.copyWith(
      // Large Title - 34pt
      displayLarge: baseTheme.displayLarge?.copyWith(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.37,
        color: textColor,
      ),
      
      // Title 1 - 28pt
      displayMedium: baseTheme.displayMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.36,
        color: textColor,
      ),
      
      // Title 2 - 22pt
      displaySmall: baseTheme.displaySmall?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.35,
        color: textColor,
      ),
      
      // Title 3 - 20pt
      headlineMedium: baseTheme.headlineMedium?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.38,
        color: textColor,
      ),
      
      // Headline - 17pt semibold
      headlineSmall: baseTheme.headlineSmall?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.41,
        color: textColor,
      ),
      
      // Body - 17pt regular
      bodyLarge: baseTheme.bodyLarge?.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.41,
        color: textColor,
      ),
      
      // Callout - 16pt
      bodyMedium: baseTheme.bodyMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.32,
        color: textColor,
      ),
      
      // Subheadline - 15pt
      titleMedium: baseTheme.titleMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.24,
        color: textColor,
      ),
      
      // Footnote - 13pt
      bodySmall: baseTheme.bodySmall?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.08,
        color: textColor,
      ),
      
      // Caption 1 - 12pt
      labelSmall: baseTheme.labelSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        color: textColor,
      ),
    );
  }
  
  // Tema claro
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: gray6,
      
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryPurple,
        surface: Colors.white,
        background: gray6,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
      ),
      
      textTheme: _buildTextTheme(context, Colors.black),
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: _buildTextTheme(context, Colors.black).headlineSmall,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.41,
          ),
        ),
      ),
      
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: EdgeInsets.only(bottom: 16),
      ),
      
      dividerTheme: const DividerThemeData(
        color: gray4,
        thickness: 0.5,
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: gray1,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
  
  // Tema oscuro
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: darkBackground,
      
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: secondaryPurple,
        surface: darkSurface,
        background: darkBackground,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      
      textTheme: _buildTextTheme(context, Colors.white),
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: _buildTextTheme(context, Colors.white).headlineSmall,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.41,
          ),
        ),
      ),
      
      cardTheme: const CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: EdgeInsets.only(bottom: 16),
      ),
      
      dividerTheme: const DividerThemeData(
        color: darkSurface3,
        thickness: 0.5,
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryBlue,
        unselectedItemColor: gray1,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
  
  // Sombras para cards
  static List<BoxShadow> cardShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ];
  }
  
  // Espaciado consistente (sistema 8pt)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  
  // Radio de bordes
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
}