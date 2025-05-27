import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'home_page.dart';

class AnimatedNoise extends StatefulWidget {
  final Color color;
  final double density; // jumlah titik
  final double maxOpacity;
  final double dotRadius;

  const AnimatedNoise({
    Key? key,
    this.color = const Color(0xFFCCCCCC),
    this.density = 5000,
    this.maxOpacity = 0.15,
    this.dotRadius = 0.8,
  }) : super(key: key);

  @override
  State<AnimatedNoise> createState() => _AnimatedNoiseState();
}

class _AnimatedNoiseState extends State<AnimatedNoise> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> points;
  late List<double> opacities;
  late List<double> baseXOffsets;
  late List<double> baseYOffsets;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    // Buat titik-titik noise random
    points = List.generate(widget.density.toInt(), (index) => Offset(random.nextDouble(), random.nextDouble()));
    opacities = List.generate(widget.density.toInt(), (index) => random.nextDouble());
    baseXOffsets = List.generate(widget.density.toInt(), (index) => random.nextDouble());
    baseYOffsets = List.generate(widget.density.toInt(), (index) => random.nextDouble());

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _NoisePainter(
              points: points,
              opacities: opacities,
              baseXOffsets: baseXOffsets,
              baseYOffsets: baseYOffsets,
              animationValue: _controller.value,
              color: widget.color,
              maxOpacity: widget.maxOpacity,
              dotRadius: widget.dotRadius,
            ),
          );
        },
      );
    });
  }
}

class _NoisePainter extends CustomPainter {
  final List<Offset> points;
  final List<double> opacities;
  final List<double> baseXOffsets;
  final List<double> baseYOffsets;
  final double animationValue;
  final Color color;
  final double maxOpacity;
  final double dotRadius;

  _NoisePainter({
    required this.points,
    required this.opacities,
    required this.baseXOffsets,
    required this.baseYOffsets,
    required this.animationValue,
    required this.color,
    required this.maxOpacity,
    required this.dotRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int i = 0; i < points.length; i++) {
      // Gerakkan titik sedikit berdasarkan animationValue untuk efek hidup
      final dx = (points[i].dx * size.width + sin(animationValue * 2 * pi + baseXOffsets[i] * 10) * 2) % size.width;
      final dy = (points[i].dy * size.height + cos(animationValue * 2 * pi + baseYOffsets[i] * 10) * 2) % size.height;

      final opacity = (opacities[i] * maxOpacity).clamp(0.05, maxOpacity);

      paint.color = color.withOpacity(opacity);
      canvas.drawCircle(Offset(dx, dy), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) => true;
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2000);

  Future<String?> _authUser(LoginData data) async {
    await Future.delayed(loginTime);
    if (data.password != '123456') {
      return 'Password salah. Gunakan "123456"';
    }
    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    await Future.delayed(loginTime);
    if ((data.name ?? '').isEmpty || (data.password ?? '').isEmpty) {
      return 'Email dan password tidak boleh kosong';
    }
    return null;
  }

  Future<String?> _recoverPassword(String name) async {
    await Future.delayed(loginTime);
    return null;
  }

  Widget _buildSoftGlassEffect({BorderRadius? borderRadius}) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: borderRadius ?? BorderRadius.zero,
            border: Border.all(
              color: Colors.white.withOpacity(0.16),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration({required bool isCompact}) {
    return Container(
      color: Colors.blue[800],
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: _buildSoftGlassEffect(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isCompact ? 350 : 700,
                maxHeight: isCompact ? 350 : 700,
                minWidth: 300,
                minHeight: 300,
              ),
              child: Lottie.asset(
                'assets/loginanimation.json',
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: isCompact ? 120 : 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue[800]!.withOpacity(0),
                    Colors.blue[800]!.withOpacity(0.75),
                    Colors.blue[800]!,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: isCompact ? 16 : 24,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jaga Kesehatan Mentalmu",
                  style: GoogleFonts.poppins(
                    fontSize: isCompact ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Kesehatan mental sama pentingnya dengan kesehatan fisik. Mari mulai perjalananmu menuju versi terbaik dirimu hari ini.",
                  style: GoogleFonts.poppins(
                    fontSize: isCompact ? 14 : 16,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isWideScreen = screenWidth > 800;
    final bool isMediumScreen = screenWidth > 500 && screenWidth <= 800;

    if (isWideScreen) {
      return Scaffold(
        body: Stack(
          children: [
            const AnimatedNoise(color: Color(0xFFAAAAAA), density: 4000, maxOpacity: 0.15, dotRadius: 0.8),
            SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.blue[800],
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: _buildSoftGlassEffect(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          FlutterLogin(
                            title: 'Mental Health',
                            onLogin: _authUser,
                            onSignup: _signupUser,
                            onRecoverPassword: _recoverPassword,
                            onSubmitAnimationCompleted: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => const HomePage()),
                              );
                            },
                            messages: LoginMessages(
                              userHint: 'Email',
                              passwordHint: 'Password',
                              confirmPasswordHint: 'Konfirmasi Password',
                              loginButton: 'Masuk',
                              signupButton: 'Daftar',
                              forgotPasswordButton: 'Lupa Password?',
                              recoverPasswordButton: 'Kirim',
                              goBackButton: 'Kembali',
                              recoverPasswordIntro: 'Kami akan mengirimkan link reset password ke email Anda.',
                              recoverPasswordDescription: 'Periksa email Anda untuk melanjutkan.',
                              recoverPasswordSuccess: 'Email pemulihan berhasil dikirim!',
                              flushbarTitleError: 'Terjadi Kesalahan',
                              flushbarTitleSuccess: 'Berhasil',
                            ),
                            theme: LoginTheme(
                              primaryColor: Colors.blue[800]!,
                              accentColor: Colors.white,
                              pageColorLight: Colors.blue[800]!,
                              pageColorDark: Colors.blue[700]!,
                              titleStyle: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              bodyStyle: GoogleFonts.poppins(color: Colors.black),
                              textFieldStyle: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              buttonStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              cardTheme: CardTheme(
                                color: Colors.white,
                                elevation: 6,
                                margin: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              inputTheme: InputDecorationTheme(
                                filled: true,
                                fillColor: Colors.grey[100],
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(color: Colors.blue),
                                ),
                              ),
                              buttonTheme: LoginButtonTheme(
                                backgroundColor: Colors.blue.shade600,
                                highlightColor: Colors.blue.shade100,
                                splashColor: Colors.grey.withOpacity(0.15),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              footerTextStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 60,
                            left: 32,
                            right: 32,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome Back!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Selamat datang kembali di Mental Health App.\n'
                                  'Masuk untuk melanjutkan perjalanan Anda\n'
                                  'menuju kesehatan mental yang lebih baik.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildIllustration(isCompact: false),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (isMediumScreen) {
      return Scaffold(
        body: Stack(
          children: [
            const AnimatedNoise(color: Color(0xFFAAAAAA), density: 4000, maxOpacity: 0.15, dotRadius: 0.8),
            SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildIllustration(isCompact: true),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.blue[800],
                      child: FlutterLogin(
                        title: 'Mental Health',
                        onLogin: _authUser,
                        onSignup: _signupUser,
                        onRecoverPassword: _recoverPassword,
                        onSubmitAnimationCompleted: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        messages: LoginMessages(
                          userHint: 'Email',
                          passwordHint: 'Password',
                          confirmPasswordHint: 'Konfirmasi Password',
                          loginButton: 'Masuk',
                          signupButton: 'Daftar',
                          forgotPasswordButton: 'Lupa Password?',
                          recoverPasswordButton: 'Kirim',
                          goBackButton: 'Kembali',
                          recoverPasswordIntro: 'Kami akan mengirimkan link reset password ke email Anda.',
                          recoverPasswordDescription: 'Periksa email Anda untuk melanjutkan.',
                          recoverPasswordSuccess: 'Email pemulihan berhasil dikirim!',
                          flushbarTitleError: 'Terjadi Kesalahan',
                          flushbarTitleSuccess: 'Berhasil',
                        ),
                        theme: LoginTheme(
                          primaryColor: Colors.blue[800]!,
                          accentColor: Colors.white,
                          pageColorLight: Colors.blue[800]!,
                          pageColorDark: Colors.blue[700]!,
                          titleStyle: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          bodyStyle: GoogleFonts.poppins(color: Colors.black),
                          textFieldStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          buttonStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          cardTheme: CardTheme(
                            color: Colors.white,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          inputTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.grey[100],
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
                            hintStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                          buttonTheme: LoginButtonTheme(
                            backgroundColor: Colors.blue[700]!,
                            highlightColor: Colors.blue[900],
                            splashColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          footerTextStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
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
    } else {
      return Scaffold(
        backgroundColor: Colors.blue[800],
        body: Stack(
          children: [
            const AnimatedNoise(color: Color(0xFFAAAAAA), density: 4000, maxOpacity: 0.15, dotRadius: 0.8),
            SafeArea(
              child: SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 7,
                      child: FlutterLogin(
                        title: 'Mental Health',
                        onLogin: _authUser,
                        onSignup: _signupUser,
                        onRecoverPassword: _recoverPassword,
                        onSubmitAnimationCompleted: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        },
                        messages: LoginMessages(
                          userHint: 'Email',
                          passwordHint: 'Password',
                          confirmPasswordHint: 'Konfirmasi Password',
                          loginButton: 'Masuk',
                          signupButton: 'Daftar',
                          forgotPasswordButton: 'Lupa Password?',
                          recoverPasswordButton: 'Kirim',
                          goBackButton: 'Kembali',
                          recoverPasswordIntro: 'Kami akan mengirimkan link reset password ke email Anda.',
                          recoverPasswordDescription: 'Periksa email Anda untuk melanjutkan.',
                          recoverPasswordSuccess: 'Email pemulihan berhasil dikirim!',
                          flushbarTitleError: 'Terjadi Kesalahan',
                          flushbarTitleSuccess: 'Berhasil',
                        ),
                        theme: LoginTheme(
                          primaryColor: Colors.blue[800]!,
                          accentColor: Colors.white,
                          pageColorLight: Colors.blue[800]!,
                          pageColorDark: Colors.blue[700]!,
                          titleStyle: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          bodyStyle: GoogleFonts.poppins(color: Colors.black),
                          textFieldStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          buttonStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          cardTheme: CardTheme(
                            color: Colors.white,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          inputTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.grey[100],
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
                            hintStyle: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                          buttonTheme: LoginButtonTheme(
                            backgroundColor: Colors.blue[700]!,
                            highlightColor: Colors.blue[900],
                            splashColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          footerTextStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Flexible(
                      flex: 5,
                      child: Container(
                        color: Colors.blue[800],
                        child: Center(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: _buildSoftGlassEffect(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              Positioned.fill(
                                child: Lottie.asset(
                                  'assets/loginanimation.json',
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              Positioned(
                                bottom: 24,
                                left: 24,
                                right: 24,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Jaga Kesehatan Mentalmu",
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Kesehatan mental sama pentingnya dengan kesehatan fisik. Mari mulai perjalananmu menuju versi terbaik dirimu hari ini.",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
