class TicketModel {
  final String id;
  final String userId;
  final String ticketNumber;
  final String trainType;
  final String departure;
  final String destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String seatNumber;
  final int price;
  final String status;
  final DateTime bookingDate;

  TicketModel({
    required this.id,
    required this.userId,
    required this.ticketNumber,
    required this.trainType,
    required this.departure,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.seatNumber,
    required this.price,
    required this.status,
    required this.bookingDate,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['\$id'] ?? '',
      userId: json['userId'] ?? '',
      ticketNumber: json['ticketNumber'] ?? '',
      trainType: json['trainType'] ?? '',
      departure: json['departure'] ?? '',
      destination: json['destination'] ?? '',
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      seatNumber: json['seatNumber'] ?? '',
      price: json['price'] ?? 0,
      status: json['status'] ?? 'pending',
      bookingDate: DateTime.parse(json['bookingDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'ticketNumber': ticketNumber,
      'trainType': trainType,
      'departure': departure,
      'destination': destination,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'seatNumber': seatNumber,
      'price': price,
      'status': status,
      'bookingDate': bookingDate.toIso8601String(),
    };
  }
}