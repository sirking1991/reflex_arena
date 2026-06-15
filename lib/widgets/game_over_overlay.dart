import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class GameOverOverlay extends StatefulWidget {
  final String winnerLabel;
  final int p1Score;
  final int p2Score;
  final VoidCallback onRematch;
  final bool isTugOfWar;

  const GameOverOverlay({
    super.key,
    required this.winnerLabel,
    required this.p1Score,
    required this.p2Score,
    required this.onRematch,
    required this.isTugOfWar,
  });

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Staggered Animations
  late Animation<double> _blurAnimation;
  late Animation<double> _bgOpacityAnimation;
  late Animation<double> _trophyScale;
  late Animation<double> _trophyGlow;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _buttonsFade;
  late Animation<Offset> _buttonsSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Staggered curves
    _blurAnimation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _bgOpacityAnimation = Tween<double>(begin: 0.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _trophyScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
      ),
    );

    _trophyGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.85, curve: Curves.easeIn),
      ),
    );
    _contentSlide = Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _buttonsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
    _buttonsSlide = Tween<Offset>(begin: const Offset(0.0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color winnerColor = widget.winnerLabel == "PLAYER 1" ? CyberColors.player1 : CyberColors.player2;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _blurAnimation.value,
              sigmaY: _blurAnimation.value,
            ),
            child: Container(
              color: CyberColors.background.withValues(alpha: _bgOpacityAnimation.value),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated glowing trophy icon container
                      Transform.scale(
                        scale: _trophyScale.value,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: winnerColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: winnerColor.withValues(alpha: 0.4 * _trophyGlow.value),
                                blurRadius: 16 * _trophyGlow.value,
                                spreadRadius: 2 * _trophyGlow.value,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.emoji_events_rounded,
                              color: winnerColor,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Match Over Label & Winner Label with staggered transitions
                      FadeTransition(
                        opacity: _titleFade,
                        child: SlideTransition(
                          position: _titleSlide,
                          child: Column(
                            children: [
                              const Text(
                                "CONFLATION RESOLVED",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                  color: CyberColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Winner Label with Glitch Shadow
                              Text(
                                "${widget.winnerLabel} WINS",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 4,
                                  color: CyberColors.textLight,
                                  shadows: [
                                    Shadow(
                                      color: winnerColor.withValues(alpha: 0.8),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Score box or status indicator with fade and slide
                      FadeTransition(
                        opacity: _contentFade,
                        child: SlideTransition(
                          position: _contentSlide,
                          child: widget.isTugOfWar
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: CyberColors.cardBg,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: winnerColor.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "VICTORY METRICS",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          color: CyberColors.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "GRID DOMINATED (+3 ENERGY CELLS)",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: winnerColor,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildScoreBox("P2", widget.p2Score, CyberColors.player2),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 32),
                                      child: const Text(
                                        "VS",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                          color: CyberColors.textMuted,
                                        ),
                                      ),
                                    ),
                                    _buildScoreBox("P1", widget.p1Score, CyberColors.player1),
                                  ],
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 64),
                      
                      // Rematch and menu buttons with fade/slide
                      FadeTransition(
                        opacity: _buttonsFade,
                        child: SlideTransition(
                          position: _buttonsSlide,
                          child: Column(
                            children: [
                              // Play Again Button (Elevated Neon)
                              GestureDetector(
                                onTap: widget.onRematch,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  decoration: BoxDecoration(
                                    color: winnerColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: winnerColor,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: winnerColor.withValues(alpha: 0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "INITIATE REMATCH",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 3,
                                        color: CyberColors.textLight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Return to Menu Button (Outline)
                              OutlinedButton(
                                onPressed: () {
                                  // Return to Menu Screen
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: CyberColors.textMuted,
                                  side: const BorderSide(color: CyberColors.textMuted, width: 1.5),
                                  minimumSize: const Size(double.infinity, 54),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "RETURN TO BASE MENU",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreBox(String player, int score, Color color) {
    return Column(
      children: [
        Text(
          player,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: CyberColors.cardBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              "$score",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: CyberColors.textLight,
                shadows: [
                  Shadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
