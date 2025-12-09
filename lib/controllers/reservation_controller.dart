import 'package:get/get.dart';

import '../models/reservation.dart';
import '../services/reservation_service.dart';

class ReservationController extends GetxController {
  final ReservationService _service = ReservationService();

  final reservations = <Reservation>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadReservations();
  }

  Future<void> loadReservations() async {
    isLoading.value = true;
    try {
      final data = await _service.fetchReservations();
      reservations.assignAll(data);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteReservation(String id) async {
    await _service.deleteReservation(id);
    reservations.removeWhere((r) => r.id == id);
  }

  Future<void> saveReservation({
    Reservation? existing,
    required Map<String, dynamic> payload,
  }) async {
    if (existing == null) {
      final created = await _service.createReservation(payload);
      reservations.insert(0, created);
    } else {
      final updated =
      await _service.updateReservation(existing.id, payload);
      final index =
      reservations.indexWhere((r) => r.id == existing.id);
      if (index != -1) {
        reservations[index] = updated;
      }
    }
  }

  // 🔵 Accepter / annuler (changer status)
  Future<void> updateStatus({
    required Reservation reservation,
    required String status,
  }) async {
    final updated = await _service.updateReservation(
      reservation.id,
      {'status': status},
    );

    final index =
    reservations.indexWhere((r) => r.id == reservation.id);
    if (index != -1) {
      reservations[index] = updated;
    }
  }

  // 🔵 Mettre à jour le statut de paiement
  Future<void> updatePaymentStatus({
    required Reservation reservation,
    required String paymentStatus,
  }) async {
    final updated = await _service.updateReservation(
      reservation.id,
      {'payment_status': paymentStatus},
    );

    final index =
    reservations.indexWhere((r) => r.id == reservation.id);
    if (index != -1) {
      reservations[index] = updated;
    }
  }
}
