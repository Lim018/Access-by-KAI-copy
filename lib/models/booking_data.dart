class BookingData {
  String from;
  String to;
  String departureDate;
  String? returnDate;
  int passengers;
  bool isRoundTrip;
  Map<String, dynamic>? selectedTrain;
  Map<String, dynamic>? passengerData;
  List<String>? selectedSeats;

  BookingData({
    required this.from,
    required this.to,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
    this.isRoundTrip = false,
    this.selectedTrain,
    this.passengerData,
    this.selectedSeats,
  });

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'departureDate': departureDate,
      'returnDate': returnDate,
      'passengers': passengers,
      'isRoundTrip': isRoundTrip,
      'selectedTrain': selectedTrain,
      'passengerData': passengerData,
      'selectedSeats': selectedSeats,
      'bookingTime': DateTime.now().toIso8601String(),
    };
  }
}