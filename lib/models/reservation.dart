class Reservation {
  final String id;
  final String clientId;
  final String vehicleId;
  final String? agentId;

  final DateTime startDate;
  final DateTime endDate;

  final double totalAmount;
  final String status;        // pending / approved / cancelled
  final String paymentStatus; // unpaid / paid / partial

  Reservation({
    required this.id,
    required this.clientId,
    required this.vehicleId,
    this.agentId,
    required this.startDate,
    required this.endDate,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
  });

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] as String,
      clientId: map['client_id'] as String,
      vehicleId: map['vehicle_id'] as String,
      agentId: map['agent_id'] as String?,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      totalAmount: (map['total_amount'] as num).toDouble(),
      status: map['status'] as String,
      paymentStatus: map['payment_status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'client_id': clientId,
      'vehicle_id': vehicleId,
      'agent_id': agentId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'total_amount': totalAmount,
      'status': status,
      'payment_status': paymentStatus,
    };
  }
}
