import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
      );
    }

    if (selectedIndex == 1) {
      return const Center(child: Text('Menu'));
    }

    if (selectedIndex == 2) {
      return const Center(child: Text('Riwayat Aktivitas'));
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

class AttendanceDrawer extends StatelessWidget {
  const AttendanceDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
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
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Menu Aplikasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            const Divider(height: 1),
            ExpansionTile(
              leading: const Icon(Icons.assignment_ind_outlined),
              title: const Text(
                'Absen',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              children: menuItems
                  .map(
                    (item) => ListTile(
                      contentPadding: const EdgeInsets.only(left: 56, right: 16),
                      title: Text(item),
                      onTap: () => Navigator.pop(context),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final VoidCallback onMenuTap;

  const HomeContent({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 110,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _CircleButton(
                  icon: Icons.menu,
                  onTap: onMenuTap,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9ECEF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Logo Perusahaan',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Absensi Harian Karyawan',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF6C757D),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const _CircleButton(icon: Icons.search),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Banner Informasi / Pengumuman',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Info Absensi Hari Ini',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 10),
            const _InfoCard(
              icon: Icons.schedule_outlined,
              title: 'Jam Masuk',
              subtitle: '07:30 - 08:00 WIB',
            ),
            const SizedBox(height: 8),
            const _InfoCard(
              icon: Icons.logout_outlined,
              title: 'Jam Pulang',
              subtitle: '16:30 WIB',
            ),
            const SizedBox(height: 8),
            const _InfoCard(
              icon: Icons.location_on_outlined,
              title: 'Aturan Lokasi',
              subtitle: 'Pastikan GPS aktif dan berada dalam radius kantor.',
            ),
            const SizedBox(height: 8),
            const _InfoCard(
              icon: Icons.verified_user_outlined,
              title: 'Validasi Wajah',
              subtitle: 'Gunakan pencahayaan cukup agar verifikasi lebih cepat.',
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF1F3F5),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Icon(icon, color: const Color(0xFF495057)),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color.fromARGB(255, 185, 26, 26)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6C757D),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
