import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  final List<Map<String, dynamic>> menus = const [
    {'icon': Icons.qr_code_scanner, 'label': 'Absen'},
    {'icon': Icons.access_time, 'label': 'Lembur'},
    {'icon': Icons.exit_to_app, 'label': 'Outpass'},
    {'icon': Icons.beach_access, 'label': 'Cuti'},
    {'icon': Icons.business_center, 'label': 'Izin'},
    {'icon': Icons.work_outline, 'label': 'Dinas'},
    {'icon': Icons.history, 'label': 'Riwayat Aktivitas'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Row(
                  children: [
                    SizedBox(width: 48),
                    Expanded(
                      child: Center(
                        child: Image(
                          image: AssetImage('assets/images/logo.png'),
                          height: 55,
                        ),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
                children: menus.map((menu) {
                  return _MenuItemGrid(
                    icon: menu['icon'] as IconData,
                    label: menu['label'] as String,
                    onTap: () {
                      // Aksi saat menu diklik
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Menu ${menu['label']} ditekan')),
                      );
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemGrid extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItemGrid({
    required this.icon,
    required this.label,
    required this.onTap,
  });

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
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

