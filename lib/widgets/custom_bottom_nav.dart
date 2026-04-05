import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    required this.selectedIndex,
    required this.onTap,
  });

  Widget buildItem(IconData icon, String label, int index) {
    final isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color.fromARGB(255, 185, 26, 26) : const Color.fromARGB(255, 64, 64, 64),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? const Color.fromARGB(255, 185, 26, 26) : const Color.fromARGB(255, 64, 64, 64),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      elevation: 10,
      child: Container(
        height: 65,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildItem(Icons.home_outlined, "Home", 0),
            buildItem(Icons.dashboard_outlined, "Menu", 1),

            SizedBox(width: 30), // space FAB (SCAN)

            buildItem(Icons.history, "Riwayat", 2),
            buildItem(Icons.person_outline, "Profile", 3),
          ],
        ),
      ),
    );
  }
}
