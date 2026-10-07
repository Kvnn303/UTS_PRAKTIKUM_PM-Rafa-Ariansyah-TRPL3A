import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idStafController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _prosesLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // simulasi loading

    final String idStaf = _idStafController.text.trim();
    final String password = _passwordController.text.trim();

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Validasi data statis (dummy check)
    if (idStaf == 'petugas' && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            icon: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: CF.blush,
                shape: BoxShape.circle,
              ),
              child: const Icon(CfIcons.denied, color: CF.red, size: 34),
            ),
            title: const Text(
              'Akses Ditolak',
              style: TextStyle(color: CF.navy, fontWeight: FontWeight.w800),
            ),
            content: const Text(
              'ID Staf atau Kata Sandi tidak valid.\n\nHubungi supervisor Anda jika lupa kredensial.',
              textAlign: TextAlign.center,
              style: TextStyle(color: CF.muted),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CF.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _idStafController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CF.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 14),
              // Navbar mini: logo kiri
              const Align(
                alignment: Alignment.centerLeft,
                child: CfLogo(size: 24),
              ),
              const SizedBox(height: 22),
              const CfBadge('CEK ARMADA, ISI MANIFES, KARGO DIJEMPUT'),
              const SizedBox(height: 18),

              // Judul besar navy seperti hero Lincah
              const Text(
                'MANIFES KARGO\nONLINE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CF.navy,
                  fontSize: 34,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),

              // Foto armada dari assets
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: CF.shadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const CfPhoto(path: 'assets/images/Colt_Diesel.jpg'),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              CF.navy.withValues(alpha: 0.55),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 16,
                        bottom: 12,
                        child: Text(
                          'Armada siap jemput muatan Anda',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Kartu form login
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: CF.shadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masuk Staf Lapangan',
                      style: TextStyle(
                        color: CF.navy,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Gunakan kredensial dari supervisor Anda',
                      style: TextStyle(color: CF.muted, fontSize: 12.5),
                    ),
                    const SizedBox(height: 20),

                    const _Label('ID Staf'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _idStafController,
                      style: const TextStyle(color: CF.text),
                      decoration: _dekorasi('Contoh: petugas', CfIcons.staffId),
                    ),
                    const SizedBox(height: 16),

                    const _Label('Kata Sandi'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true, // kata sandi disamarkan
                      style: const TextStyle(color: CF.text),
                      decoration: _dekorasi(
                        'Masukkan kata sandi',
                        CfIcons.password,
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _prosesLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CF.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Info demo
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CF.blush,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(CfIcons.info, color: CF.red, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Demo  •  ID: petugas   Sandi: 1234',
                              style: TextStyle(color: CF.text, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '© 2026 CargoFlow Logistics',
                style: TextStyle(color: CF.muted, fontSize: 11),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Dekorasi input: ikon pendukung, hintText, focusedBorder melengkung
  InputDecoration _dekorasi(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: CF.red), // ikon pendukung
      hintText: hint, // petunjuk pengisian
      hintStyle: TextStyle(color: CF.muted.withValues(alpha: 0.7)),
      filled: true,
      fillColor: CF.bg,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: CF.line),
      ),
      // garis batas melengkung saat aktif
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: CF.red, width: 2),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: CF.navy,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
