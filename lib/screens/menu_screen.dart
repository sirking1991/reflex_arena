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

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
          // Background Cyber Grid Decorative Effect
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 2),
                
                // Title Area with Breathing Glow
                Center(
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final blur = 8.0 + _pulseController.value * 12.0;
                          return Text(
                            "REFLEX",
                            style: TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 8,
                              color: CyberColors.textLight,
                              shadows: [
                                Shadow(
                                  color: CyberColors.player1.withValues(alpha: 0.8),
                                  blurRadius: blur,
                                ),
                                Shadow(
                                  color: CyberColors.player2.withValues(alpha: 0.6),
                                  blurRadius: blur * 1.5,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final blur = 6.0 + _pulseController.value * 8.0;
                          return Text(
                            "ARENA",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 16,
                              color: CyberColors.player1,
                              shadows: [
                                Shadow(
                                  color: CyberColors.player1.withValues(alpha: 0.8),
                                  blurRadius: blur,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const Spacer(flex: 2),
                
                // Mode Selection Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "CHOOSE GAME MODE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 4,
                      color: CyberColors.textMuted,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Game Mode Cards List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _buildModeCard(
                        mode: GameMode.classic,
                        title: "CLASSIC REFLEX",
                        subtitle: "Speed Test",
                        description: "Tap the center target the millisecond it activates. First to 5 points wins.",
                        accentColor: CyberColors.player1,
                        icon: Icons.flash_on_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildModeCard(
                        mode: GameMode.fakeOut,
                        title: "FAKE OUT",
                        subtitle: "Decoy Warning",
                        description: "Target flashes multiple fake colors. Tap ONLY when it is neon green. Decoys freeze you!",
                        accentColor: CyberColors.gold,
                        icon: Icons.warning_amber_rounded,
                      ),
                      const SizedBox(height: 16),
                      _buildModeCard(
                        mode: GameMode.tugOfWar,
                        title: "TUG OF WAR",
                        subtitle: "Competitive Tug",
                        description: "A single bar represents the balance of power. Scoring pulls it to your side. First to +/-3 wins.",
                        accentColor: CyberColors.player2,
                        icon: Icons.compare_arrows_rounded,
                      ),
                    ],
                  ),
                ),
                
                const Spacer(flex: 2),
                
                // Footer
                const Center(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required GameMode mode,
    required String title,
    required String subtitle,
    required String description,
    required Color accentColor,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _startGame(mode),
      child: Container(
        decoration: BoxDecoration(
          color: CyberColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.05),
              blurRadius: 10,
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
                    color: accentColor.withValues(alpha: 0.05),
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
                        color: accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: accentColor,
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
                                title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: CyberColors.textLight,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                subtitle.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.5,
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
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
  }
}

// Custom Grid Painter for background sci-fi vibe
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberColors.player1.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const step = 40.0;
    
    // Draw vertical lines
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    
    // Draw horizontal lines
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
