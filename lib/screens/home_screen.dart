import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_data.dart';
import 'train_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFrom = 'GUBENG';
  String selectedTo = 'GAMBIR';
  DateTime selectedDate = DateTime.now();
  DateTime? returnDate;
  bool isRoundTrip = false;
  int passengers = 1;

  final List<String> cities = [
    'GUBENG', 'GAMBIR', 'YOGYAKARTA', 'WONOKROMO', 'SIDOARJO',
    'LAWANG', 'SINGOSARI', 'BRAWIJAYA'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Menggunakan Stack untuk menempatkan background dan konten
        children: [
          // Gradient Background (separuh atas)
          Container(
            height: MediaQuery.of(context).size.height * 0.4, // Sesuaikan tinggi gradient
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF8B5CF6),
                  Color(0xFFEC4899),
                ],
              ),
            ),
          ),
          // White Background (separuh bawah dan menutupi bagian bawah gradient)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // Sesuaikan posisi awal area putih
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), // Radius sesuai gambar
                  topRight: Radius.circular(24),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded( // Expanded agar konten sisanya memenuhi ruang yang tersedia
                  child: SingleChildScrollView( // Agar bisa di-scroll jika konten banyak
                    padding: const EdgeInsets.symmetric(horizontal: 24.0), // Padding untuk Card
                    child: Column(
                      children: [
                        SizedBox(height: 16), // Memberi sedikit ruang dari header
                        _buildStationSelector(),
                        SizedBox(height: 16), // Spacing antar cards
                        _buildDateSelector(),
                        if (isRoundTrip) ...[
                          SizedBox(height: 16),
                          _buildReturnDateSelector(),
                        ],
                        SizedBox(height: 16),
                        _buildPassengerSelector(),
                        SizedBox(height: 24), // Spacing sebelum button
                        _buildSearchButton(),
                        SizedBox(height: 24), // Spacing di bagian bawah
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.train, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Text(
            'Kereta Lokal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationSelector() {
    return Card(
      elevation: 2, // Subtle shadow for the card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final String? result = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('Pilih Kota Asal'),
                          children: cities.map((String city) {
                            return SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, city);
                              },
                              child: Text(city),
                            );
                          }).toList(),
                        );
                      },
                    );
                    if (result != null) {
                      setState(() {
                        selectedFrom = result;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFF8B5CF6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.train, color: Colors.white, size: 16), // Changed icon to match image
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dari', style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                          SizedBox(height: 4),
                          Text(selectedFrom, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 30), // Separator
                GestureDetector(
                  onTap: () async {
                    final String? result = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('Pilih Kota Tujuan'),
                          children: cities.map((String city) {
                            return SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, city);
                              },
                              child: Text(city),
                            );
                          }).toList(),
                        );
                      },
                    );
                    if (result != null) {
                      setState(() {
                        selectedTo = result;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFFEC4899),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.train, color: Colors.white, size: 16), // Changed icon to match image
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ke', style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                          SizedBox(height: 4),
                          Text(selectedTo, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height * 0.05, // Adjust position as needed
              child: IconButton(
                onPressed: () {
                  setState(() {
                    String temp = selectedFrom;
                    selectedFrom = selectedTo;
                    selectedTo = temp;
                  });
                },
                icon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF8B5CF6).withOpacity(0.1), // Adjusted color to match image
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.swap_vert, color: Color(0xFF8B5CF6), size: 24), // Changed icon to match image
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: GestureDetector(
        onTap: () => _selectDate(context, true),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF8B5CF6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.calendar_today, color: Color(0xFF8B5CF6), size: 20),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal Pergi', style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                      SizedBox(height: 4),
                      Text(
                        DateFormat('EEE, dd MMM yyyy').format(selectedDate),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Pulang Pergi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(width: 8),
                  Switch(
                    value: isRoundTrip,
                    onChanged: (value) => setState(() => isRoundTrip = value),
                    activeColor: Color(0xFF8B5CF6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReturnDateSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: GestureDetector(
        onTap: () => _selectDate(context, false),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFEC4899).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_today, color: Color(0xFFEC4899), size: 20),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tanggal Pulang', style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  SizedBox(height: 4),
                  Text(
                    returnDate != null
                        ? DateFormat('EEE, dd MMM yyyy').format(returnDate!)
                        : 'Pilih tanggal pulang',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.person, color: Color(0xFF8B5CF6), size: 20),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Penumpang', style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text('$passengers Dewasa', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            // The image does not show the +/- buttons initially, so we'll remove them
            // or perhaps place them in a dialog if the user taps this section.
            // For now, removing them to match the initial image.
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final bookingData = BookingData(
            from: selectedFrom,
            to: selectedTo,
            departureDate: DateFormat('yyyy-MM-dd').format(selectedDate),
            returnDate: isRoundTrip && returnDate != null
                ? DateFormat('yyyy-MM-dd').format(returnDate!)
                : null,
            passengers: passengers,
            isRoundTrip: isRoundTrip,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrainListScreen(bookingData: bookingData),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF8B5CF6),
          padding: EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          'CARI TIKET KA LOKAL',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeparture ? selectedDate : (returnDate ?? selectedDate.add(Duration(days: 1))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF8B5CF6),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          selectedDate = picked;
          if (isRoundTrip && (returnDate == null || returnDate!.isBefore(picked))) {
            returnDate = picked.add(Duration(days: 1));
          }
        } else {
          returnDate = picked;
        }
      });
    }
  }
}