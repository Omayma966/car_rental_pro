import '../models/reservation.dart';
import 'supabase_service.dart';

class ReservationService {
  final _client = SupabaseService.client;

  Future<List<Reservation>> fetchReservations() async {
    final List data = await _client
        .from('reservations')
        .select()
        .order('start_date', ascending: false);

    return data.map((e) => Reservation.fromMap(e)).toList();
  }

  Future<Reservation> createReservation(Map<String, dynamic> payload) async {
    final data = await _client
        .from('reservations')
        .insert(payload)
        .select()
        .single();
    return Reservation.fromMap(data);
  }

  Future<Reservation> updateReservation(
      String id, Map<String, dynamic> payload) async {
    final data = await _client
        .from('reservations')
        .update(payload)
        .eq('id', id)
        .select()
        .single();
    return Reservation.fromMap(data);
  }

  Future<void> deleteReservation(String id) async {
    await _client.from('reservations').delete().eq('id', id);
  }
}
