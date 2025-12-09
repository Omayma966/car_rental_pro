import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/reservation.dart';
import '../../models/client.dart';
import '../../models/vehicle.dart';
import '../../models/agent.dart';

import '../../services/client_service.dart';
import '../../services/vehicle_service.dart';
import '../../services/agent_service.dart';

import '../../controllers/reservation_controller.dart';
import '../../widgets/app_button.dart';

class ReservationDetailsPage extends StatefulWidget {
  final Reservation reservation;

  const ReservationDetailsPage({super.key, required this.reservation});

  @override
  State<ReservationDetailsPage> createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  Client? _client;
  Vehicle? _vehicle;
  Agent? _agent;

  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final clientService = ClientService();
      final vehicleService = VehicleService();
      final agentService = AgentService();

      final r = widget.reservation;

      final client = await clientService.getClientById(r.clientId);
      final vehicle = await vehicleService.getVehicleById(r.vehicleId);
      Agent? agent;
      if (r.agentId != null) {
        agent = await agentService.getAgentById(r.agentId!);
      }

      setState(() {
        _client = client;
        _vehicle = vehicle;
        _agent = agent;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reservation;
    final reservationCtrl = Get.find<ReservationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail réservation'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Text('Erreur : $_error'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Résumé réservation -----
            _sectionTitle('Réservation'),
            _infoRow('ID', r.id),
            _infoRow('Date début',
                r.startDate.toLocal().toString().substring(0, 10)),
            _infoRow('Date fin',
                r.endDate.toLocal().toString().substring(0, 10)),
            _infoRow(
              'Montant total',
              '${r.totalAmount.toStringAsFixed(2)} TND',
            ),
            _infoRow('Statut', _statusLabel(r.status)),
            _infoRow('Paiement', _paymentLabel(r.paymentStatus)),
            const SizedBox(height: 16),

            // ----- Client -----
            _sectionTitle('Client'),
            if (_client == null)
              const Text('Client introuvable'),
            if (_client != null) ...[
              _infoRow(
                'Nom',
                '${_client!.firstName} ${_client!.lastName}',
              ),
              _infoRow('Email', _client!.email),
              _infoRow('Téléphone', _client!.phone ?? '-'),
              _infoRow('Adresse', _client!.address ?? '-'),
              _infoRow('Type', _client!.type),
              _infoRow('Segment', _client!.segment),
            ],
            const SizedBox(height: 16),

            // ----- Véhicule -----
            _sectionTitle('Véhicule'),
            if (_vehicle == null)
              const Text('Véhicule introuvable'),
            if (_vehicle != null) ...[
              _infoRow('Modèle', _vehicle!.displayName),
              _infoRow('Plaque', _vehicle!.plateNumber),
              _infoRow('Couleur', _vehicle!.color),
              _infoRow('Places', _vehicle!.seats.toString()),
              _infoRow(
                'Prix / jour',
                '${_vehicle!.pricePerDay.toStringAsFixed(2)} TND',
              ),
            ],
            const SizedBox(height: 16),

            // ----- Agent -----
            _sectionTitle('Agent'),
            if (_agent == null)
              const Text('Aucun agent affecté'),
            if (_agent != null) ...[
              _infoRow('Nom', _agent!.fullName),
              _infoRow('Email', _agent!.email),
              _infoRow('Téléphone', _agent!.phone ?? '-'),
              _infoRow('Actif', _agent!.active ? 'Oui' : 'Non'),
            ],
            const SizedBox(height: 24),

            // ----- Actions -----
            _sectionTitle('Actions'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Accepter',
                    onPressed: () async {
                      await reservationCtrl.updateStatus(
                        reservation: r,
                        status: 'approved',
                      );
                      Get.snackbar(
                        'Succès',
                        'Réservation acceptée',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Get.back(); // retour à la liste
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: 'Refuser',
                    primary: false,
                    onPressed: () async {
                      await reservationCtrl.updateStatus(
                        reservation: r,
                        status: 'cancelled',
                      );
                      Get.snackbar(
                        'Succès',
                        'Réservation annulée',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Marquer comme payé',
              onPressed: () async {
                await reservationCtrl.updatePaymentStatus(
                  reservation: r,
                  paymentStatus: 'paid',
                );
                Get.snackbar(
                  'Succès',
                  'Paiement marqué comme payé',
                  snackPosition: SnackPosition.BOTTOM,
                );
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ----- Helpers UI -----

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label :',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'approved':
        return 'Confirmée';
      case 'cancelled':
        return 'Annulée';
      case 'pending':
      default:
        return 'En attente';
    }
  }

  String _paymentLabel(String ps) {
    switch (ps) {
      case 'paid':
        return 'Payé';
      case 'partial':
        return 'Partiel';
      case 'unpaid':
      default:
        return 'Non payé';
    }
  }
}
