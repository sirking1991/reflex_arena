import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/colors.dart';

class CentralTarget extends StatefulWidget {
  final bool isActive;
  final bool isWaiting;
  final Color? decoyColor;

  const CentralTarget({
    super.key,
    required this.isActive,
    required this.isWaiting,
    this.decoyColor,
  });

  @override
  State<CentralTarget> createState() => _CentralTargetState();
}

class _CentralTargetState extends State<CentralTarget>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    if (widget.isWaiting) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant CentralTarget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isWaiting && !oldWidget.isWaiting) {
      _rotationController.repeat();
    } else if (!widget.isWaiting && oldWidget.isWaiting) {
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasDecoy = widget.decoyColor != null;
    final bool isTriggered = widget.isActive || hasDecoy;
    
    // Choose the target color
    Color targetColor = CyberColors.targetInactive;
    if (widget.isActive) {
      targetColor = CyberColors.targetActive;
    } else if (hasDecoy) {
      targetColor = widget.decoyColor!;
    }

    return Container(
      height: 100,
      color: CyberColors.background,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Cyberpunk subtle grid line divider
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CyberColors.player1.withValues(alpha: 0.1),
                  CyberColors.player1.withValues(alpha: 0.6),
                  CyberColors.player2.withValues(alpha: 0.6),
                  CyberColors.player2.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),

          // Outer rotating radar ring (visible during waiting state)
          if (widget.isWaiting)
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * 2 * math.pi,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CyberColors.player1.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 30,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CyberColors.player1,
                              boxShadow: [
                                BoxShadow(
                                  color: CyberColors.player1.withValues(alpha: 0.8),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          // Central Target Circle with Neon Glow
          AnimatedScale(
            scale: widget.isActive ? 1.35 : (hasDecoy ? 1.25 : (widget.isWaiting ? 0.9 : 0.7)),
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutBack,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isTriggered
                    ? targetColor
                    : CyberColors.targetInactive.withValues(alpha: 0.4),
                boxShadow: isTriggered
                    ? [
                        BoxShadow(
                          color: targetColor.withValues(alpha: 0.6),
                          blurRadius: 20,
                          spreadRadius: 6,
                        ),
                        BoxShadow(
                          color: targetColor,
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
                border: Border.all(
                  color: isTriggered ? CyberColors.textLight : CyberColors.targetInactive,
                  width: isTriggered ? 2 : 1,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: isTriggered ? 14 : 8,
                  height: isTriggered ? 14 : 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isTriggered
                        ? CyberColors.background
                        : CyberColors.textLight.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
