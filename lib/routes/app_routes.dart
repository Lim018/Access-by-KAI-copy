import 'package:flutter/material.dart';
import '../screens/beranda/beranda_screen.dart';
import '../screens/kereta/kereta_screen.dart';
import '../screens/tiket/tiket_screen.dart';
import '../screens/promo/promo_screen.dart';
import '../screens/akun/akun_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/profile_edit_screen.dart';
import '../screens/auth/transaction_history_screen.dart';
import '../screens/auth/ticket_booking_screen.dart';
import '../screens/auth/payment_screen.dart';
import '../screens/auth/kai_pay_screen.dart';
import '../screens/auth/auth_wrapper.dart';
import '../screens/main_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String main = '/main';
  static const String beranda = '/beranda';
  static const String kereta = '/kereta';
  static const String tiket = '/tiket';
  static const String promo = '/promo';
  static const String akun = '/akun';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String profileEdit = '/profile-edit';
  static const String transactionHistory = '/transaction-history';
  static const String ticketBooking = '/ticket-booking';
  static const String payment = '/payment';
  static const String kaiPay = '/kai-pay';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const AuthWrapper(), // This is now the entry point
    main: (context) => const MainScreen(),
    beranda: (context) => const BerandaScreen(),
    kereta: (context) => const KeretaScreen(),
    tiket: (context) => const TiketScreen(),
    promo: (context) => const PromoScreen(),
    akun: (context) => const AkunScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    profileEdit: (context) => const ProfileEditScreen(),
    transactionHistory: (context) => const TransactionHistoryScreen(),
    ticketBooking: (context) => const TicketBookingScreen(),
    kaiPay: (context) => const KaiPayScreen(),
    payment: (context) {
      // Extract payment arguments
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        return PaymentScreen(
          amount: args['amount'] as double,
          description: args['description'] as String,
        );
      }
      // Fallback if no arguments provided
      return const PaymentScreen(
        amount: 0.0,
        description: 'Payment',
      );
    },
  };
}
