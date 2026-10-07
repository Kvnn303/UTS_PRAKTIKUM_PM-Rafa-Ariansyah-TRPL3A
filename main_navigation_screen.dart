import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'cargo_booking_screen.dart';
import 'login_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // State untuk ExpansionPanelList (Hazmat)
  final List<bool> _isExpanded = [false, false, false];

  // ── Data dummy armada ──────────────────────────────────────
  final List<Map<String, dynamic>> _daftarArmada = [
    {
      'nama': 'Colt Diesel',
      'kapasitas': '2 Ton',
      'ikon': CfIcons.colt,
      'foto': 'assets/images/Colt_Diesel.jpg',
      'deskripsi': 'Distribusi antar kota & B2B supply chain',
    },
    {
      'nama': 'Fuso',
      'kapasitas': '8 Ton',
      'ikon': CfIcons.fuso,
      'foto': 'assets/images/fuso.jpg',
      'deskripsi': 'Kargo besar & freight forwarding',
    },
    {
      'nama': 'Tronton',
      'kapasitas': '20 Ton',
      'ikon': CfIcons.tronton,
      'foto': 'assets/images/tronton.jpg',
      'deskripsi': 'Muatan berat & alat berat antar provinsi',
    },
  ];

  // ── Data dummy surat jalan ─────────────────────────────────
  final List<Map<String, dynamic>> _daftarResi = [
    {'resi': 'CFX-8371', 'armada': 'Colt Diesel', 'status': 'Dalam Perjalanan'},
    {'resi': 'CFX-9920', 'armada': 'Fuso', 'status': 'Terkirim'},
    {'resi': 'CFX-1034', 'armada': 'Tronton', 'status': 'Menunggu Pickup'},
    {'resi': 'CFX-4421', 'armada': 'Fuso', 'status': 'Terkirim'},
  ];

  Color _warnaStatus(String status) {
    switch (status) {
      case 'Terkirim':
        return CF.green;
      case 'Dalam Perjalanan':
        return CF.amber;
      default:
        return CF.blue;
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  // ── Navigasi ke Form Booking (membawa data) & menerima hasil ──
  void _bukaFormBooking(String tipeArmada) async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CargoBookingScreen(namaArmada: tipeArmada),
      ),
    );

    if (hasil != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(CfIcons.success, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(hasil.toString())),
            ],
          ),
          backgroundColor: CF.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> halaman = [
      _halamanManifesMuatan(),
      _halamanRekapResi(),
      _halamanInfoDepo(),
    ];

    return Scaffold(
      backgroundColor: CF.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: CF.navy,
        elevation: 0,
        title: const CfLogo(size: 20),
        actions: [
          IconButton(
            icon: const Icon(CfIcons.notif, color: CF.red),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),

      // ── Menu Samping (Drawer) ────────────────────────────────
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const CfPhoto(path: 'assets/images/fuso.jpg'),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CF.red.withValues(alpha: 0.35),
                          CF.redDark.withValues(alpha: 0.92),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Armada: Fuso',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Plat B 9123 XYZ',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        Text(
                          'Petugas: petugas  •  Shift Pagi',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _drawerItem(CfIcons.dashboard, 'Dasbor Manifes', 0),
                  _drawerItem(CfIcons.receipt, 'Riwayat Resi', 1),
                  _drawerItem(CfIcons.depot, 'Gudang & Depo', 2),
                  const Divider(indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(CfIcons.help, color: CF.muted),
                    title: const Text('Pusat Bantuan'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                icon: const Icon(CfIcons.logout),
                label: const Text('Keluar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CF.red,
                  side: const BorderSide(color: CF.red),
                  minimumSize: const Size(double.infinity, 48),
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ],
        ),
      ),

      body: halaman[_selectedIndex],

      // ── Navigasi Bawah ───────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: CF.red,
        unselectedItemColor: CF.muted,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
        type: BottomNavigationBarType.fixed,
        elevation: 20,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CfIcons.manifest),
            label: 'Manifes Muatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(CfIcons.receipt),
            label: 'Rekap Resi',
          ),
          BottomNavigationBarItem(
            icon: Icon(CfIcons.depot),
            label: 'Informasi Depo',
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    final bool isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        leading: Icon(icon, color: isSelected ? CF.red : CF.muted),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? CF.red : CF.text,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        selectedTileColor: CF.blush,
        onTap: () {
          setState(() => _selectedIndex = index);
          Navigator.pop(context); // tutup drawer
        },
      ),
    );
  }

  // Judul halaman dengan ikon beraksen
  Widget _judulHalaman(IconData ikon, String judul, String sub) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CF.blush,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(ikon, color: CF.red),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: CF.navy,
                ),
              ),
              Text(sub, style: const TextStyle(fontSize: 12, color: CF.muted)),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // MENU 1: MANIFES MUATAN (Tab Navigation)
  // ===========================================================
  Widget _halamanManifesMuatan() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: CF.shadow,
            ),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: CF.red,
                borderRadius: BorderRadius.circular(40),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: CF.muted,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
              tabs: const [
                Tab(text: 'Armada Tersedia'),
                Tab(text: 'Syarat Muatan Berbahaya'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [_tabArmadaTersedia(), _tabSyaratMuatan()],
            ),
          ),
        ],
      ),
    );
  }

  // Tab Armada Tersedia: ListView.builder + ListTile + Stack/Positioned
  Widget _tabArmadaTersedia() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: _daftarArmada.length,
      itemBuilder: (context, index) {
        final armada = _daftarArmada[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: CF.shadow,
          ),
          child: ListTile(
            isThreeLine: true,
            contentPadding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            leading: SizedBox(
              width: 78,
              height: 78,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Foto armada dari assets
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: CfPhoto(
                      path: armada['foto'],
                      width: 78,
                      height: 78,
                      fallbackIcon: armada['ikon'],
                    ),
                  ),
                  // Lencana kapasitas
                  Positioned(
                    bottom: -9,
                    left: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: CF.red,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        armada['kapasitas'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              armada['nama'],
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: CF.navy,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  armada['deskripsi'],
                  style: const TextStyle(color: CF.muted, fontSize: 12),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 34,
                  child: ElevatedButton.icon(
                    onPressed: () => _bukaFormBooking(armada['nama']),
                    icon: const Icon(CfIcons.pick, size: 16),
                    label: const Text('Pilih Armada'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CF.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
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

  // Tab Syarat Muatan Berbahaya: ExpansionPanelList
  Widget _tabSyaratMuatan() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: CF.hero,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Icon(CfIcons.hazard, color: Colors.white, size: 34),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Panduan penanganan material berisiko (Hazardous Materials)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.zero,
              expansionCallback: (int index, bool isExpanded) {
                setState(() => _isExpanded[index] = !isExpanded);
              },
              children: [
                _panelHazmat(
                  0,
                  CfIcons.flammable,
                  CF.red,
                  'Material Mudah Terbakar',
                  'Cairan atau padatan yang mudah menyala. Jauhkan dari sumber panas dan gunakan armada khusus (bukan general cargo).',
                ),
                _panelHazmat(
                  1,
                  CfIcons.toxic,
                  CF.amber,
                  'Bahan Kimia Beracun & Korosif',
                  'Wajib kemasan ganda (double packaging) dan sertakan dokumen MSDS (Material Safety Data Sheet) lengkap.',
                ),
                _panelHazmat(
                  2,
                  CfIcons.cold,
                  CF.blue,
                  'Produk Suhu Terjaga',
                  'Farmasi, vaksin, atau makanan beku wajib memakai kontainer berpendingin (Reefer) dengan suhu yang sudah dikonfigurasi sebelum muat.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ExpansionPanel _panelHazmat(
    int i,
    IconData ikon,
    Color warna,
    String judul,
    String isi,
  ) {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: _isExpanded[i],
      headerBuilder: (context, isExpanded) => ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: warna.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(ikon, color: warna, size: 22),
        ),
        title: Text(
          judul,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: CF.navy,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            isi,
            style: const TextStyle(color: CF.muted, height: 1.5, fontSize: 13),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // MENU 2: REKAP RESI (DataTable)
  // ===========================================================
  Widget _halamanRekapResi() {
    final int total = _daftarResi.length;
    final int terkirim = _daftarResi
        .where((r) => r['status'] == 'Terkirim')
        .length;
    final int proses = total - terkirim;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _judulHalaman(
            CfIcons.receipt,
            'Rekap Surat Jalan',
            'Ringkasan resi hari ini',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _kartuRingkas('Total', '$total', CF.red)),
              const SizedBox(width: 10),
              Expanded(child: _kartuRingkas('Terkirim', '$terkirim', CF.green)),
              const SizedBox(width: 10),
              Expanded(child: _kartuRingkas('Proses', '$proses', CF.navy)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: CF.shadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 32,
                  ),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(CF.red),
                    headingTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                    columns: const [
                      DataColumn(label: Text('NO. RESI')),
                      DataColumn(label: Text('ARMADA')),
                      DataColumn(label: Text('STATUS')),
                    ],
                    rows: _daftarResi
                        .map(
                          (r) => _buatBarisData(
                            r['resi'],
                            r['armada'],
                            r['status'],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuRingkas(String label, String nilai, Color warna) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: warna,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: warna.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nilai,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  DataRow _buatBarisData(String resi, String armada, String status) {
    final Color warna = _warnaStatus(status);
    return DataRow(
      cells: [
        DataCell(
          Text(resi, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
        DataCell(Text(armada)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: warna.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: warna,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // MENU 3: INFORMASI DEPO (SelectableText)
  // ===========================================================
  Widget _halamanInfoDepo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Kartu hero depo: foto + overlay merah
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const CfPhoto(
                  path: 'assets/images/tronton.jpg',
                  fallbackIcon: CfIcons.depot,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CF.redDark.withValues(alpha: 0.9),
                        CF.red.withValues(alpha: 0.35),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Hub Utama',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        'CargoFlow Mega Hub',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Beroperasi 24 jam',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _kartuInfo(
          ikon: CfIcons.address,
          judul: 'Alamat Gudang Utama',
          konten: const SelectableText(
            'CargoFlow Mega Hub Bekasi\nJl. Raya Narogong Km. 15, Cileungsi, Bogor 16820',
            style: TextStyle(fontSize: 14, height: 1.5, color: CF.text),
          ),
        ),
        _kartuInfo(
          ikon: CfIcons.api,
          judul: 'Kode Tracking API Pusat',
          konten: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CF.navy,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const SelectableText(
              'API_KEY : CFX-PRD-9982-ABXC\nENDPOINT: api.cargoflow.co/v1/track',
              style: TextStyle(
                fontSize: 12.5,
                fontFamily: 'monospace',
                color: Colors.white,
                height: 1.6,
              ),
            ),
          ),
        ),
        _kartuInfo(
          ikon: CfIcons.contact,
          judul: 'Kontak Operasional',
          konten: const SelectableText(
            'Email : ops@cargoflow.co\nHotline: 021-5550-1234',
            style: TextStyle(fontSize: 14, height: 1.5, color: CF.text),
          ),
        ),
      ],
    );
  }

  Widget _kartuInfo({
    required IconData ikon,
    required String judul,
    required Widget konten,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: CF.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CF.blush,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(ikon, color: CF.red, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                judul,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: CF.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          konten,
          const SizedBox(height: 10),
          const Text(
            'Tekan lama pada teks untuk menyalin',
            style: TextStyle(color: CF.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
