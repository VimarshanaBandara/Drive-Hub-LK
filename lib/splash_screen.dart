import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:drive_hub_lk_srilanka/home_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _rotCtrl; // rotating border
  late final AnimationController _pulseCtrl; // pulsing rings + dots
  late final AnimationController _shimCtrl; // shimmer title

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _rotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
      lowerBound: 0,
      upperBound: 1,
    )..repeat(reverse: true);

    _shimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Navigate in ~3s
    Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeMenuScreen()),
      );
    });
  }

  @override
  void dispose() {
    _rotCtrl.dispose();
    _pulseCtrl.dispose();
    _shimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0B1220);
    const accent = Color(0xFF7C4DFF);
    const cyan = Color(0xFF00D1FF);
    const magenta = Color(0xFFFF3D9A);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Vignette + subtle starfield noise
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2),
                radius: 1.2,
                colors: [Color(0xFF0F1830), Color(0xFF0B1220)],
              ),
            ),
          ),

          // Pulsing concentric rings
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) {
              return CustomPaint(
                painter: _RingsPainter(progress: _pulseCtrl.value),
                child: const SizedBox.expand(),
              );
            },
          ),

          // Center piece
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glassy circle with rotating gradient border
                AnimatedBuilder(
                  animation: _rotCtrl,
                  builder: (context, _) {
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          startAngle: 0,
                          endAngle: math.pi * 2,
                          transform:
                              GradientRotation(_rotCtrl.value * 2 * math.pi),
                          colors: [
                            accent.withOpacity(.05),
                            magenta.withOpacity(.55),
                            cyan.withOpacity(.55),
                            accent.withOpacity(.55),
                            accent.withOpacity(.05),
                          ],
                          stops: const [0.00, 0.35, 0.60, 0.85, 1.00],
                        ),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(.06),
                              border: Border.all(
                                color: Colors.white.withOpacity(.15),
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 118,
                              height: 118,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F1526),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.30),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Image.asset(
                                'assets/app_icon/drivehublk_1024.png',
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),

                // Shimmering title
                _ShimmerText(
                  'DriveHub LK',
                  controller: _shimCtrl,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .6,
                  ),
                  colors: const [Colors.white70, Colors.white, Colors.white70],
                ),
                const SizedBox(height: 6),
                Text(
                  'Sri Lanka Driving Companion',
                  style: TextStyle(
                    color: Colors.white.withOpacity(.75),
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Bouncing dots loader
                AnimatedBuilder(
                  animation: _pulseCtrl,
                  builder: (_, __) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (i) {
                        final t = (_pulseCtrl.value + i * .2) % 1.0;
                        final dy = math.sin(t * math.pi) * 6; // bounce
                        final op =
                            .4 + (.6 * math.sin(t * math.pi).clamp(0, 1));
                        return Transform.translate(
                          offset: Offset(0, -dy),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(op),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- Painters & Helpers ----------

class _RingsPainter extends CustomPainter {
  final double progress;
  _RingsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxR = math.min(size.width, size.height) * .55;

    final rings = 3;
    for (int i = 0; i < rings; i++) {
      final t = ((progress + i * .25) % 1.0);
      final r = maxR * (.45 + .35 * t);
      final opacity = (1 - t) * .30;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(opacity * .1),
            Colors.white.withOpacity(opacity),
            Colors.transparent,
          ],
          stops: const [0.70, 0.98, 1.00],
        ).createShader(Rect.fromCircle(center: center, radius: r));

      canvas.drawCircle(center, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _ShimmerText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final AnimationController controller;

  const _ShimmerText(
    this.text, {
    required this.controller,
    required this.style,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final shift = controller.value; // 0..1
        return ShaderMask(
          shaderCallback: (rect) {
            final w = rect.width;
            return LinearGradient(
              begin: Alignment(-1 + 2 * shift, 0),
              end: Alignment(1 + 2 * shift, 0),
              colors: colors,
              stops: const [0.35, 0.5, 0.65],
            ).createShader(rect);
          },
          child: Text(
            text,
            style: style.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}
