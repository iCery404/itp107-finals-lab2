import 'package:flutter/material.dart';

/// Silver grey palette used by every screen.
class CozyColors {
  CozyColors._();

  static const Color charcoal = Color(0xFF3E4146);
  static const Color charcoalText = Color(0xFF25272A);
  static const Color cream = Color(0xFFF3F4F5);
  static const Color accent = Color(0xFF6F7985);
  static const Color brick = Color(0xFFA9503C);
  static const Color stone = Color(0xFF7C828A);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.light(
    primary: CozyColors.charcoal,
    onPrimary: CozyColors.cream,
    secondary: CozyColors.accent,
    onSecondary: Colors.white,
    primaryContainer: const Color(0xFFDCDFE2),
    onPrimaryContainer: CozyColors.charcoalText,
    surface: CozyColors.cream,
    onSurface: CozyColors.charcoalText,
    outline: CozyColors.stone,
    error: CozyColors.brick,
    onError: Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    // Transparent so the gradient background shows behind every screen.
    scaffoldBackgroundColor: Colors.transparent,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}

/// Silver studio gradient shown behind every screen.
class CozyWallpaper extends StatelessWidget {
  final Widget child;

  const CozyWallpaper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE6E7E8),
                Color(0xFFBDBFC1),
                Color(0xFF9A9C9F),
                Color(0xFFB4B6B8),
                Color(0xFFCFD0D2),
              ],
              stops: [0.0, 0.28, 0.5, 0.78, 1.0],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 0.13,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x33000000),
                    Color(0x00000000),
                    Color(0x40FFFFFF),
                  ],
                  stops: [0.0, 0.35, 1.0],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}