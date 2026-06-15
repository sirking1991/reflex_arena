import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'game_screen.dart';

enum GameMode {
  classic,
  fakeOut,
  tugOfWar,
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _gridController;
  late AnimationController _entranceController;
  late AnimationController _titleBobController;

  // Title Animations
  late Animation<double> _titleBob;
  late Animation<Color?> _reflexColor;
  late Animation<Color?> _arenaColor;

  // Staggered Animations
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _card1Fade;
  late Animation<Offset> _card1Slide;
  late Animation<double> _card2Fade;
  late Animation<Offset> _card2Slide;
  late Animation<double> _card3Fade;
  late Animation<Offset> _card3Slide;
  late Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _titleBobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _titleBob = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _titleBobController,
        curve: Curves.easeInOutSine,
      ),
    );

    _reflexColor = ColorTween(
      begin: CyberColors.player1,
      end: CyberColors.player2,
    ).animate(
      CurvedAnimation(
        parent: _titleBobController,
        curve: Curves.easeInOutSine,
      ),
    );

    _arenaColor = ColorTween(
      begin: CyberColors.player2,
      end: CyberColors.player1,
    ).animate(
      CurvedAnimation(
        parent: _titleBobController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Staggered curve configurations
    const curve = Curves.easeOutCubic;

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: curve),
      ),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeIn),
      ),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0.0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 0.7, curve: curve),
      ),
    );

    _card1Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );
    _card1Slide = Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.3, 0.8, curve: curve),
      ),
    );

    _card2Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
      ),
    );
    _card2Slide = Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.4, 0.9, curve: curve),
      ),
    );

    _card3Fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 0.9, curve: Curves.easeIn),
      ),
    );
    _card3Slide = Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 1.0, curve: curve),
      ),
    );

    _footerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _gridController.dispose();
    _entranceController.dispose();
    _titleBobController.dispose();
    super.dispose();
  }

  void _startGame(GameMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GameScreen(mode: mode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      body: Stack(
        children: [
          // Background Synthwave Horizon Landscape with Ambient Drift
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _gridController,
              builder: (context, child) {
                return CustomPaint(
                  painter: SynthwaveBackgroundPainter(gridOffset: _gridController.value),
                );
              },
            ),
          ),
          
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                
                // Title Area with Breathing Glow & Staggered Entrance
                AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: child,
                      ),
                    );
                  },
                  child: Center(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_pulseController, _titleBobController]),
                      builder: (context, child) {
                        final bobValue = _titleBob.value;
                        final reflexColor = _reflexColor.value ?? CyberColors.player1;
                        final arenaColor = _arenaColor.value ?? CyberColors.player2;
                        final blur = 8.0 + _pulseController.value * 12.0;
                        final arenaBlur = 6.0 + _pulseController.value * 8.0;

                        return Transform.translate(
                          offset: Offset(0, bobValue),
                          child: Column(
                            children: [
                              Text(
                                "REFLEX",
                                style: TextStyle(
                                  fontSize: 54,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 8,
                                  color: reflexColor,
                                  shadows: [
                                    Shadow(
                                      color: reflexColor.withValues(alpha: 0.8),
                                      blurRadius: blur,
                                    ),
                                    Shadow(
                                      color: arenaColor.withValues(alpha: 0.6),
                                      blurRadius: blur * 1.5,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "ARENA",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 16,
                                  color: arenaColor,
                                  shadows: [
                                    Shadow(
                                      color: arenaColor.withValues(alpha: 0.8),
                                      blurRadius: arenaBlur,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                const Spacer(flex: 2),
                
                // Mode Selection Header with Entrance Animation
                AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _headerFade,
                      child: SlideTransition(
                        position: _headerSlide,
                        child: child,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "CHOOSE GAME MODE",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: CyberColors.textLight,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Game Mode Cards List with Staggered Entrance
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _entranceController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _card1Fade,
                            child: SlideTransition(
                              position: _card1Slide,
                              child: child,
                            ),
                          );
                        },
                        child: _MenuModeCard(
                          onTap: () => _startGame(GameMode.classic),
                          title: "CLASSIC REFLEX",
                          subtitle: "Speed Test",
                          description: "Tap the center target the millisecond it activates. First to 5 points wins.",
                          accentColor: CyberColors.player1,
                          icon: Icons.flash_on_rounded,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedBuilder(
                        animation: _entranceController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _card2Fade,
                            child: SlideTransition(
                              position: _card2Slide,
                              child: child,
                            ),
                          );
                        },
                        child: _MenuModeCard(
                          onTap: () => _startGame(GameMode.fakeOut),
                          title: "FAKE OUT",
                          subtitle: "Decoy Warning",
                          description: "Target flashes multiple fake colors. Tap ONLY when it is neon green. Decoys freeze you!",
                          accentColor: CyberColors.gold,
                          icon: Icons.warning_amber_rounded,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedBuilder(
                        animation: _entranceController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _card3Fade,
                            child: SlideTransition(
                              position: _card3Slide,
                              child: child,
                            ),
                          );
                        },
                        child: _MenuModeCard(
                          onTap: () => _startGame(GameMode.tugOfWar),
                          title: "TUG OF WAR",
                          subtitle: "Competitive Tug",
                          description: "A single bar represents the balance of power. Scoring pulls it to your side. First to +/-3 wins.",
                          accentColor: CyberColors.player2,
                          icon: Icons.compare_arrows_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(flex: 2),
                
                // Footer
                AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _footerFade,
                      child: child,
                    );
                  },
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "LOCAL 2-PLAYER SPLIT SCREEN",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                          color: CyberColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Interactive Mode Card with tap down scaling and glowing feedback
class _MenuModeCard extends StatefulWidget {
  final VoidCallback onTap;
  final String title;
  final String subtitle;
  final String description;
  final Color accentColor;
  final IconData icon;

  const _MenuModeCard({
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accentColor,
    required this.icon,
  });

  @override
  State<_MenuModeCard> createState() => _MenuModeCardState();
}

class _MenuModeCardState extends State<_MenuModeCard> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.25, end: 0.70).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: CyberColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.accentColor.withValues(alpha: _glowAnimation.value),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.05 + (_glowAnimation.value - 0.25) * 0.2),
                    blurRadius: 10 + (_glowAnimation.value - 0.25) * 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Corner Accent Glow
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.accentColor.withValues(alpha: 0.05 + (_glowAnimation.value - 0.25) * 0.1),
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon container
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: widget.accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              widget.icon,
                              color: widget.accentColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Texts
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: CyberColors.textLight,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      widget.subtitle.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5,
                                        color: widget.accentColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  widget.description,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    height: 1.4,
                                    color: CyberColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom Painter for Synthwave Horizon landscape (Sky, Stars, Retro Sun, Perspective Grid)
class SynthwaveBackgroundPainter extends CustomPainter {
  final double gridOffset; // Ranges from 0.0 to 1.0

  SynthwaveBackgroundPainter({required this.gridOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final horizonY = size.height * 0.45;
    final sunCenter = Offset(size.width / 2, size.height * 0.32);
    final sunRadius = 75.0;

    // 1. Draw Sky Stars
    final rand = math.Random(42);
    for (int i = 0; i < 45; i++) {
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * horizonY; // Sky area only
      final starSize = 1.0 + rand.nextDouble() * 1.5;
      final phase = rand.nextDouble() * 2 * math.pi;
      
      // Pulsing star opacity
      final starOpacity = (0.2 + 0.6 * math.sin(gridOffset * 2 * math.pi + phase)).clamp(0.0, 1.0) * 0.25;
      final starPaint = Paint()..color = CyberColors.textLight.withValues(alpha: starOpacity);
      canvas.drawCircle(Offset(x, y), starSize, starPaint);
    }

    // 2. Draw Retro Sun (Gradient from Magenta to Gold)
    final sunPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          CyberColors.player2, // Pink/Magenta
          CyberColors.gold,    // Gold/Orange
        ],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: sunRadius));

    // Sun outer glow
    final sunGlowPaint = Paint()
      ..color = CyberColors.player2.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(sunCenter, sunRadius + 6, sunGlowPaint);
    canvas.drawCircle(sunCenter, sunRadius, sunPaint);

    // Draw slices (horizontal lines cutting the bottom half of the sun)
    final bgPaint = Paint()
      ..color = CyberColors.background
      ..style = PaintingStyle.fill;

    const double startSliceY = 5.0; // Offset below sun center
    double currentY = sunCenter.dy + startSliceY;
    double sliceHeight = 2.0;
    const double sliceIncrement = 1.8;
    const double gapIncrement = 1.2;
    double gap = 4.0;

    while (currentY < sunCenter.dy + sunRadius) {
      canvas.drawRect(
        Rect.fromLTRB(
          sunCenter.dx - sunRadius - 10,
          currentY,
          sunCenter.dx + sunRadius + 10,
          currentY + sliceHeight,
        ),
        bgPaint,
      );
      currentY += sliceHeight + gap;
      sliceHeight += sliceIncrement;
      gap += gapIncrement;
    }

    // 3. Draw Horizon Glowing Divider Line
    final horizonPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          CyberColors.player1.withValues(alpha: 0.0),
          CyberColors.player1.withValues(alpha: 0.4),
          CyberColors.player2.withValues(alpha: 0.4),
          CyberColors.player2.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, horizonY - 1, size.width, 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, horizonY), Offset(size.width, horizonY), horizonPaint);

    // Grid paint
    final gridPaint = Paint()
      ..color = CyberColors.player1.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // 4. Draw Perspective lines (radiating vertical lines)
    final vanishingPoint = Offset(size.width / 2, horizonY);
    const int numPerspectiveLines = 14;
    for (int i = 0; i <= numPerspectiveLines; i++) {
      final double fraction = i / numPerspectiveLines;
      final double bottomX = size.width * (-0.5 + fraction * 2.0); // Spread lines wide at the bottom
      canvas.drawLine(vanishingPoint, Offset(bottomX, size.height), gridPaint);
    }

    // 5. Draw Moving Horizontal Lines (Perspective spacing)
    const int numHorizontalLines = 9;
    for (int i = 0; i < numHorizontalLines; i++) {
      final double r = (i + gridOffset) / numHorizontalLines;
      final double y = horizonY + (size.height - horizonY) * math.pow(r, 2.5);
      
      final double lineOpacity = r * 0.12;
      final linePaint = Paint()
        ..color = CyberColors.player1.withValues(alpha: lineOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8 + r * 0.8; // Lines get thicker as they get closer

      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant SynthwaveBackgroundPainter oldDelegate) =>
      oldDelegate.gridOffset != gridOffset;
}
