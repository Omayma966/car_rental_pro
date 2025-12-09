import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/reservation_controller.dart';
import '../../models/reservation.dart';
import 'reservation_form_page.dart';
import 'reservation_details_page.dart';

class ReservationsListPage extends StatelessWidget {
  const ReservationsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ReservationController());

    return Scaffold(
      appBar: AppBar(title: const Text('Réservations')),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.reservations.isEmpty) {
          return const Center(child: Text('Aucune réservation.'));
        }
        return ListView.builder(
          itemCount: ctrl.reservations.length,
          itemBuilder: (context, index) {
            final Reservation r = ctrl.reservations[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ListTile(
                onTap: () {
                  // 👉 Ouvrir la page de détails
                  Get.to(() => ReservationDetailsPage(reservation: r));
                },
                title: Text(
                  'Réservation ${r.id.substring(0, 6)}...',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Client: ${r.clientId.substring(0, 6)}...   '
                          'Véhicule: ${r.vehicleId.substring(0, 6)}...',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${r.startDate.toLocal().toString().substring(0, 10)} '
                          '→ ${r.endDate.toLocal().toString().substring(0, 10)}',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${r.totalAmount.toStringAsFixed(2)} TND',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _statusChip(r.status),
                        const SizedBox(width: 8),
                        _paymentChip(r.paymentStatus),
                      ],
                    ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.to(() => ReservationFormPage(reservation: r));
                    } else if (value == 'delete') {
                      ctrl.deleteReservation(r.id);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const ReservationFormPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // ---------- Petits helpers pour les badges ----------

  Widget _statusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'approved':
        color = Colors.green;
        label = 'Confirmée';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Annulée';
        break;
      case 'pending':
      default:
        color = Colors.orange;
        label = 'En attente';
        break;
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w500),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _paymentChip(String paymentStatus) {
    Color color;
    String label;

    switch (paymentStatus) {
      case 'paid':
        color = Colors.green;
        label = 'Payé';
        break;
      case 'partial':
        color = Colors.blue;
        label = 'Partiel';
        break;
      case 'unpaid':
      default:
        color = Colors.red;
        label = 'Non payé';
        break;
    }

    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w500),
      visualDensity: VisualDensity.compact,
    );
  }
}
