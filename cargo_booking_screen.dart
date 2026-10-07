import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'grouped_buttons.dart';

class CargoBookingScreen extends StatefulWidget {
  final String namaArmada; // data yang dikirim dari layar utama

  const CargoBookingScreen({super.key, required this.namaArmada});

  @override
  State<CargoBookingScreen> createState() => _CargoBookingScreenState();
}

class _CargoBookingScreenState extends State<CargoBookingScreen> {
  String _kategoriMuatan = 'General Cargo';
  final List<String> _opsiKategori = [
    'General Cargo',
    'Makanan Beku/Perishable',
    'Alat Berat',
  ];

  final List<String> _opsiLayanan = [
    'Asuransi Barang Rusak',
    'Jasa Forklift Muat',
    'Pengawalan Prioritas',
  ];
  List<String> _layananDipilih = [];

  DateTime? _tanggalPengambilan;
  TimeOfDay? _jamKeberangkatan;
  double _tonase = 1.0;
  bool _reeferAktif = false;

  ThemeData _temaPicker(BuildContext context) {
    return Theme.of(context).copyWith(
      colorScheme: const ColorScheme.light(
        primary: CF.red,
        onPrimary: Colors.white,
        onSurface: CF.text,
      ),
    );
  }

  Future<void> _pilihTanggal() async {
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      helpText: 'Pilih Tanggal Penjemputan',
      builder: (context, child) =>
          Theme(data: _temaPicker(context), child: child!),
    );
    if (tanggal != null) {
      setState(() => _tanggalPengambilan = tanggal);
    }
  }

  Future<void> _pilihJam() async {
    final TimeOfDay? jam = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Pilih Estimasi Jam Keberangkatan',
      builder: (context, child) =>
          Theme(data: _temaPicker(context), child: child!),
    );
    if (jam != null) {
      setState(() => _jamKeberangkatan = jam);
    }
  }

  int _hitungBiaya() {
    int hargaDasar;
    switch (_kategoriMuatan) {
      case 'Makanan Beku/Perishable':
        hargaDasar = 500000;
        break;
      case 'Alat Berat':
        hargaDasar = 1000000;
        break;
      default:
        hargaDasar = 250000;
    }

    final int biayaTonase = (_tonase * 75000).round();
    int biayaTambahan = 0;
    if (_layananDipilih.contains('Asuransi Barang Rusak')) {
      biayaTambahan += 150000;
    }
    if (_layananDipilih.contains('Jasa Forklift Muat')) {
      biayaTambahan += 200000;
    }
    if (_layananDipilih.contains('Pengawalan Prioritas')) {
      biayaTambahan += 350000;
    }

    final int biayaReefer = _reeferAktif ? 300000 : 0;

    return hargaDasar + biayaTonase + biayaTambahan + biayaReefer;
  }

  String _formatRupiah(int jumlah) {
    final String str = jumlah.toString();
    String hasil = '';
    int counter = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (counter == 3) {
        hasil = '.$hasil';
        counter = 0;
      }
      hasil = str[i] + hasil;
      counter++;
    }
    return 'Rp $hasil';
  }

  String _formatTanggal(DateTime d) => '${d.day}/${d.month}/${d.year}';

  // ── Bottom Sheet rincian biaya ─────────────────────────────
  void _tampilkanRincianBiaya() {
    if (_tanggalPengambilan == null || _jamKeberangkatan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Harap pilih tanggal dan jam pengambilan!'),
          backgroundColor: CF.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    final int totalBiaya = _hitungBiaya();
    final List<String> layanan = List.from(_layananDipilih);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: CF.line,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: CF.blush,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(CfIcons.waybill, color: CF.red),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Rincian Biaya Logistik',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: CF.navy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _barisRincian('Armada', widget.namaArmada),
                _barisRincian('Kategori', _kategoriMuatan),
                _barisRincian('Tonase', '${_tonase.toStringAsFixed(1)} Ton'),
                _barisRincian(
                  'Penjemputan',
                  '${_formatTanggal(_tanggalPengambilan!)} • ${_jamKeberangkatan!.format(context)}',
                ),
                if (_reeferAktif)
                  _barisRincian('Reefer', 'Aktif (+Rp 300.000)'),
                if (layanan.isNotEmpty)
                  _barisRincian('Proteksi', layanan.join(', ')),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: CF.hero,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL ESTIMASI',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        _formatRupiah(totalBiaya),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _tampilkanDialogKonfirmasi(totalBiaya);
                    },
                    icon: const Icon(CfIcons.waybill),
                    label: const Text(
                      'Terbitkan Surat Jalan',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CF.navy,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _barisRincian(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: CF.muted, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              nilai,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: CF.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── AlertDialog konfirmasi + kirim data balik ──────────────
  void _tampilkanDialogKonfirmasi(int totalBiaya) {
    final String noResi =
        'CFX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
            child: const Icon(CfIcons.success, color: CF.red, size: 34),
          ),
          title: const Text(
            'Terbitkan Surat Jalan?',
            style: TextStyle(fontWeight: FontWeight.w900, color: CF.navy),
          ),
          content: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CF.bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No. Resi: $noResi',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: CF.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Armada: ${widget.namaArmada}',
                  style: const TextStyle(color: CF.text),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: ${_formatRupiah(totalBiaya)}',
                  style: const TextStyle(
                    color: CF.red,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal', style: TextStyle(color: CF.muted)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // tutup dialog
                // tutup form + kirim data status resi sukses ke layar utama
                Navigator.pop(
                  context,
                  'Surat jalan $noResi berhasil diterbitkan!',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CF.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Terbitkan',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CF.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: CF.navy,
        elevation: 0,
        title: const Text(
          'Buat Manifes Baru',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge + banner foto armada terpilih (data dari layar utama)
            const Center(child: CfBadge('ARMADA TERPILIH')),
            const SizedBox(height: 14),
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
                    CfPhoto(
                      path: CF.fotoArmada(widget.namaArmada),
                      fallbackIcon: CF.ikonArmada(widget.namaArmada),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            CF.navy.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      bottom: 14,
                      child: Text(
                        widget.namaArmada,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kategori Muatan (RadioButtonGroup)
            CfSection(
              title: 'Kategori Muatan',
              icon: CfIcons.cargo,
              child: RadioButtonGroup(
                labels: _opsiKategori,
                picked: _kategoriMuatan,
                activeColor: CF.red,
                labelStyle: const TextStyle(fontSize: 14, color: CF.text),
                onSelected: (String selected) {
                  setState(() => _kategoriMuatan = selected);
                },
              ),
            ),

            // Proteksi Pengiriman (CheckboxGroup)
            CfSection(
              title: 'Proteksi Pengiriman',
              icon: CfIcons.protect,
              child: CheckboxGroup(
                labels: _opsiLayanan,
                checked: _layananDipilih,
                activeColor: CF.red,
                labelStyle: const TextStyle(fontSize: 14, color: CF.text),
                onSelected: (List<String> dipilih) {
                  setState(() => _layananDipilih = dipilih);
                },
              ),
            ),

            // Jadwal Pengambilan (DatePicker + TimePicker)
            CfSection(
              title: 'Jadwal Pengambilan',
              icon: CfIcons.schedule,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: _tileWaktu(
                        icon: CfIcons.date,
                        label: 'Tanggal',
                        nilai: _tanggalPengambilan == null
                            ? 'Pilih tanggal'
                            : _formatTanggal(_tanggalPengambilan!),
                        onTap: _pilihTanggal,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _tileWaktu(
                        icon: CfIcons.time,
                        label: 'Jam Berangkat',
                        nilai: _jamKeberangkatan == null
                            ? 'Pilih jam'
                            : _jamKeberangkatan!.format(context),
                        onTap: _pilihJam,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pengaturan Muatan (Slider + Switch)
            CfSection(
              title: 'Pengaturan Muatan',
              icon: CfIcons.weight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estimasi Tonase',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: CF.navy,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: CF.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_tonase.toStringAsFixed(1)} Ton',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Slider(
                    value: _tonase,
                    min: 0.5,
                    max: 20.0,
                    divisions: 39,
                    label: '${_tonase.toStringAsFixed(1)} Ton',
                    activeColor: CF.red,
                    inactiveColor: CF.red.withValues(alpha: 0.2),
                    onChanged: (value) => setState(() => _tonase = value),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Min 0,5 Ton',
                          style: TextStyle(color: CF.muted, fontSize: 11),
                        ),
                        Text(
                          'Maks 20 Ton',
                          style: TextStyle(color: CF.muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 24, color: CF.line),
                  ListTile(
                    leading: Icon(
                      CfIcons.reefer,
                      color: _reeferAktif ? CF.red : CF.muted,
                    ),
                    title: const Text(
                      'Reefer Container',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: CF.navy,
                      ),
                    ),
                    subtitle: Text(
                      _reeferAktif
                          ? 'Pendingin aktif (+Rp 300.000)'
                          : 'Pendingin nonaktif',
                      style: TextStyle(
                        color: _reeferAktif ? CF.red : CF.muted,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Switch(
                      value: _reeferAktif,
                      activeTrackColor: CF.red,
                      onChanged: (bool value) =>
                          setState(() => _reeferAktif = value),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _tampilkanRincianBiaya,
                icon: const Icon(CfIcons.calc),
                label: const Text(
                  'Hitung Biaya Logistik',
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CF.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _tileWaktu({
    required IconData icon,
    required String label,
    required String nilai,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: CF.bg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: CF.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: CF.red),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: CF.muted, fontSize: 11)),
            Text(
              nilai,
              style: const TextStyle(
                color: CF.navy,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
