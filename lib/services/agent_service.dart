import '../models/agent.dart';
import 'supabase_service.dart';

class AgentService {
  final _client = SupabaseService.client;

  Future<List<Agent>> fetchAgents() async {
    final List data =
    await _client.from('agents').select().order('full_name');
    return data.map((e) => Agent.fromMap(e)).toList();
  }

  Future<Agent> createAgent(Map<String, dynamic> payload) async {
    final data =
    await _client.from('agents').insert(payload).select().single();
    return Agent.fromMap(data);
  }
// agent_service.dart
  Future<Agent> getAgentById(String id) async {
    final data = await _client
        .from('agents')
        .select()
        .eq('id', id)
        .single();
    return Agent.fromMap(data as Map<String, dynamic>);
  }

  Future<Agent> updateAgent(String id, Map<String, dynamic> payload) async {
    final data = await _client
        .from('agents')
        .update(payload)
        .eq('id', id)
        .select()
        .single();
    return Agent.fromMap(data);
  }

  Future<void> deleteAgent(String id) async {
    await _client.from('agents').delete().eq('id', id);
  }
}
