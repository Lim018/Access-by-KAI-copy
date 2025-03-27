import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'android_nav_bar.dart';

class KAIBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const KAIBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, 'Beranda'),
              _buildNavItem(1, Icons.train_outlined, 'Kereta'),
              _buildNavItem(2, Icons.confirmation_number_outlined, 'Tiket Saya'),
              _buildNavItem(3, Icons.local_offer_outlined, 'Promo'),
              _buildNavItem(4, Icons.person_outline, 'Akun'),
            ],
          ),
        ),
        const AndroidNavBar(),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isActive = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.primary : Colors.grey,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}