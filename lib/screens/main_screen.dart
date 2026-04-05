import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/scan_bottom_sheet.dart';

import 'menu_screen.dart';

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
        onChangeTab: onTabChange,
      );
    }
    if (selectedIndex == 1) {
      return const MenuScreen(); // <-- ganti ini
    }
    if (selectedIndex == 2) {
      return const Center(child: Text('Halaman Riwayat Lengkap'));
    }
    return const Center(child: Text('Profile & Setting'));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        body: _buildPage(),
        drawer: const AttendanceDrawer(),
        bottomNavigationBar: CustomBottomNav(
          selectedIndex: selectedIndex,
          onTap: onTabChange,
        ),
        floatingActionButton: Transform.translate(
          offset: const Offset(0, 6),
          child: FloatingActionButton(
            onPressed: onScanPressed,
            backgroundColor: const Color(0xFFB91A1A),
            foregroundColor: Colors.white,
            child: const Icon(Icons.qr_code_scanner),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
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
      'Riwayat Aktivitas',
    ];

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                  height: 50,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: menuItems.length,
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
                    leading: Icon(icon, color: const Color(0xFFB91A1A)),
                    title: Text(
                      item,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
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

// ==================== HOME CONTENT (Stateful) ====================
class HomeContent extends StatefulWidget {
  final VoidCallback onMenuTap;
  final Function(int) onChangeTab;

  const HomeContent({
    super.key,
    required this.onMenuTap,
    required this.onChangeTab,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Data absensi (dapat diupdate dari proses scan)
  String _checkInTime = '-- : --';
  String _checkOutTime = '-- : --';
  String _attendanceStatus = 'Belum absen';
  String _attendanceLabel = '';
  bool _isInsideRadius = true; // asumsikan dalam radius, nanti diupdate dari GPS

  // Fungsi untuk update setelah absen masuk (contoh dipanggil dari scan)
  void updateCheckIn(String time, bool onTime) {
    setState(() {
      _checkInTime = time;
      _attendanceStatus = 'Sudah absen masuk • $time WIB';
      _attendanceLabel = onTime ? 'On Time' : 'Terlambat';
    });
  }

  // Fungsi untuk update setelah absen pulang
  void updateCheckOut(String time) {
    setState(() {
      _checkOutTime = time;
    });
  }

  // Fungsi untuk update status lokasi (dipanggil dari GPS)
  void updateLocationStatus(bool inside) {
    setState(() {
      _isInsideRadius = inside;
    });
  }

  // Helper date/time
  String _getDayName() {
    const days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    return days[DateTime.now().weekday % 7];
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.day} ${_getMonthName(now.month)} ${now.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

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
                  onPressed: widget.onMenuTap,
                  iconSize: 28,
                ),
                const Expanded(
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                      height: 55,
                    ),
                  ),
                ),
                // Kosongkan sisi kanan agar logo benar-benar di tengah
                const SizedBox(width: 48), // seukuran IconButton untuk keseimbangan
              ],
            ),
            const SizedBox(height: 12),

            // ----- BANNER INFORMASI MODERN (Tema Merah) -----
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB91A1A), Color(0xFFD92D2D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Hari, Tanggal, Jam
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getDayName(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getFormattedDate(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.access_time, color: Colors.white70, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                _getCurrentTime(),
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Status Absen Hari Ini
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 161, 161, 161).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.priority_high, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status Hari Ini',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _attendanceStatus,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_attendanceLabel.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _attendanceLabel,
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Jam Masuk & Jam Pulang
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.schedule,
                            label: 'Jam Masuk',
                            value: _checkInTime,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoTile(
                            icon: Icons.logout,
                            label: 'Jam Pulang',
                            value: _checkOutTime,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Lokasi Kantor (warna dinamis)
                    _LocationTile(isInsideRadius: _isInsideRadius),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ----- GRID MENU (4 menu) -----
            const Text(
              'Menu Cepat',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  onTap: () => widget.onChangeTab(0),
                ),
                _MenuItem(
                  icon: Icons.access_time,
                  label: 'Lembur',
                  onTap: () => widget.onChangeTab(1),
                ),
                _MenuItem(
                  icon: Icons.beach_access,
                  label: 'Cuti',
                  onTap: () => widget.onChangeTab(1),
                ),
                _MenuItem(
                  icon: Icons.more_horiz,
                  label: 'Lainnya',
                  onTap: () => widget.onChangeTab(1),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () => widget.onChangeTab(2),
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

// ==================== WIDGET PENDUKUNG ====================
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
              color: const Color(0xFFB91A1A).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFFB91A1A), size: 28),
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
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      color: Colors.grey.shade50,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: const Color(0xFFB91A1A).withOpacity(0.2),
          child: const Icon(Icons.history, color: Color(0xFFB91A1A), size: 14),
        ),
        title: Text(
          riwayat['tanggal']!,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '${riwayat['status']} - ${riwayat['keterangan']}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, size: 16),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final bool isInsideRadius;

  const _LocationTile({required this.isInsideRadius});

  @override
  Widget build(BuildContext context) {
    final color = isInsideRadius ? const Color.fromARGB(255, 255, 255, 255) : Colors.red;
    final statusText = isInsideRadius ? 'Dalam radius' : 'Di luar area kantor';
    final icon = isInsideRadius ? Icons.gps_fixed : Icons.gps_off;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Lokasi Kantor', style: TextStyle(color: Colors.white60, fontSize: 11)),
                const SizedBox(height: 2),
                Text(statusText, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Icon(icon, color: color, size: 16),
        ],
      ),
    );
  }
}
