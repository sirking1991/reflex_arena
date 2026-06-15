import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class GameOverOverlay extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final Color winnerColor = winnerLabel == "PLAYER 1" ? CyberColors.player1 : CyberColors.player2;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          color: CyberColors.background.withValues(alpha: 0.9),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated glowing trophy icon container
                  Container(
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
                          color: winnerColor.withValues(alpha: 0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
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
                  
                  const SizedBox(height: 32),
                  
                  // Match Over Label
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
                    "$winnerLabel WINS",
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
                  
                  const SizedBox(height: 40),
                  
                  // Score box or status indicator
                  if (isTugOfWar) ...[
                    Container(
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
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildScoreBox("P2", p2Score, CyberColors.player2),
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
                        _buildScoreBox("P1", p1Score, CyberColors.player1),
                      ],
                    ),
                  ],
                  
                  const SizedBox(height: 64),
                  
                  // Cyberpunk styled rematch and menu buttons
                  Column(
                    children: [
                      // Play Again Button (Elevated Neon)
                      GestureDetector(
                        onTap: onRematch,
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
                ],
              ),
            ),
          ),
        ),
      ),
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
