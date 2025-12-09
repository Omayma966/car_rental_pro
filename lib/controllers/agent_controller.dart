import 'package:get/get.dart';

import '../models/agent.dart';
import '../services/agent_service.dart';

class AgentController extends GetxController {
  final AgentService _service = AgentService();

  final agents = <Agent>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAgents();
  }

  Future<void> loadAgents() async {
    isLoading.value = true;
    try {
      final data = await _service.fetchAgents();
      agents.assignAll(data);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAgent(String id) async {
    await _service.deleteAgent(id);
    agents.removeWhere((a) => a.id == id);
  }

  Future<void> saveAgent({
    Agent? existing,
    required Map<String, dynamic> payload,
  }) async {
    if (existing == null) {
      final created = await _service.createAgent(payload);
      agents.insert(0, created);
    } else {
      final updated =
      await _service.updateAgent(existing.id, payload);
      final index = agents.indexWhere((a) => a.id == existing.id);
      if (index != -1) agents[index] = updated;
    }
  }
}
