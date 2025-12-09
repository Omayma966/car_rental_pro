import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/client.dart';
import 'supabase_service.dart';

class ClientService {
  final SupabaseClient _client = SupabaseService.client;

  Future<List<Client>> fetchClients({String? search}) async {
    // 1) Récupérer les données brutes Supabase
    final data = await _client
        .from('clients')
        .select()
        .order('created_at', ascending: false);

    print('DEBUG CLIENTS RAW = $data');

    final all = (data as List)
        .map((e) => Client.fromMap(e as Map<String, dynamic>))
        .toList();

    print('DEBUG CLIENTS COUNT = ${all.length}');

    // 2) Filtre de recherche côté Flutter (simple et safe)
    if (search != null && search.trim().isNotEmpty) {
      final s = search.toLowerCase().trim();
      return all.where((c) {
        return c.fullName.toLowerCase().contains(s) ||
            c.email.toLowerCase().contains(s);
      }).toList();
    }

    return all;
  }


// client_service.dart
  Future<Client> getClientById(String id) async {
    final data = await _client
        .from('clients')
        .select()
        .eq('id', id)
        .single();
    return Client.fromMap(data as Map<String, dynamic>);
  }


  Future<Client> createClient(Map<String, dynamic> payload) async {
    final data =
    await _client.from('clients').insert(payload).select().single();
    return Client.fromMap(data);
  }

  Future<Client> updateClient(String id, Map<String, dynamic> payload) async {
    final data = await _client
        .from('clients')
        .update(payload)
        .eq('id', id)
        .select()
        .single();
    return Client.fromMap(data);
  }

  Future<void> deleteClient(String id) async {
    await _client.from('clients').delete().eq('id', id);
  }
}

