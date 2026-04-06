import 'package:flutter/material.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  final List<String> _categories = [
    'Semua',
    'Absen',
    'Cuti',
    'Lembur',
    'Outpass',
    'Izin',
    'Dinas',
  ];

  final List<Map<String, dynamic>> _allActivities = [
    {
      'id': '1',
      'type': 'Absen Masuk',
      'title': 'Absen Masuk',
      'time': '07:32',
      'date': '10 Apr 2026',
      'status': 'On Time',
      'icon': Icons.login,
    },
    {
      'id': '2',
      'type': 'Absen Pulang',
      'title': 'Absen Pulang',
      'time': '16:30',
      'date': '10 Apr 2026',
      'status': 'Tepat Waktu',
      'icon': Icons.logout,
    },
    {
      'id': '3',
      'type': 'Cuti',
      'title': 'Cuti Tahunan',
      'time': '09:15',
      'date': '7 Apr 2026',
      'status': 'Disetujui',
      'icon': Icons.beach_access,
    },
    {
      'id': '4',
      'type': 'Lembur',
      'title': 'Lembur Project A',
      'time': '20:00',
      'date': '6 Apr 2026',
      'status': 'Disetujui',
      'icon': Icons.access_time,
    },
    {
      'id': '5',
      'type': 'Outpass',
      'title': 'Outpass Bank',
      'time': '10:30',
      'date': '5 Apr 2026',
      'status': 'Disetujui',
      'icon': Icons.exit_to_app,
    },
    {
      'id': '6',
      'type': 'Izin',
      'title': 'Izin',
      'time': '13:00',
      'date': '4 Apr 2026',
      'status': 'Selesai',
      'icon': Icons.business_center,
    },
    {
      'id': '7',
      'type': 'Dinas',
      'title': 'Training Jakarta',
      'time': '08:00',
      'date': '3 Apr 2026',
      'status': 'Selesai',
      'icon': Icons.work_outline,
    },
  ];

  List<Map<String, dynamic>> get _filteredActivities {
    return _allActivities.where((activity) {
      if (_selectedCategory != 'Semua') {
        if (_selectedCategory == 'Absen') {
          if (activity['type'] != 'Absen Masuk' && activity['type'] != 'Absen Pulang')
            return false;
        } else if (activity['type'] != _selectedCategory) {
          return false;
        }
      }
      if (_searchQuery.isNotEmpty) {
        final title = activity['title'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!title.contains(query)) return false;
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header (tetap sama, hanya disesuaikan sedikit)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Riwayat Aktivitas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 38,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Semua aktivitas Anda tersimpan di sini',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Cari aktivitas',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey[500]),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  // Filter chips
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = _selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (s) => setState(() => _selectedCategory = cat),
                          checkmarkColor: Colors.white,
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFFB91A1A),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                          side: BorderSide.none,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: StadiumBorder(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // List aktivitas dengan gaya compact seperti di main_screen
            Expanded(
              child: _filteredActivities.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_rounded, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            'Tidak ada aktivitas',
                            style: TextStyle(color: Colors.grey[500], fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _filteredActivities.length,
                      itemBuilder: (context, index) {
                        final item = _filteredActivities[index];
                        return _CompactActivityCard(activity: item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget item list yang compact, gaya sama dengan _RiwayatItem di main_screen.dart
class _CompactActivityCard extends StatelessWidget {
  final Map<String, dynamic> activity;

  const _CompactActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    // Format subtitle: jam dan status
    final subtitle = '${activity['time']} WIB • ${activity['status']}';

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
          child: Icon(activity['icon'], color: const Color(0xFFB91A1A), size: 14),
        ),
        title: Text(
          activity['title'],
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, size: 16),
      ),
    );
  }
}
