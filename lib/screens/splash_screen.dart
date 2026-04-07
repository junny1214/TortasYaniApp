import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loaderController;
  late AnimationController _floatController;

  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _loaderFade;
  late Animation<double> _floatAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _glowAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _loaderFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _loaderController, curve: Curves.easeOut),
    );

    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Secuencia de animaciones
    _logoController.forward().then((_) {
      _textController.forward().then((_) {
        _loaderController.forward();
      });
    });

    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, anim, __, child) {
              return FadeTransition(opacity: anim, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loaderController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF0F5), // blush rosado
              Color(0xFFFFF8F0), // crema almendra
              Color(0xFFFFE4EC), // melocotón claro
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── Círculos decorativos de fondo ──
            _buildBgCircle(
                top: -60,
                left: -60,
                size: 220,
                color: const Color(0xFFFFD6E7).withOpacity(0.5)),
            _buildBgCircle(
                bottom: -80,
                right: -80,
                size: 280,
                color: const Color(0xFFFFCCE0).withOpacity(0.4)),
            _buildBgCircle(
                top: 100,
                right: -40,
                size: 140,
                color: const Color(0xFFFFC8A0).withOpacity(0.3)),
            _buildBgCircle(
                bottom: 160,
                left: -30,
                size: 100,
                color: const Color(0xFFFFB5C8).withOpacity(0.35)),

            // ── Partículas decorativas flotantes ──
            AnimatedBuilder(
              animation: _floatController,
              builder: (_, __) => Stack(
                children: [
                  _buildParticle(
                      top: 120,
                      left: 40,
                      offset: _floatAnim.value * 0.8,
                      icon: Iconsax.star5,
                      color: const Color(0xFFFFAEC0),
                      size: 16),
                  _buildParticle(
                      top: 200,
                      right: 50,
                      offset: -_floatAnim.value,
                      icon: Icons.favorite,
                      color: const Color(0xFFF7A0B0),
                      size: 13),
                  _buildParticle(
                      bottom: 220,
                      left: 60,
                      offset: _floatAnim.value * 0.6,
                      icon: Iconsax.star5,
                      color: const Color(0xFFFFCBA0),
                      size: 11),
                  _buildParticle(
                      bottom: 150,
                      right: 40,
                      offset: -_floatAnim.value * 0.7,
                      icon: Icons.spa_rounded,
                      color: const Color(0xFFFFB5C8),
                      size: 15),
                  _buildParticle(
                      top: 300,
                      left: 20,
                      offset: _floatAnim.value,
                      icon: Icons.circle,
                      color: const Color(0xFFF9C0D0).withOpacity(0.6),
                      size: 8),
                  _buildParticle(
                      top: 250,
                      right: 25,
                      offset: -_floatAnim.value * 0.5,
                      icon: Icons.circle,
                      color: const Color(0xFFFFD4A0).withOpacity(0.6),
                      size: 10),
                ],
              ),
            ),

            // ── Contenido central ──
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animado
                AnimatedBuilder(
                  animation:
                      Listenable.merge([_logoController, _floatController]),
                  builder: (_, __) {
                    return FadeTransition(
                      opacity: _fadeAnim,
                      child: Transform.translate(
                        offset: Offset(0, _floatAnim.value * 0.4),
                        child: ScaleTransition(
                          scale: _scaleAnim,
                          child: _buildLogo(),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 36),

                // Nombre de la marca
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        const Text(
                          "Tortas Yani",
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF7A3A52),
                            letterSpacing: 1.2,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 1.5,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFFE88EA0)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Endulzando tus momentos",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFB07888),
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 40,
                              height: 1.5,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFE88EA0),
                                    Colors.transparent
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),

                // Indicador de carga
                FadeTransition(
                  opacity: _loaderFade,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFFE88EA0).withOpacity(0.8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Preparando algo especial...",
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFFB07888).withOpacity(0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, __) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    const Color(0xFFF7A0B8).withOpacity(0.3 * _glowAnim.value),
                blurRadius: 40,
                spreadRadius: 10,
              ),
              BoxShadow(
                color:
                    const Color(0xFFFFD4A0).withOpacity(0.2 * _glowAnim.value),
                blurRadius: 60,
                spreadRadius: 20,
              ),
              BoxShadow(
                color: const Color(0xFFFFB5C8).withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: CustomPaint(
              painter: _CakePainter(),
              size: const Size(106, 106),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBgCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }

  Widget _buildParticle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double offset,
    required IconData icon,
    required Color color,
    required double size,
  }) {
    return Positioned(
      top: top != null ? top + offset : null,
      bottom: bottom != null ? bottom + offset : null,
      left: left,
      right: right,
      child: Icon(icon, color: color, size: size),
    );
  }
}

class _CakePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // === Base / plato ===
    final platePaint = Paint()
      ..color = const Color(0xFFF5D5C0)
      ..style = PaintingStyle.fill;
    final plateRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.05, h * 0.82, w * 0.90, h * 0.12),
      const Radius.circular(6),
    );
    canvas.drawRRect(plateRect, platePaint);

    // === Cuerpo de la torta (base) ===
    final bodyPaint = Paint()
      ..color = const Color(0xFFFFCCDD)
      ..style = PaintingStyle.fill;
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.55, w * 0.80, h * 0.30),
      const Radius.circular(8),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // === Franja de crema (cuerpo) ===
    final creamBodyPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(w * 0.10, h * 0.65, w * 0.80, h * 0.06),
      creamBodyPaint,
    );

    // === Cuerpo segundo piso ===
    final tier2Paint = Paint()
      ..color = const Color(0xFFFDB8CE)
      ..style = PaintingStyle.fill;
    final tier2Rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.20, h * 0.30, w * 0.60, h * 0.27),
      const Radius.circular(7),
    );
    canvas.drawRRect(tier2Rect, tier2Paint);

    // === Franja crema piso 2 ===
    canvas.drawRect(
      Rect.fromLTWH(w * 0.20, h * 0.40, w * 0.60, h * 0.05),
      creamBodyPaint,
    );

    // === Chantilly ondulado (top del piso 1) ===
    _drawWavyFrosting(
        canvas, w * 0.10, h * 0.55, w * 0.80, h, const Color(0xFFFFF0F5));

    // === Chantilly ondulado (top del piso 2) ===
    _drawWavyFrosting(
        canvas, w * 0.20, h * 0.30, w * 0.60, h, const Color(0xFFFFF5F8));

    // === Vela central ===
    final candlePaint = Paint()
      ..color = const Color(0xFFFFAED0)
      ..style = PaintingStyle.fill;
    final candleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.455, h * 0.13, w * 0.09, h * 0.18),
      const Radius.circular(4),
    );
    canvas.drawRRect(candleRect, candlePaint);

    // Rayas de la vela
    final stripePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        Offset(w * 0.455, h * 0.17), Offset(w * 0.545, h * 0.17), stripePaint);
    canvas.drawLine(
        Offset(w * 0.455, h * 0.22), Offset(w * 0.545, h * 0.22), stripePaint);
    canvas.drawLine(
        Offset(w * 0.455, h * 0.27), Offset(w * 0.545, h * 0.27), stripePaint);

    // === Llama de la vela ===
    final flamePath = Path();
    final fx = w * 0.50;
    final fy = h * 0.13;
    flamePath.moveTo(fx, fy - h * 0.01);
    flamePath.cubicTo(
      fx + w * 0.04,
      fy - h * 0.07,
      fx + w * 0.06,
      fy - h * 0.10,
      fx,
      fy - h * 0.14,
    );
    flamePath.cubicTo(
      fx - w * 0.06,
      fy - h * 0.10,
      fx - w * 0.04,
      fy - h * 0.07,
      fx,
      fy - h * 0.01,
    );
    flamePath.close();

    // Gradiente de llama
    final flameRect =
        Rect.fromLTWH(fx - w * 0.06, fy - h * 0.14, w * 0.12, h * 0.13);
    final flamePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFFFFF176), const Color(0xFFFF9800)],
      ).createShader(flameRect);
    canvas.drawPath(flamePath, flamePaint);

    // Brillo de la llama
    final flameGlowPaint = Paint()
      ..color = const Color(0xFFFFCC02).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(flamePath, flameGlowPaint);

    // === Perlas decorativas ===
    _drawPearls(canvas, w, h);
  }

  void _drawWavyFrosting(Canvas canvas, double startX, double startY,
      double width, double totalH, Color color) {
    final path = Path();
    final waveH = totalH * 0.055;
    final count = 6;
    final segmentW = width / count;
    path.moveTo(startX, startY);
    for (int i = 0; i < count; i++) {
      path.cubicTo(
        startX + segmentW * i + segmentW * 0.25,
        startY - waveH,
        startX + segmentW * i + segmentW * 0.75,
        startY - waveH,
        startX + segmentW * (i + 1),
        startY,
      );
    }
    path.lineTo(startX + width, startY + totalH * 0.04);
    path.lineTo(startX, startY + totalH * 0.04);
    path.close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  void _drawPearls(Canvas canvas, double w, double h) {
    final pearlPaint = Paint()
      ..color = const Color(0xFFFF8FAD)
      ..style = PaintingStyle.fill;

    final positions = [
      Offset(w * 0.15, h * 0.59),
      Offset(w * 0.27, h * 0.59),
      Offset(w * 0.39, h * 0.59),
      Offset(w * 0.51, h * 0.59),
      Offset(w * 0.63, h * 0.59),
      Offset(w * 0.75, h * 0.59),
      Offset(w * 0.87, h * 0.59),
      Offset(w * 0.25, h * 0.345),
      Offset(w * 0.38, h * 0.345),
      Offset(w * 0.50, h * 0.345),
      Offset(w * 0.63, h * 0.345),
      Offset(w * 0.76, h * 0.345),
    ];

    for (final pos in positions) {
      canvas.drawCircle(pos, 3.5, pearlPaint);
      canvas.drawCircle(
        pos - const Offset(1, 1),
        1.2,
        Paint()..color = Colors.white.withOpacity(0.7),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
