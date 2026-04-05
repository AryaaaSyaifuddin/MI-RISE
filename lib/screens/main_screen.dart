import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/scan_bottom_sheet.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;

  void onTabChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onScanPressed() {
    if (cameras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamera tidak tersedia di perangkat ini')),
      );
      return;
    }

    final selectedCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          widthFactor: 1,
          child: ScanBottomSheet(camera: selectedCamera),
        );
      },
    );
  }

  Widget _buildPage() {
    if (selectedIndex == 0) {
      return HomeContent(
        onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
        onChangeTab: onTabChange, // <- kirim fungsi untuk ganti tab
      );
    }
    if (selectedIndex == 1) {
      return const Center(child: Text('Halaman Menu (semua fitur)'));
    }
    if (selectedIndex == 2) {
      return const Center(child: Text('Halaman Riwayat Lengkap'));
    }
    return const Center(child: Text('Profile & Setting'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      body: _buildPage(),
      drawer: const AttendanceDrawer(),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: selectedIndex,
        onTap: onTabChange,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onScanPressed,
        backgroundColor: const Color.fromARGB(255, 185, 26, 26),
        foregroundColor: Colors.white,
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// ==================== DRAWER ====================
class AttendanceDrawer extends StatelessWidget {
  const AttendanceDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      'Absen',
      'Lembur',
      'Outpass',
      'Cuti',
      'DC',
      'Dinas',
      'User Activity',
    ];

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                'Menu Aplikasi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1, thickness: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: menuItems.length,
                separatorBuilder: (_, __) => const Divider(height: 0, indent: 56),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  IconData icon;
                  switch (item) {
                    case 'Absen':
                      icon = Icons.fingerprint;
                      break;
                    case 'Lembur':
                      icon = Icons.access_time;
                      break;
                    case 'Outpass':
                      icon = Icons.exit_to_app;
                      break;
                    case 'Cuti':
                      icon = Icons.beach_access;
                      break;
                    case 'DC':
                      icon = Icons.business_center;
                      break;
                    case 'Dinas':
                      icon = Icons.work_outline;
                      break;
                    default:
                      icon = Icons.history;
                  }
                  return ListTile(
                    leading: Icon(icon, color: const Color.fromARGB(255, 185, 26, 26)),
                    title: Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Menu $item ditekan')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== HOME CONTENT ====================
class HomeContent extends StatelessWidget {
  final VoidCallback onMenuTap;
  final Function(int) onChangeTab; // untuk berpindah tab bottom nav

  const HomeContent({
    super.key,
    required this.onMenuTap,
    required this.onChangeTab,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- HEADER: burger di kiri -----
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: onMenuTap,
                  iconSize: 28,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),

            // ----- BANNER -----
            Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Banner Informasi / Pengumuman',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6C757D)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ----- GRID MENU (4 menu) -----
            const Text(
              'Menu Cepat',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _MenuItem(
                  icon: Icons.qr_code_scanner,
                  label: 'Absen',
                  onTap: () => onChangeTab(0), // pindah ke tab Home? Atau buka scan? Biarkan snackbar dulu
                ),
                _MenuItem(
                  icon: Icons.access_time,
                  label: 'Lembur',
                  onTap: () => onChangeTab(1), // pindah ke Menu
                ),
                _MenuItem(
                  icon: Icons.beach_access,
                  label: 'Cuti',
                  onTap: () => onChangeTab(1),
                ),
                _MenuItem(
                  icon: Icons.more_horiz,
                  label: 'Lainnya',
                  onTap: () => onChangeTab(1), // pindah ke Menu (index 1)
                ),
              ],
            ),
            const SizedBox(height: 22),

            // ----- RIWAYAT ABSENSI -----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Absensi',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(
                  onPressed: () => onChangeTab(2), // pindah ke Riwayat (index 2)
                  child: const Text('See more'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: List.generate(
                _dummyRiwayat.length,
                (index) => _RiwayatItem(riwayat: _dummyRiwayat[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data dummy riwayat
final List<Map<String, String>> _dummyRiwayat = [
  {'tanggal': 'Senin, 5 Apr 2026', 'status': 'Masuk 07:45', 'keterangan': 'On time'},
  {'tanggal': 'Selasa, 6 Apr 2026', 'status': 'Masuk 08:10', 'keterangan': 'Terlambat 10 menit'},
  {'tanggal': 'Rabu, 7 Apr 2026', 'status': 'Pulang 16:30', 'keterangan': 'Tepat waktu'},
  {'tanggal': 'Kamis, 8 Apr 2026', 'status': 'Masuk 07:50', 'keterangan': 'On time'},
];

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 185, 26, 26).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color.fromARGB(255, 185, 26, 26), size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _RiwayatItem extends StatelessWidget {
  final Map<String, String> riwayat;

  const _RiwayatItem({required this.riwayat});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6), // kurangi jarak antar card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      color: Colors.grey.shade50,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), // padding lebih kecil
        leading: CircleAvatar(
          radius: 14, // avatar lebih kecil
          backgroundColor: const Color.fromARGB(255, 185, 26, 26).withOpacity(0.2),
          child: const Icon(Icons.history, color: Color.fromARGB(255, 185, 26, 26), size: 14),
        ),
        title: Text(
          riwayat['tanggal']!,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // lebih kecil
        ),
        subtitle: Text(
          '${riwayat['status']} - ${riwayat['keterangan']}',
          style: const TextStyle(fontSize: 12), // lebih kecil
        ),
        trailing: const Icon(Icons.chevron_right, size: 16),
      ),
    );
  }
}