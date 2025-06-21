import 'dart:convert'; // WAJIB: Tambahkan import ini
import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static late Client client;
  static late Databases databases;
  // Pastikan ID ini sudah sesuai dengan dasbor Anda
  static const String projectId = '681c347100158dc0e30d';
  static const String databaseId = 'ogx58s3FLhMJeRz';
  static const String schedulesCollectionId = '68473ec2000e6a21e224'; // Ganti jika ID Anda berbeda
  static const String bookingsCollectionId = '6847407f001462acc24a';

  static void initialize() {
    client = Client()
        .setEndpoint('https://fra.cloud.appwrite.io/v1')
        .setProject(projectId);

    databases = Databases(client);
  }

  // Fungsi getSchedules tidak berubah
  static Future<List<Map<String, dynamic>>> getSchedules(
      String from, String to, String date) async {
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: schedulesCollectionId,
        queries: [
          Query.equal('from', from),
          Query.equal('to', to),
          Query.equal('date', date),
        ],
      );
      return result.documents.map((doc) => doc.data).toList();
    } catch (e) {
      print('Error getting schedules: $e');
      return _getMockSchedules(from, to, date);
    }
  }

  // --- FUNGSI INI DIMODIFIKASI TOTAL ---
  static Future<String> createBooking(Map<String, dynamic> bookingDataObject) async {
    try {
      // 1. Ubah seluruh objek Map menjadi satu string JSON
      final String bookingDataString = jsonEncode(bookingDataObject);

      // 2. Siapkan data untuk dikirim ke Appwrite sesuai struktur baru
      final Map<String, dynamic> dataForAppwrite = {
        'bookingTime': DateTime.now().toIso8601String(),
        'bookingData': bookingDataString, // Simpan semua detail di sini
      };

      print('Attempting to save booking with new structure: $dataForAppwrite');

      final result = await databases.createDocument(
        databaseId: databaseId,
        collectionId: bookingsCollectionId,
        documentId: ID.unique(),
        data: dataForAppwrite, // Kirim data dengan struktur baru
      );

      print('Booking saved successfully with ID: ${result.$id}');
      return result.$id;
    } catch (e) {
      print('Error creating booking with new structure: $e');
      throw Exception('Failed to create booking: $e');
    }
  }

  // Fungsi lainnya tidak perlu diubah...
  static Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
    try {
      final result = await databases.getDocument(
        databaseId: databaseId,
        collectionId: bookingsCollectionId,
        documentId: bookingId,
      );
      // Nanti saat mengambil data, kita perlu decode lagi string JSON-nya
      // Tapi untuk sekarang, ini sudah cukup
      return result.data;
    } catch (e) {
      print('Error getting booking: $e');
      return null;
    }
  }

  static List<Map<String, dynamic>> _getMockSchedules(String from, String to, String date) {
    return [
      {
        'trainName': 'KA BIMA',
        'trainCode': '303',
        'departure': '09:05',
        'arrival': '18:55',
        'duration': '9j 50m',
        'price': 630000,
        'class': 'Eksekutif (AA)',
        'available': true,
      },
      {
        'trainName': 'KA Brawijaya',
        'trainCode': '021',
        'departure': '06:30',
        'arrival': '16:55',
        'duration': '10j 25m',
        'price': 540000,
        'class': 'Eksekutif (AA)',
        'available': true,
      },
    ];
  }
}