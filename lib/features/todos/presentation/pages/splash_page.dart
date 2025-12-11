import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navigate after the short intro animation completes.
    Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 1600),
            curve: Curves.easeInOut,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.gradientStart, AppTheme.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Floating glow circles
          Positioned(
            top: -80,
            right: -60,
            child: _glowCircle(
              220,
              AppTheme.gradientEnd.withValues(alpha: 0.35),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -40,
            child: _glowCircle(
              260,
              AppTheme.gradientMiddle.withValues(alpha: 0.30),
            ),
          ),

          // Center icon + title
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFFFFFFFF), Color(0xFFF8E8FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.35),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child:
                        Icon(
                              Icons.pending_actions_rounded,
                              size: 64,
                              color: AppTheme.gradientStart,
                            )
                            .animate()
                            .scale(
                              delay: 200.ms,
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            )
                            .fadeIn(duration: 500.ms),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                      'مهامي المحفزة',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 350.ms, duration: 500.ms)
                    .slide(begin: const Offset(0, 0.2), curve: Curves.easeOut),
                const SizedBox(height: 8),
                Text(
                      'ابدأ يومك بطاقة وإشعارات ذكية',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    )
                    .animate()
                    .fadeIn(delay: 450.ms, duration: 500.ms)
                    .slide(begin: const Offset(0, 0.2), curve: Curves.easeOut),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(color: color, blurRadius: 80, spreadRadius: 20),
            ],
          ),
        )
        .animate()
        .scale(
          duration: 1600.ms,
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.05, 1.05),
        )
        .fadeIn(duration: 800.ms);
  }
}
