import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/vehicle.dart';
import 'supabase_service.dart';

class VehicleService {
  final _client = SupabaseService.client;

  Future<List<Vehicle>> fetchVehicles({String? search}) async {
    // 1) on laisse Dart inférer le type (var)
    var query = _client
        .from('vehicles')
        .select()
        .order('created_at', ascending: false);



    // 3) Exécution + debug
    final data = await query;
    print('DEBUG VEHICLES raw = $data');
    print('DEBUG VEHICLES count = ${(data as List).length}');

    // 4) Mapping
    return (data as List)
        .map((e) => Vehicle.fromMap(e as Map<String, dynamic>))
        .toList();
  }
  Future<Vehicle> getVehicleById(String id) async {
    final data = await _client
        .from('vehicles')
        .select()
        .eq('id', id)
        .single();

    return Vehicle.fromMap(data as Map<String, dynamic>);
  }

  Future<Vehicle> createVehicle(Map<String, dynamic> payload) async {
    final data = await _client
        .from('vehicles')
        .insert(payload)
        .select()
        .single();
    return Vehicle.fromMap(data as Map<String, dynamic>);
  }

  Future<Vehicle> updateVehicle(String id, Map<String, dynamic> payload) async {
    final data = await _client
        .from('vehicles')
        .update(payload)
        .eq('id', id)
        .select()
        .single();
    return Vehicle.fromMap(data as Map<String, dynamic>);
  }

  Future<void> deleteVehicle(String id) async {
    await _client.from('vehicles').delete().eq('id', id);
  }
}
