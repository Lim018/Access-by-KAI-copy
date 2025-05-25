import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

class TicketBookingScreen extends StatefulWidget {
  const TicketBookingScreen({Key? key}) : super(key: key);

  @override
  _TicketBookingScreenState createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  
  // Form values
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _passengerCount = 1;
  String _selectedClass = 'Ekonomi';
  
  // Available classes
  final List<String> _trainClasses = ['Ekonomi', 'Bisnis', 'Eksekutif', 'Premium'];

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _searchTrains() {
    if (_formKey.currentState!.validate()) {
      // In a real app, this would navigate to a search results screen
      // with the search parameters
      
      // For now, just show a snackbar with the search parameters
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mencari kereta dari ${_originController.text} ke ${_destinationController.text} pada ${_formatDate(_selectedDate)} untuk $_passengerCount penumpang (${_selectedClass})',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Tiket Kereta'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with background
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.indigo.shade800,
                    Colors.purple.shade700,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Pesan Tiket Kereta Api',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Temukan jadwal dan pesan tiket kereta api dengan mudah',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Booking form
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Origin station
                    TextFormField(
                      controller: _originController,
                      decoration: const InputDecoration(
                        labelText: 'Stasiun Asal',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.train),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stasiun asal tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Destination station
                    TextFormField(
                      controller: _destinationController,
                      decoration: const InputDecoration(
                        labelText: 'Stasiun Tujuan',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.train),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stasiun tujuan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Date picker
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Keberangkatan',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(_formatDate(_selectedDate)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Passenger count
                    Row(
                      children: [
                        const Text(
                          'Jumlah Penumpang:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _passengerCount > 1
                              ? () {
                                  setState(() {
                                    _passengerCount--;
                                  });
                                }
                              : null,
                        ),
                        Text(
                          '$_passengerCount',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: _passengerCount < 4
                              ? () {
                                  setState(() {
                                    _passengerCount++;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Train class
                    const Text(
                      'Kelas:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _trainClasses.map((trainClass) {
                        return ChoiceChip(
                          label: Text(trainClass),
                          selected: _selectedClass == trainClass,
                          onSelected: (selected) {
                            setState(() {
                              _selectedClass = trainClass;
                            });
                          },
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: _selectedClass == trainClass
                                ? AppColors.primary
                                : Colors.black,
                            fontWeight: _selectedClass == trainClass
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    
                    // Search button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _searchTrains,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'CARI KERETA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
