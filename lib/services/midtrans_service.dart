import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../models/booking_data.dart';

class MidtransService {
  // SANDBOX - Ganti dengan production untuk live
  static const String baseUrl = 'https://app.sandbox.midtrans.com/snap/v1/transactions';
  static const String serverKey = 'SB-Mid-server-YOUR_SERVER_KEY_HERE'; // Ganti dengan server key Anda
  static const String clientKey = 'SB-Mid-client-YOUR_CLIENT_KEY_HERE'; // Ganti dengan client key Anda

  // Untuk production gunakan:
  // static const String baseUrl = 'https://app.midtrans.com/snap/v1/transactions';

  static String get authHeader {
    String auth = base64Encode(utf8.encode('$serverKey:'));
    return 'Basic $auth';
  }

  static Future<Map<String, dynamic>> createTransaction({
    required String orderId,
    required int grossAmount,
    required BookingData bookingData,
  }) async {
    final train = bookingData.selectedTrain!;
    final passenger = bookingData.passengerData!;

    final transactionDetails = {
      'order_id': orderId,
      'gross_amount': grossAmount,
    };

    final itemDetails = [
      {
        'id': train['trainCode'],
        'price': train['price'],
        'quantity': bookingData.passengers,
        'name': '${train['trainName']} - ${bookingData.from} ke ${bookingData.to}',
        'category': 'Transportation',
      }
    ];

    final customerDetails = {
      'first_name': passenger['fullName'].toString().split(' ').first,
      'last_name': passenger['fullName'].toString().split(' ').length > 1
          ? passenger['fullName'].toString().split(' ').sublist(1).join(' ')
          : '',
      'email': passenger['email'] ?? 'customer@example.com',
      'phone': passenger['phoneNumber'] ?? '+62812345678',
    };

    final requestBody = {
      'transaction_details': transactionDetails,
      'item_details': itemDetails,
      'customer_details': customerDetails,
      'enabled_payments': [
        'credit_card',
        'bank_transfer',
        'echannel',
        'gopay',
        'shopeepay',
        'other_qris'
      ],
      'credit_card': {
        'secure': true,
      },
      'expiry': {
        'start_time': DateTime.now().toIso8601String(),
        'unit': 'minute',
        'duration': 30,
      },
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
        body: json.encode(requestBody),
      );

      print('Midtrans Response Status: ${response.statusCode}');
      print('Midtrans Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create transaction: ${response.body}');
      }
    } catch (e) {
      print('Error creating Midtrans transaction: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> checkTransactionStatus(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.sandbox.midtrans.com/v2/$orderId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authHeader,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to check transaction status');
      }
    } catch (e) {
      print('Error checking transaction status: $e');
      throw Exception('Network error: $e');
    }
  }

  // Generate unique order ID
  static String generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORDER-$timestamp';
  }
}