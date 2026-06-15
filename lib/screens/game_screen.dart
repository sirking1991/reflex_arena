import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/colors.dart';
import '../widgets/player_zone.dart';
import '../widgets/central_target.dart';
import '../widgets/game_over_overlay.dart';
import 'menu_screen.dart';

class GameScreen extends StatefulWidget {
  final GameMode mode;
  const GameScreen({super.key, required this.mode});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  final math.Random _random = math.Random();
  
  int p1Score = 0;
  int p2Score = 0;
  int scoreBalance = 0; // Used for Tug of War (-3 to +3)
  
  bool isRoundActive = false; // True when target is lit/active (Green)
  bool isWaiting = false;     // True during random delay or decoy flashes
  bool p1Fouled = false;      // True if P1 tapped early/decoy
  bool p2Fouled = false;      // True if P2 tapped early/decoy
  Color? decoyColor;          // Current decoy color flashing (null if none/active)
  
  String? winner;             // "PLAYER 1" or "PLAYER 2"
  
  // Track all timers for proper cancellation
  Timer? _initTimer;
  Timer? _delayTimer;
  Timer? _foulResetTimer;
  Timer? _scoreResetTimer;
  Timer? _rematchTimer;
  Timer? _decoyTimer;
  
  bool _firstStart = true;
  int _decoyCount = 0;

  // Shake animation controller
  late AnimationController _shakeController;
  late AnimationController _backButtonController;

  @override
  void initState() {
    super.initState();
    
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _backButtonController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Warm up and start first round
    _initTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _firstStart = false;
        });
        startNextRound();
      }
    });
  }

  @override
  void dispose() {
    _initTimer?.cancel();
    _delayTimer?.cancel();
    _foulResetTimer?.cancel();
    _scoreResetTimer?.cancel();
    _rematchTimer?.cancel();
    _decoyTimer?.cancel();
    _shakeController.dispose();
    _backButtonController.dispose();
    super.dispose();
  }

  void startNextRound() {
    if (winner != null) return;
    
    setState(() {
      isRoundActive = false;
      isWaiting = true;
      p1Fouled = false;
      p2Fouled = false;
      decoyColor = null;
    });

    _decoyCount = 0;
    _decoyTimer?.cancel();
    _delayTimer?.cancel();

    if (widget.mode == GameMode.fakeOut) {
      _runFakeOutTick();
    } else {
      // Classic or Tug of War: random delay between 2 and 5 seconds
      final delayMs = 2000 + _random.nextInt(3000);
      _delayTimer = Timer(Duration(milliseconds: delayMs), () {
        if (!mounted) return;
        setState(() {
          isWaiting = false;
          isRoundActive = true;
        });
      });
    }
  }

  void _runFakeOutTick() {
    if (!mounted || winner != null) return;

    // Delay before the next tick: random between 750 and 1100ms
    final tickMs = 750 + _random.nextInt(350);
    _decoyTimer = Timer(Duration(milliseconds: tickMs), () {
      if (!mounted) return;

      _decoyCount++;

      // Decide whether to trigger GO or flash a decoy color
      // Max 4 decoy ticks, 35% chance to trigger GO after at least 1 tick
      final bool triggerGo = _decoyCount >= 4 || (_decoyCount >= 1 && _random.nextDouble() < 0.4);

      if (triggerGo) {
        setState(() {
          isWaiting = false;
          decoyColor = null;
          isRoundActive = true;
        });
      } else {
        // Choose a decoy color (Red, Blue, Yellow)
        final decoyColors = [
          CyberColors.decoyRed,
          CyberColors.decoyBlue,
          CyberColors.decoyYellow,
        ];
        final chosenColor = decoyColors[_random.nextInt(decoyColors.length)];

        setState(() {
          decoyColor = chosenColor;
        });

        // Flash duration: clear decoy color after 450ms
        Timer(const Duration(milliseconds: 450), () {
          if (mounted && decoyColor == chosenColor) {
            setState(() {
              decoyColor = null;
            });
          }
        });

        // Queue next tick
        _runFakeOutTick();
      }
    });
  }

  void handleTap(bool isPlayer1) {
    if (winner != null || _firstStart) return;

    final bool isTug = widget.mode == GameMode.tugOfWar;

    // 1. Handle Early Tap / Decoy Tap (Foul)
    if (isWaiting || decoyColor != null) {
      if (isPlayer1 && !p1Fouled) {
        HapticFeedback.lightImpact();
        setState(() {
          p1Fouled = true;
        });
      } else if (!isPlayer1 && !p2Fouled) {
        HapticFeedback.lightImpact();
        setState(() {
          p2Fouled = true;
        });
      }

      // If both players fouled, reset the round
      if (p1Fouled && p2Fouled) {
        _decoyTimer?.cancel();
        _delayTimer?.cancel();
        setState(() {
          isWaiting = false;
          decoyColor = null;
        });
        _foulResetTimer?.cancel();
        _foulResetTimer = Timer(const Duration(milliseconds: 1500), () {
          if (mounted) startNextRound();
        });
      }
      return;
    }

    // 2. Handle Scoring Tap (target is active neon green)
    if (isRoundActive) {
      // Locked out if player already fouled
      if (isPlayer1 && p1Fouled) return;
      if (!isPlayer1 && p2Fouled) return;

      // Successful Reaction Tap!
      HapticFeedback.mediumImpact();
      _shakeController.forward(from: 0.0);

      setState(() {
        isRoundActive = false;
        
        if (isTug) {
          if (isPlayer1) {
            scoreBalance++;
          } else {
            scoreBalance--;
          }
          // Mirror state scores for Tug of War so battery display works correctly
          p1Score = scoreBalance;
          p2Score = scoreBalance;
        } else {
          if (isPlayer1) {
            p1Score++;
          } else {
            p2Score++;
          }
        }
      });

      // Check win condition
      if (isTug) {
        if (scoreBalance >= 3) {
          HapticFeedback.heavyImpact();
          setState(() {
            winner = "PLAYER 1";
          });
        } else if (scoreBalance <= -3) {
          HapticFeedback.heavyImpact();
          setState(() {
            winner = "PLAYER 2";
          });
        } else {
          _scoreResetTimer?.cancel();
          _scoreResetTimer = Timer(const Duration(milliseconds: 1500), () {
            if (mounted) startNextRound();
          });
        }
      } else {
        if (p1Score >= 5) {
          HapticFeedback.heavyImpact();
          setState(() {
            winner = "PLAYER 1";
          });
        } else if (p2Score >= 5) {
          HapticFeedback.heavyImpact();
          setState(() {
            winner = "PLAYER 2";
          });
        } else {
          _scoreResetTimer?.cancel();
          _scoreResetTimer = Timer(const Duration(milliseconds: 1500), () {
            if (mounted) startNextRound();
          });
        }
      }
    }
  }

  void handleRematch() {
    setState(() {
      p1Score = 0;
      p2Score = 0;
      scoreBalance = 0;
      winner = null;
      isRoundActive = false;
      isWaiting = false;
      p1Fouled = false;
      p2Fouled = false;
      decoyColor = null;
      _firstStart = true;
    });

    _decoyTimer?.cancel();
    _delayTimer?.cancel();
    _rematchTimer?.cancel();
    _rematchTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _firstStart = false;
        });
        startNextRound();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTug = widget.mode == GameMode.tugOfWar;

    return Scaffold(
      backgroundColor: CyberColors.background,
      body: Stack(
        children: [
          // Main Split-screen Layout wrapped in Screen Shake Translation
          AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              double dx = 0.0;
              double dy = 0.0;
              if (_shakeController.isAnimating) {
                final double progress = _shakeController.value;
                dx = math.sin(progress * 10 * math.pi) * (1.0 - progress) * 12.0;
                dy = math.cos(progress * 8 * math.pi) * (1.0 - progress) * 8.0;
              }
              return Transform.translate(
                offset: Offset(dx, dy),
                child: child,
              );
            },
            child: Column(
              children: [
                // Player 2 Zone (Top, Rotated 180 degrees)
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: PlayerZone(
                      label: "PLAYER 2",
                      score: p2Score,
                      isFouled: p2Fouled,
                      isWinner: winner == "PLAYER 2",
                      baseColor: CyberColors.player2,
                      onTap: () => handleTap(false),
                      isTugOfWar: isTug,
                      isPlayer1: false,
                    ),
                  ),
                ),

                // Central Target Divider Area
                CentralTarget(
                  isActive: isRoundActive,
                  isWaiting: isWaiting,
                  decoyColor: decoyColor,
                ),

                // Player 1 Zone (Bottom, Normal orientation)
                Expanded(
                  child: PlayerZone(
                    label: "PLAYER 1",
                    score: p1Score,
                    isFouled: p1Fouled,
                    isWinner: winner == "PLAYER 1",
                    baseColor: CyberColors.player1,
                    onTap: () => handleTap(true),
                    isTugOfWar: isTug,
                    isPlayer1: true,
                  ),
                ),
              ],
            ),
          ),

          // Central Floating Back Button (aligned left on divider line) with pulse glow
          Positioned(
            left: 16,
            top: (MediaQuery.of(context).size.height / 2) - 22,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: AnimatedBuilder(
                animation: _backButtonController,
                builder: (context, child) {
                  final double pulse = _backButtonController.value;
                  return Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: CyberColors.cardBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CyberColors.textMuted.withValues(alpha: 0.3 + pulse * 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CyberColors.player1.withValues(alpha: 0.1 * pulse),
                          blurRadius: 4 + pulse * 8,
                          spreadRadius: pulse * 2,
                        ),
                        BoxShadow(
                          color: CyberColors.background.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: CyberColors.textLight,
                  size: 20,
                ),
              ),
            ),
          ),

          // Systems Initializing overlay
          if (_firstStart && winner == null)
            IgnorePointer(
              child: AnimatedOpacity(
                opacity: _firstStart ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  color: CyberColors.background.withValues(alpha: 0.85),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "SYSTEM INITIALIZING",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 6,
                            color: CyberColors.player1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${widget.mode.name.toUpperCase()} CONFIGURATION LOADED",
                          style: const TextStyle(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: CyberColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Game Over overlay
          if (winner != null)
            GameOverOverlay(
              winnerLabel: winner!,
              p1Score: p1Score,
              p2Score: p2Score,
              onRematch: handleRematch,
              isTugOfWar: isTug,
            ),
        ],
      ),
    );
  }
}
