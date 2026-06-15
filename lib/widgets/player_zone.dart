import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PlayerZone extends StatefulWidget {
  final String label;
  final int score;
  final bool isFouled;
  final bool isWinner;
  final Color baseColor;
  final VoidCallback onTap;
  final bool isTugOfWar;
  final bool isPlayer1;

  const PlayerZone({
    super.key,
    required this.label,
    required this.score,
    required this.isFouled,
    required this.isWinner,
    required this.baseColor,
    required this.onTap,
    required this.isTugOfWar,
    required this.isPlayer1,
  });

  @override
  State<PlayerZone> createState() => _PlayerZoneState();
}

class _PlayerZoneState extends State<PlayerZone> with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  Offset _tapPosition = Offset.zero;
  bool _showRipple = false;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isFouled || widget.isWinner) return;
    
    setState(() {
      _tapPosition = details.localPosition;
      _showRipple = true;
    });
    
    _rippleController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _showRipple = false;
        });
      }
    });
    
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    // Determine background color and borders based on state
    Color borderColor = widget.baseColor.withValues(alpha: 0.3);
    Color cardColor = CyberColors.background;

    if (widget.isFouled) {
      borderColor = CyberColors.foul;
      cardColor = CyberColors.frozenOverlay;
    } else if (widget.isWinner) {
      borderColor = widget.baseColor;
      cardColor = widget.baseColor.withValues(alpha: 0.08);
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(
            color: borderColor,
            width: widget.isWinner ? 3.0 : 1.5,
          ),
          boxShadow: widget.isWinner
              ? [
                  BoxShadow(
                    color: widget.baseColor.withValues(alpha: 0.3),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Cyber Grid Background Watermark
            Positioned.fill(
              child: Opacity(
                opacity: widget.isFouled ? 0.05 : 0.02,
                child: CustomPaint(
                  painter: ZoneGridPainter(isFouled: widget.isFouled),
                ),
              ),
            ),

            // Large Watermark Text
            Opacity(
              opacity: widget.isWinner ? 0.06 : 0.03,
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 76,
                  fontWeight: FontWeight.w900,
                  color: widget.baseColor,
                  letterSpacing: 10,
                ),
              ),
            ),

            // Custom Neon Ripple overlay
            if (_showRipple)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _rippleController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: RipplePainter(
                        position: _tapPosition,
                        progress: _rippleController.value,
                        color: widget.baseColor,
                      ),
                    );
                  },
                ),
              ),

            // Foreground Layout: Scores & Labels
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isTugOfWar) ...[
                  // Tug of War: Battery Cells Indicator
                  const Text(
                    "METER BALANCE",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: CyberColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      // Player 1 scores are positive (+1, +2, +3)
                      // Player 2 scores are negative (-1, -2, -3)
                      final bool isLit = widget.isPlayer1
                          ? widget.score > index
                          : widget.score < -index;
                      
                      final cellColor = isLit 
                          ? widget.baseColor 
                          : CyberColors.targetInactive.withValues(alpha: 0.15);
                      
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 48,
                        height: 20,
                        decoration: BoxDecoration(
                          color: cellColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isLit ? widget.baseColor : CyberColors.targetInactive,
                            width: 1.5,
                          ),
                          boxShadow: isLit
                              ? [
                                  BoxShadow(
                                    color: widget.baseColor.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isLit 
                                  ? CyberColors.textLight 
                                  : CyberColors.targetInactive.withValues(alpha: 0.3),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  // Classic / Fake Out: Score Text with Switch Animation
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Text(
                      "${widget.score}",
                      key: ValueKey<int>(widget.score),
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.w100,
                        color: widget.baseColor,
                        shadows: [
                          Shadow(
                            color: widget.baseColor.withValues(alpha: 0.4),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Action Label
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    widget.isFouled
                        ? "SYSTEM FROZEN"
                        : widget.isWinner
                            ? "WINNER MATCH"
                            : widget.label,
                    key: ValueKey<String>(
                        widget.isFouled ? "frozen" : widget.isWinner ? "winner" : "label"),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: widget.isFouled
                          ? CyberColors.foul
                          : CyberColors.textLight.withValues(alpha: 0.8),
                      shadows: widget.isFouled
                          ? [
                              const Shadow(
                                color: CyberColors.foul,
                                blurRadius: 8,
                              )
                            ]
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Neon Touch Ripple
class RipplePainter extends CustomPainter {
  final Offset position;
  final double progress;
  final Color color;

  RipplePainter({
    required this.position,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double opacity = (1.0 - progress).clamp(0.0, 1.0);
    
    final Paint linePaint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 + (1.0 - progress) * 4.0;

    final Paint fillPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.12)
      ..style = PaintingStyle.fill;

    final double radius = progress * 140.0;
    
    // Draw expanding circles
    canvas.drawCircle(position, radius, fillPaint);
    canvas.drawCircle(position, radius, linePaint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.position != position;
  }
}

// Zone Background Grid Painter
class ZoneGridPainter extends CustomPainter {
  final bool isFouled;
  ZoneGridPainter({required this.isFouled});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = (isFouled ? CyberColors.foul : CyberColors.textLight).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const double step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    if (isFouled) {
      // Draw cross lines to denote lockout
      final Paint hazardPaint = Paint()
        ..color = CyberColors.foul.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      
      for (double y = -size.width; y < size.height; y += 60) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y + size.width), hazardPaint);
      }
    }
  }

  @override
  bool shouldRepaint(ZoneGridPainter oldDelegate) => oldDelegate.isFouled != isFouled;
}
