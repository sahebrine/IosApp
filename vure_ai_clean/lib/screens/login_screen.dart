import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vure_dashboard/widgets/animated_gradient_button_login.dart';
import '../services/api_client.dart';
import 'dashboard_screen.dart';

/// =======================================================
/// BACKGROUND – Smooth Animated Aurora (احترافي)
/// =======================================================
class VureAnimatedBackground extends StatefulWidget {
  const VureAnimatedBackground({super.key});

  @override
  State<VureAnimatedBackground> createState() => _VureAnimatedBackgroundState();
}

class _VureAnimatedBackgroundState extends State<VureAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14), // حركة بطيئة ناعمة
    )..repeat(reverse: true);

    _anim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                -0.6 + (_anim.value * 1.2),
                -0.4 + (_anim.value * 0.8),
              ),
              radius: 1.2,
              colors: const [
                Color(0xFF7C4DFF),
                Color(0xFF3B1A7A),
                Color(0xFF0B1020),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// =======================================================
/// LOGIN SCREEN
/// =======================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool loading = false;
  String? error;

  Future<void> login() async {
    if (usernameCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      setState(() {
        error = "يرجى إدخال اسم المستخدم وكلمة المرور";
      });
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      final ok = await ApiClient.login(
        usernameCtrl.text,
        passwordCtrl.text,
      );

      if (ok) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(
              username: usernameCtrl.text,
            ),
          ),
        );
      } else {
        setState(() {
          error = "اسم المستخدم أو كلمة المرور غير صحيحة";
        });
      }
    } catch (_) {
      setState(() {
        error = "تعذر الاتصال بالخادم، حاول لاحقًا";
      });
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: VureAnimatedBackground()),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: 420,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 34,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B1020).withOpacity(0.75),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: Colors.white12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.45),
                      blurRadius: 40,
                      offset: const Offset(0, 25),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// LOGO
                    Image.network(
                      "https://image2url.com/images/1765682676461-38f0310c-49ef-4ca7-86a4-45c8c8732eba.png",
                      height: 80,
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      "Vure Ai Dashboard",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: .4,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "تسجيل الدخول الآمن",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// USERNAME
                    _inputField(
                      controller: usernameCtrl,
                      label: "اسم المستخدم",
                      obscure: false,
                    ),

                    const SizedBox(height: 14),

                    /// PASSWORD
                    _inputField(
                      controller: passwordCtrl,
                      label: "كلمة المرور",
                      obscure: true,
                    ),

                    const SizedBox(height: 18),

                    if (error != null)
                      Text(
                        error!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                      ),

                    const SizedBox(height: 18),

                    /// LOGIN BUTTON
                    AnimatedGradientButton(
                      text: "دخول",
                      loading: loading,
                      onPressed: login,
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      "Vure Ai © 2025",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ================= INPUT FIELD =================
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF111827),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
