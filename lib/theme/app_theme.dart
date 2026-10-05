import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Stardew Valley inspired palette.
class Stardew {
  Stardew._();

  static const Color grass = Color(0xFF6DB04B);
  static const Color grassDark = Color(0xFF4A8F34);
  static const Color wood = Color(0xFF9C6B3A);
  static const Color woodLight = Color(0xFFB8844A);
  static const Color woodDark = Color(0xFF5C3A1E);
  static const Color parchment = Color(0xFFF7E9BE);
  static const Color parchmentLight = Color(0xFFFFF6DA);
  static const Color gold = Color(0xFFE6B422);
  static const Color ink = Color(0xFF4A2F18);
  static const Color mutedInk = Color(0xFF7A5633);
  static const Color red = Color(0xFFB5452D);

  /// Hard pixel shadow used by every card.
  static const List<BoxShadow> pixelShadow = [
    BoxShadow(color: Color(0x553E2512), offset: Offset(3, 4), blurRadius: 0),
  ];
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.light(
    primary: Stardew.woodDark,
    onPrimary: Stardew.parchmentLight,
    secondary: Stardew.grassDark,
    onSecondary: Stardew.parchmentLight,
    primaryContainer: Stardew.parchment,
    onPrimaryContainer: Stardew.ink,
    surface: Stardew.parchment,
    onSurface: Stardew.ink,
    onSurfaceVariant: Stardew.mutedInk,
    outline: Stardew.wood,
    error: Stardew.red,
    onError: Colors.white,
  );

  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  final textTheme = GoogleFonts.pixelifySansTextTheme(base.textTheme).apply(
    bodyColor: Stardew.ink,
    displayColor: Stardew.ink,
  );

  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: const BorderSide(color: Stardew.wood, width: 2),
  );

  return base.copyWith(
    textTheme: textTheme,
    // Transparent so the farm background shows behind every screen.
    scaffoldBackgroundColor: Colors.transparent,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Stardew.parchmentLight,
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(
        borderSide: const BorderSide(color: Stardew.grassDark, width: 3),
      ),
      errorBorder: inputBorder.copyWith(
        borderSide: const BorderSide(color: Stardew.red, width: 2),
      ),
      focusedErrorBorder: inputBorder.copyWith(
        borderSide: const BorderSide(color: Stardew.red, width: 3),
      ),
      labelStyle: const TextStyle(color: Stardew.mutedInk),
      floatingLabelStyle: const TextStyle(color: Stardew.woodDark),
      prefixIconColor: Stardew.mutedInk,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? Stardew.grassDark
            : Colors.transparent,
      ),
      checkColor: const WidgetStatePropertyAll(Stardew.parchmentLight),
      side: const BorderSide(color: Stardew.woodDark, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Stardew.grassDark,
        foregroundColor: Stardew.parchmentLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: Stardew.woodDark, width: 2),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Stardew.woodDark),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Stardew.woodDark,
      contentTextStyle: const TextStyle(color: Stardew.parchmentLight),
      actionTextColor: Stardew.gold,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Stardew.ink, width: 2),
      ),
    ),
  );
}

// ============================================================================
// WALLPAPER - pixel farm scene (sun, clouds, hills, trees, fence, flowers)
// ============================================================================

class CozyWallpaper extends StatelessWidget {
  final Widget child;

  const CozyWallpaper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const CustomPaint(painter: _FarmPainter()),
        child,
      ],
    );
  }
}

class _FarmPainter extends CustomPainter {
  const _FarmPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sky
    final skyRect = Offset.zero & size;
    canvas.drawRect(
      skyRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF5FB8EE), Color(0xFFBFE6F8), Color(0xFFE9F7FF)],
          stops: [0.0, 0.6, 1.0],
        ).createShader(skyRect),
    );

    // Sun (blocky glow)
    final sunX = w * 0.86;
    final sunY = h * 0.11;
    _block(canvas, sunX - 44, sunY - 44, 88, 88, const Color(0x33FFF3A0));
    _block(canvas, sunX - 32, sunY - 32, 64, 64, const Color(0x55FFF3A0));
    _block(canvas, sunX - 22, sunY - 22, 44, 44, const Color(0xFFFFE066));
    _block(canvas, sunX - 12, sunY - 12, 24, 24, const Color(0xFFFFF3A0));

    // Clouds
    _cloud(canvas, w * 0.06, h * 0.14, 1.0);
    _cloud(canvas, w * 0.52, h * 0.08, 0.8);
    _cloud(canvas, w * 0.30, h * 0.36, 0.6);
    _cloud(canvas, w * 0.74, h * 0.30, 0.7);

    final grassTop = h * 0.86;

    // Hills (blocky, two layers)
    _hills(canvas, size, h * 0.78, 46, 150, 0.4, const Color(0xFF9BD67E));
    _hills(canvas, size, h * 0.83, 34, 110, 2.0, const Color(0xFF7FC25F));

    // Trees
    _tree(canvas, w * 0.05, h * 0.83, 1.0);
    _tree(canvas, w * 0.13, h * 0.84, 0.7);
    _tree(canvas, w * 0.94, h * 0.83, 1.0);
    _tree(canvas, w * 0.87, h * 0.84, 0.75);

    // Grass field
    canvas.drawRect(
      Rect.fromLTWH(0, grassTop, w, h - grassTop),
      Paint()..color = Stardew.grass,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, grassTop, w, 6),
      Paint()..color = Stardew.grassDark,
    );

    // Fence
    _fence(canvas, size, grassTop - 22);

    // Flowers and grass tufts
    final rnd = math.Random(11);
    const flowerColors = [
      Color(0xFFE85D75),
      Color(0xFFFFD23F),
      Color(0xFFFFFFFF),
      Color(0xFFB57BEE),
    ];
    final tuft = Paint()..color = Stardew.grassDark;
    for (int i = 0; i < 34; i++) {
      final x = rnd.nextDouble() * w;
      final y = grassTop + 14 + rnd.nextDouble() * math.max(1.0, h - grassTop - 24);
      if (i % 3 == 0) {
        canvas.drawRect(Rect.fromLTWH(x, y, 3, 6), tuft);
        canvas.drawRect(Rect.fromLTWH(x + 5, y + 2, 3, 4), tuft);
      } else {
        final c = flowerColors[i % flowerColors.length];
        canvas.drawRect(Rect.fromLTWH(x + 2, y + 5, 2, 6), tuft);
        canvas.drawRect(Rect.fromLTWH(x, y, 6, 6), Paint()..color = c);
        canvas.drawRect(Rect.fromLTWH(x + 2, y + 2, 2, 2),
            Paint()..color = const Color(0xFFE6B422));
      }
    }
  }

  void _block(Canvas c, double x, double y, double w, double h, Color color) {
    c.drawRect(Rect.fromLTWH(x, y, w, h), Paint()..color = color);
  }

  void _cloud(Canvas c, double x, double y, double s) {
    final p = Paint()..color = const Color(0xE6FFFFFF);
    c.drawRect(Rect.fromLTWH(x + 16 * s, y, 40 * s, 12 * s), p);
    c.drawRect(Rect.fromLTWH(x + 8 * s, y + 12 * s, 72 * s, 12 * s), p);
    c.drawRect(Rect.fromLTWH(x, y + 24 * s, 96 * s, 12 * s), p);
    c.drawRect(Rect.fromLTWH(x, y + 36 * s, 96 * s, 4 * s),
        Paint()..color = const Color(0x33A0C8E8));
  }

  void _hills(Canvas canvas, Size size, double baseY, double amp, double freq,
      double phase, Color color) {
    final paint = Paint()..color = color;
    const step = 16.0;
    for (double x = 0; x < size.width; x += step) {
      final raw = amp * (math.sin(x / freq + phase) + 1) / 2 +
          amp * 0.35 * (math.sin(x / (freq * 0.43) + phase * 2) + 1) / 2;
      final hh = (raw / 8).round() * 8.0;
      canvas.drawRect(
        Rect.fromLTWH(x, baseY - hh, step + 0.5, size.height - (baseY - hh)),
        paint,
      );
    }
  }

  void _tree(Canvas c, double x, double baseY, double s) {
    final trunk = Paint()..color = Stardew.woodDark;
    final leaf = Paint()..color = const Color(0xFF3F8A2E);
    final leafLight = Paint()..color = const Color(0xFF5CB145);
    c.drawRect(Rect.fromLTWH(x - 6 * s, baseY - 30 * s, 12 * s, 30 * s), trunk);
    c.drawRect(Rect.fromLTWH(x - 20 * s, baseY - 80 * s, 40 * s, 16 * s), leaf);
    c.drawRect(Rect.fromLTWH(x - 30 * s, baseY - 64 * s, 60 * s, 18 * s), leaf);
    c.drawRect(Rect.fromLTWH(x - 36 * s, baseY - 46 * s, 72 * s, 20 * s), leaf);
    c.drawRect(
        Rect.fromLTWH(x - 20 * s, baseY - 80 * s, 12 * s, 8 * s), leafLight);
    c.drawRect(
        Rect.fromLTWH(x - 30 * s, baseY - 64 * s, 14 * s, 8 * s), leafLight);
  }

  void _fence(Canvas canvas, Size size, double y) {
    final rail = Paint()..color = Stardew.wood;
    final dark = Paint()..color = Stardew.woodDark;
    final light = Paint()..color = Stardew.woodLight;
    canvas.drawRect(Rect.fromLTWH(0, y + 6, size.width, 5), rail);
    canvas.drawRect(Rect.fromLTWH(0, y + 17, size.width, 5), rail);
    canvas.drawRect(Rect.fromLTWH(0, y + 10, size.width, 1.5), dark);
    canvas.drawRect(Rect.fromLTWH(0, y + 21, size.width, 1.5), dark);
    for (double x = 12; x < size.width; x += 56) {
      canvas.drawRect(Rect.fromLTWH(x, y, 9, 30), rail);
      canvas.drawRect(Rect.fromLTWH(x + 6, y, 3, 30), dark);
      canvas.drawRect(Rect.fromLTWH(x, y, 9, 3), light);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// WOODEN PLANK - used for the title bar and dialog header
// ============================================================================

class WoodPlank extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry padding;

  const WoodPlank({super.key, this.child, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _PlankPainter(),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _PlankPainter extends CustomPainter {
  const _PlankPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawRect(Offset.zero & size, Paint()..color = Stardew.wood);

    // Wood grain lines
    final grain = Paint()..color = const Color(0x40000000);
    for (double y = 14; y < h - 6; y += 16) {
      canvas.drawRect(Rect.fromLTWH(0, y, w, 2), grain);
    }
    // Light top edge and dark bottom edge
    canvas.drawRect(
        Rect.fromLTWH(0, 0, w, 3), Paint()..color = const Color(0x44FFFFFF));
    canvas.drawRect(Rect.fromLTWH(0, h - 4, w, 4), Paint()..color = Stardew.woodDark);

    // Nails
    final nail = Paint()..color = Stardew.woodDark;
    final shine = Paint()..color = const Color(0xFFD9C9A8);
    for (final x in [8.0, w - 14.0]) {
      canvas.drawRect(Rect.fromLTWH(x, 8, 6, 6), nail);
      canvas.drawRect(Rect.fromLTWH(x + 1, 9, 2, 2), shine);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// PIXEL ART - tiny sprites drawn from text rows
// ============================================================================

const List<String> _sproutRows = [
  '..GG..GG..',
  '.GGGG.GGG.',
  '.GLGGGGLG.',
  '..GGGGGG..',
  '....SS....',
  '....SS....',
  '..DDDDDD..',
  '.DDDDDDDD.',
];

const Map<String, Color> _sproutPalette = {
  'G': Stardew.grassDark,
  'L': Color(0xFF9BE070),
  'S': Color(0xFF3D7A2B),
  'D': Stardew.wood,
};

class PixelSprout extends StatelessWidget {
  final double cell;

  const PixelSprout({super.key, this.cell = 4});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(10 * cell, _sproutRows.length * cell),
      painter: _PixelPainter(_sproutRows, _sproutPalette, cell),
    );
  }
}

class _PixelPainter extends CustomPainter {
  final List<String> rows;
  final Map<String, Color> palette;
  final double cell;

  const _PixelPainter(this.rows, this.palette, this.cell);

  @override
  void paint(Canvas canvas, Size size) {
    for (int r = 0; r < rows.length; r++) {
      final line = rows[r];
      for (int c = 0; c < line.length; c++) {
        final color = palette[line[c]];
        if (color == null) continue;
        canvas.drawRect(
          Rect.fromLTWH(c * cell, r * cell, cell + 0.4, cell + 0.4),
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelPainter oldDelegate) => false;
}