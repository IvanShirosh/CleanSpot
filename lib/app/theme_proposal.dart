import 'package:flutter/material.dart';

/// CleanSpot Color Palette
///
/// Designed for a fresh, clean, and community-driven dengue prevention app.
class AppColors {
  AppColors._();

  // Core brand & surfaces
  static const Color background = Color(0xFFF5F8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE3E8E3);
  static const Color primary = Color(0xFF248A50);
  static const Color primaryDark = Color(0xFF1B5E3B);
  static const Color primaryLight = Color(0xFFE6F4EA);

  // Text colors
  static const Color textPrimary = Color(0xFF1F2A24);
  static const Color textSecondary = Color(0xFF6B756F);

  // Status & feedback
  static const Color warningText = Color(0xFFB8501A);
  static const Color warningBg = Color(0xFFFDEEE6);
  static const Color errorText = Color(0xFFC62828);
  static const Color errorBg = Color(0xFFFDE8E8);

  // Status aliases
  static const Color warning = warningText;
  static const Color error = errorText;
  static const Color success = primaryDark;
  static const Color successBg = primaryLight;
}

/// Typography definitions following the CleanSpot design specifications.
/// Uses 'Inter' with fallback to system default.
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  /// 44 bold - Hero point displays and large counters
  static const TextStyle pointsBig = TextStyle(
    fontFamily: fontFamily,
    fontSize: 44,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
    height: 1.1,
  );

  /// 28 bold - Page titles and prominent headers
  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// 20 bold - Section headings, sheet titles, and card headers
  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  /// 14 - Standard body text, descriptions, and inputs
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// 12 - Subtitles, captions, timestamps, and secondary metadata
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.3,
  );
}

/// Helper styles for badges & status chips (e.g., Pending Review, Needs Detail, Reviewed)
class AppBadges {
  AppBadges._();

  static const BoxDecoration warningDecoration = BoxDecoration(
    color: AppColors.warningBg,
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  static const TextStyle warningTextStyle = TextStyle(
    fontFamily: AppTypography.fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.warningText,
  );

  static const BoxDecoration errorDecoration = BoxDecoration(
    color: AppColors.errorBg,
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontFamily: AppTypography.fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.errorText,
  );

  static const BoxDecoration successDecoration = BoxDecoration(
    color: AppColors.primaryLight,
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  static const TextStyle successTextStyle = TextStyle(
    fontFamily: AppTypography.fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDark,
  );
}

/// Builds the comprehensive [ThemeData] for CleanSpot.
ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: AppTypography.fontFamily,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.primaryDark,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.errorText,
      onError: Colors.white,
      errorContainer: AppColors.errorBg,
      onErrorContainer: AppColors.errorText,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
    ),
  );

  return base.copyWith(
    // Typography
    textTheme: TextTheme(
      displayLarge: AppTypography.pointsBig,
      headlineMedium: AppTypography.title,
      headlineSmall: AppTypography.heading,
      titleLarge: AppTypography.heading,
      titleMedium: AppTypography.heading.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: AppTypography.body.copyWith(fontSize: 16),
      bodyMedium: AppTypography.body,
      bodySmall: AppTypography.caption,
      labelLarge: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
      labelMedium: AppTypography.caption.copyWith(fontWeight: FontWeight.w500),
      labelSmall: AppTypography.caption,
    ),

    // Card: radius 20, 1px border, no shadow
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: AppColors.border,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // ElevatedButton: full width, 52 height, radius 14, primary
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // OutlinedButton: white, border, primary text, radius 14
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
        elevation: 0,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(
          color: AppColors.border,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // NavigationBar: mint pill for selected item
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      indicatorColor: AppColors.primaryLight,
      indicatorShape: const StadiumBorder(),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          );
        }
        return const TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColors.primaryDark,
            size: 24,
          );
        }
        return const IconThemeData(
          color: AppColors.textSecondary,
          size: 24,
        );
      }),
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      foregroundColor: AppColors.textPrimary,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: AppTypography.heading,
    ),

    // Input fields (radius 14, 1px border)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
      labelStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.errorText, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.errorText, width: 1.5),
      ),
    ),

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primaryLight,
      disabledColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      side: const BorderSide(color: AppColors.border, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      labelStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      secondaryLabelStyle: const TextStyle(
        fontFamily: AppTypography.fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryDark,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
  );
}
