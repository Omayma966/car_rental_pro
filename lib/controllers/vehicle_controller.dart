import 'package:get/get.dart';

import '../models/vehicle.dart';
import '../services/vehicle_service.dart';

class VehicleController extends GetxController {
  final VehicleService _service = VehicleService();

  final vehicles = <Vehicle>[].obs;
  final isLoading = false.obs;
  final search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    isLoading.value = true;
    try {
      final data = await _service.fetchVehicles(search: search.value);
      vehicles.assignAll(data);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void setSearch(String value) {
    search.value = value;
    loadVehicles();
  }

  Future<void> deleteVehicle(String id) async {
    await _service.deleteVehicle(id);
    vehicles.removeWhere((v) => v.id == id);
  }

  Future<void> saveVehicle({Vehicle? existing, required Map<String, dynamic> payload}) async {
    if (existing == null) {
      final newVehicle = await _service.createVehicle(payload);
      vehicles.insert(0, newVehicle);
    } else {
      final updated =
      await _service.updateVehicle(existing.id, payload);
      final index =
      vehicles.indexWhere((element) => element.id == existing.id);
      if (index != -1) vehicles[index] = updated;
    }
  }
}
