// ============================================================
// FILE: lib/UTS_Praktikum/app_theme.dart
// DESKRIPSI: Identitas visual CargoFlow bergaya Ninja Xpress
//            (merah + navy + latar pink lembut, tombol pil)
// ============================================================

import 'package:flutter/material.dart';

class CF {
  CF._();

  // Palet inti (mengacu ke hero Lincah x Ninja Xpress)
  static const Color red = Color(0xFFC8102E); // merah Ninja
  static const Color redDark = Color(0xFF9E0B24);
  static const Color navy = Color(0xFF0F1B33); // judul tebal
  static const Color bg = Color(0xFFFBF1F2); // pink sangat lembut
  static const Color blush = Color(0xFFFDE4E7); // aksen chip/ikon
  static const Color text = Color(0xFF1B2335);
  static const Color muted = Color(0xFF6B7280);
  static const Color line = Color(0xFFEBD9DC);
  static const Color blue = Color(0xFF4C84F5); // aksen batang biru hero
  static const Color green = Color(0xFF1E9E5A);
  static const Color amber = Color(0xFFE89B0C);

  static const LinearGradient hero = LinearGradient(
    colors: [red, redDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData theme() => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: red, primary: red),
    scaffoldBackgroundColor: bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: navy,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
  );

  static List<BoxShadow> get shadow => [
    BoxShadow(
      color: red.withValues(alpha: 0.08),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  /// Foto armada dari assets/images (nama file sesuai folder assets)
  static String fotoArmada(String nama) {
    switch (nama) {
      case 'Fuso':
        return 'assets/images/fuso.jpg';
      case 'Tronton':
        return 'assets/images/tronton.jpg';
      default:
        return 'assets/images/Colt_Diesel.jpg';
    }
  }

  static IconData ikonArmada(String nama) {
    switch (nama) {
      case 'Fuso':
        return CfIcons.fuso;
      case 'Tronton':
        return CfIcons.tronton;
      default:
        return CfIcons.colt;
    }
  }
}

/// Foto dari assets; bila file belum ada, tampil blok merah + ikon
class CfPhoto extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final IconData fallbackIcon;

  const CfPhoto({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.local_shipping_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(gradient: CF.hero),
        child: Center(
          child: Icon(fallbackIcon, color: Colors.white70, size: 40),
        ),
      ),
    );
  }
}

/// Badge pil putih berhuruf kapital merah (seperti di hero Lincah)
class CfBadge extends StatelessWidget {
  final String label;
  const CfBadge(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: CF.shadow,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: CF.red,
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.6,
        ),
      ),
    );
  }
}

/// Logo aplikasi: memakai assets/images/Ninja.jpg, fallback ke wordmark teks
class CfLogo extends StatelessWidget {
  final double size;
  final Color color;
  const CfLogo({super.key, this.size = 22, this.color = CF.red});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        'assets/images/Ninja.jpg',
        height: size + 14,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CfIcons.brand, color: color, size: size + 2),
            const SizedBox(width: 6),
            Text(
              'CARGOFLOW',
              style: TextStyle(
                color: color,
                fontSize: size,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Satu set ikon konsisten (gaya rounded) dipusatkan di sini
class CfIcons {
  CfIcons._();

  static const IconData brand = Icons.hub_rounded;
  static const IconData staffId = Icons.badge_rounded;
  static const IconData password = Icons.key_rounded;
  static const IconData show = Icons.visibility_rounded;
  static const IconData hide = Icons.visibility_off_rounded;
  static const IconData info = Icons.tips_and_updates_rounded;
  static const IconData denied = Icons.gpp_bad_rounded;

  static const IconData parcel = Icons.inventory_2_rounded;
  static const IconData fleet = Icons.local_shipping_rounded;
  static const IconData route = Icons.route_rounded;

  static const IconData manifest = Icons.assignment_rounded;
  static const IconData receipt = Icons.fact_check_rounded;
  static const IconData depot = Icons.warehouse_rounded;
  static const IconData notif = Icons.notifications_active_rounded;
  static const IconData dashboard = Icons.space_dashboard_rounded;
  static const IconData help = Icons.support_agent_rounded;
  static const IconData logout = Icons.logout_rounded;
  static const IconData plate = Icons.pin_rounded;

  static const IconData colt = Icons.airport_shuttle_rounded;
  static const IconData fuso = Icons.local_shipping_rounded;
  static const IconData tronton = Icons.rv_hookup_rounded;
  static const IconData pick = Icons.touch_app_rounded;

  static const IconData hazard = Icons.crisis_alert_rounded;
  static const IconData flammable = Icons.local_fire_department_rounded;
  static const IconData toxic = Icons.science_rounded;
  static const IconData cold = Icons.ac_unit_rounded;

  static const IconData address = Icons.pin_drop_rounded;
  static const IconData api = Icons.terminal_rounded;
  static const IconData contact = Icons.headset_mic_rounded;

  static const IconData cargo = Icons.category_rounded;
  static const IconData protect = Icons.verified_user_rounded;
  static const IconData schedule = Icons.event_available_rounded;
  static const IconData date = Icons.calendar_month_rounded;
  static const IconData time = Icons.schedule_rounded;
  static const IconData weight = Icons.scale_rounded;
  static const IconData reefer = Icons.thermostat_rounded;
  static const IconData calc = Icons.calculate_rounded;
  static const IconData waybill = Icons.receipt_long_rounded;
  static const IconData success = Icons.task_alt_rounded;
}

/// Kartu seksi form: ikon di kotak pink, judul tebal navy
class CfSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final Widget child;

  const CfSection({
    super.key,
    required this.title,
    required this.icon,
    this.accent = CF.red,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: CF.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: accent),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: CF.navy,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
            child: child,
          ),
        ],
      ),
    );
  }
}
