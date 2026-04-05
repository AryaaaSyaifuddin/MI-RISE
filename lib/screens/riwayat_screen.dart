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
      'subtitle': '',
      'time': '07:32',
      'date': '10 Apr 2026',
      'status': 'On Time',
      'icon': Icons.login_rounded,
      'iconColor': Colors.green,
    },
    {
      'id': '2',
      'type': 'Absen Pulang',
      'title': 'Absen Pulang',
      'subtitle': '',
      'time': '16:30',
      'date': '10 Apr 2026',
      'status': 'Tepat Waktu',
      'icon': Icons.logout_rounded,
      'iconColor': Colors.orange,
    },
    {
      'id': '3',
      'type': 'Cuti',
      'title': 'Cuti Tahunan',
      'subtitle': '',
      'time': '09:15',
      'date': '7 Apr 2026',
      'status': 'Disetujui',
      'icon': Icons.beach_access_rounded,
      'iconColor': Colors.blue,
    },
    {
      'id': '4',
      'type': 'Lembur',
      'title': 'Lembur Project A',
      'subtitle': '',
      'time': '20:00',
      'date': '6 Apr 2026',
      'status': 'Disetujui',
      'icon': Icons.timer_rounded,
      'iconColor': Colors.purple,
    },
    {
      'id': '5',
      'type': 'Outpass',
      'title': 'Outpass Bank',
      'subtitle': '',
      'time': '10:30',
      'date': '5 Apr 2026',
      'status': 'Disetujui',
      'icon': Icons.exit_to_app_rounded,
      'iconColor': Colors.teal,
    },
    {
      'id': '6',
      'type': 'Izin',
      'title': 'Izin',
      'subtitle': '',
      'time': '13:00',
      'date': '4 Apr 2026',
      'status': 'Selesai',
      'icon': Icons.business_center_rounded,
      'iconColor': Colors.indigo,
    },
    {
      'id': '7',
      'type': 'Dinas',
      'title': 'Training Jakarta',
      'subtitle': '',
      'time': '08:00',
      'date': '3 Apr 2026',
      'status': 'Selesai',
      'icon': Icons.work_rounded,
      'iconColor': Colors.brown,
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
        final subtitle = activity['subtitle'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!title.contains(query) && !subtitle.contains(query)) return false;
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
            // Header sederhana
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Riwayat Aktivitas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 38,
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Semua aktivitas Anda tersimpan di sini',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search bar terintegrasi
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
                        hintStyle: TextStyle(color: Colors.grey[400]),
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filter chip scroll horizontal
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
            // List aktivitas
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _filteredActivities.length,
                      itemBuilder: (context, index) {
                        final item = _filteredActivities[index];
                        return _ModernActivityCard(activity: item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Card modern simple dengan efek minimalis
class _ModernActivityCard extends StatelessWidget {
  final Map<String, dynamic> activity;

  const _ModernActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon dengan background transparan
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (activity['iconColor'] as Color).withOpacity(0.14),
                        (activity['iconColor'] as Color).withOpacity(0.06),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: (activity['iconColor'] as Color).withOpacity(0.20),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    activity['icon'],
                    color: activity['iconColor'],
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                // Konten utama
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      if ((activity['subtitle'] as String).isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          activity['subtitle'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 6),
                      ] else
                        const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            activity['date'],
                            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            activity['time'],
                            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge minimalis
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(activity['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    activity['status'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(activity['status']),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Disetujui':
        return Colors.green;
      case 'Terlambat':
        return Colors.red;
      case 'Selesai':
        return Colors.blue;
      case 'Tepat Waktu':
        return Colors.teal;
      default:
        return Colors.orange;
    }
  }
}

