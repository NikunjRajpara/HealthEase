import 'dart:async';
import 'package:flutter/material.dart';

/// HealthEase Splash Screen
/// - No external packages
/// - Pulsing medical emblem
/// - Auto-navigates to [next] after ~2.2s
class SplashScreen extends StatefulWidget {
  final Widget next;
  const SplashScreen({super.key, required this.next});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;
  late final Animation<double> _scale;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Breathing animation for emblem
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(parent: _ctl, curve: Curves.easeInOut),
    );

    // Navigate after a short delay
    _timer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, __, ___) => widget.next,
          transitionsBuilder: (_, anim, __, child) {
            final fade = CurvedAnimation(parent: anim, curve: Curves.easeOut);
            return FadeTransition(opacity: fade, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Soft medical gradient
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0B1220), const Color(0xFF0E2130)]
                : [cs.primary.withOpacity(0.10), const Color(0xFFEFF7F2)],
          ),
        ),
        child: Stack(
          children: [
            // Center emblem + brand
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _scale,
                    child: _MedicalEmblem(color: cs.primary),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'HealthEase',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Smart Healthcare.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),

            // Progress bar at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    color: cs.primary,
                    backgroundColor: cs.primary.withOpacity(0.15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicalEmblem extends StatelessWidget {
  final Color color;
  const _MedicalEmblem({required this.color});

  @override
  Widget build(BuildContext context) {
    // Circle with subtle inner glow + medical cross
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: color.withOpacity(0.18), width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Faint ring
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [color.withOpacity(0.12), Colors.transparent],
                stops: const [0.5, 1.0],
              ),
            ),
          ),
          // Cross icon
          Icon(
            Icons.health_and_safety_rounded,
            color: color,
            size: 44,
          ),
        ],
      ),
    );
  }
}
