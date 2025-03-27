import 'package:flutter/material.dart';
import '../screens/beranda/beranda_screen.dart';
import '../screens/kereta/kereta_screen.dart';
import '../screens/tiket/tiket_screen.dart';
import '../screens/promo/promo_screen.dart';
import '../screens/akun/akun_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String beranda = '/beranda';
  static const String kereta = '/kereta';
  static const String tiket = '/tiket';
  static const String promo = '/promo';
  static const String akun = '/akun';

  static Map<String, WidgetBuilder> get routes => {
    beranda: (context) => const BerandaScreen(),
    kereta: (context) => const KeretaScreen(),
    tiket: (context) => const TiketScreen(),
    promo: (context) => const PromoScreen(),
    akun: (context) => const AkunScreen(),
  };
}