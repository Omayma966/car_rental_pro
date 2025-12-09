import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/vehicle_controller.dart';
import '../../models/vehicle.dart';
import 'vehicle_form_page.dart';
import 'vehicle_details_page.dart';

class VehiclesListPage extends StatelessWidget {
  const VehiclesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(VehicleController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Véhicules'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher par marque, modèle ou plaque',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: ctrl.setSearch,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (ctrl.vehicles.isEmpty) {
                return const Center(
                    child: Text('Aucun véhicule pour le moment.'));
              }
              return ListView.builder(
                itemCount: ctrl.vehicles.length,
                itemBuilder: (context, index) {
                  final Vehicle v = ctrl.vehicles[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: ListTile(
                      // 👉 Vignette (première photo si dispo)
                      leading: _buildThumbnail(v),

                      title: Text(v.displayName),
                      subtitle: Text(
                        '${v.plateNumber} • ${v.pricePerDay.toStringAsFixed(2)} TND/jour',
                      ),

                      // 👉 Clic sur la ligne = ouvrir la page de détails
                      onTap: () {
                        Get.to(() => VehicleDetailsPage(vehicle: v));
                      },

                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Get.to(() => VehicleFormPage(vehicle: v));
                          } else if (value == 'delete') {
                            ctrl.deleteVehicle(v.id);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Modifier'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Supprimer'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const VehicleFormPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Vignette de la voiture (photo ou icône par défaut)
  Widget _buildThumbnail(Vehicle v) {
    if (v.photos.isNotEmpty && v.photos.first.isNotEmpty) {
      final url = v.photos.first;
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return const Icon(Icons.directions_car, size: 40);
          },
        ),
      );
    }

    // Pas de photo => icône voiture
    return const CircleAvatar(
      radius: 26,
      child: Icon(Icons.directions_car),
    );
  }
}


