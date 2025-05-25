import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import 'beranda/beranda_screen.dart';
import 'kereta/kereta_screen.dart';
import 'tiket/tiket_screen.dart';
import 'promo/promo_screen.dart';
import 'akun/akun_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of screens to display
  final List<Widget> _screens = [
    const BerandaScreen(),
    const KeretaScreen(),
    const TiketScreen(),
    const PromoScreen(),
    const AkunScreen(),
  ];

  // Screen titles
  final List<String> _titles = [
    'Beranda',
    'Kereta',
    'Tiket Saya',
    'Promo',
    'Akun',
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex != 0 ? AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: AppColors.primary,
      ) : null,
      body: _screens[_currentIndex],
      bottomNavigationBar: KAIBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
