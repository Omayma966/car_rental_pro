import 'package:get/get.dart';
import '../models/client.dart';
import '../services/client_service.dart';

class ClientController extends GetxController {
  final ClientService _service = ClientService();

  final clients = <Client>[].obs;
  final isLoading = false.obs;
  final search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadClients();
  }

  Future<void> loadClients() async {
    isLoading.value = true;
    try {
      final data = await _service.fetchClients(
        search: search.value.trim().isEmpty ? null : search.value,
      );
      clients.assignAll(data);
      print('DEBUG CLIENTS count = ${clients.length}');
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void setSearch(String value) {
    search.value = value;
    loadClients();
  }

  Future<void> deleteClient(String id) async {
    await _service.deleteClient(id);
    clients.removeWhere((c) => c.id == id);
  }

  Future<void> saveClient({
    Client? existing,
    required Map<String, dynamic> payload,
  }) async {
    if (existing == null) {
      final created = await _service.createClient(payload);
      clients.insert(0, created);
    } else {
      final updated = await _service.updateClient(existing.id, payload);
      final index = clients.indexWhere((c) => c.id == existing.id);
      if (index != -1) {
        clients[index] = updated;
      }
    }
  }
}
