import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/reservation_controller.dart';
import '../../controllers/client_controller.dart';
import '../../controllers/vehicle_controller.dart';
import '../../controllers/agent_controller.dart';

import '../../models/reservation.dart';
import '../../models/client.dart';
import '../../models/vehicle.dart';
import '../../models/agent.dart';
import '../../widgets/app_button.dart';

class ReservationFormPage extends StatefulWidget {
  final Reservation? reservation;

  const ReservationFormPage({super.key, this.reservation});

  @override
  State<ReservationFormPage> createState() => _ReservationFormPageState();
}

class _ReservationFormPageState extends State<ReservationFormPage> {
  final _formKey = GlobalKey<FormState>();

  // contrôleurs pour affichage (nom), pas pour les IDs
  final _clientCtrl = TextEditingController();
  final _vehicleCtrl = TextEditingController();
  final _agentCtrl = TextEditingController();
  final _totalCtrl = TextEditingController(text: '0');

  Client? _selectedClient;
  Vehicle? _selectedVehicle;
  Agent? _selectedAgent;

  String _status = 'pending';
  String _paymentStatus = 'unpaid';

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();

    // On s'assure que les listes sont chargées
    final clientController = Get.put(ClientController());
    final vehicleController = Get.put(VehicleController());
    final agentController = Get.put(AgentController());

    clientController.loadClients();
    vehicleController.loadVehicles();
    agentController.loadAgents();

    if (widget.reservation != null) {
      final r = widget.reservation!;
      _totalCtrl.text = r.totalAmount.toString();
      _status = r.status;
      _paymentStatus = r.paymentStatus;
      _startDate = r.startDate;
      _endDate = r.endDate;

      // ⚠️ Pour simplifier, on ne pré-sélectionne pas encore les noms.
      // Tu pourras améliorer plus tard si tu veux faire un "edit" 100% parfait.
    }
  }

  @override
  void dispose() {
    _clientCtrl.dispose();
    _vehicleCtrl.dispose();
    _agentCtrl.dispose();
    _totalCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final result = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (result != null) {
      setState(() {
        if (isStart) {
          _startDate = result;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = result;
        }
      });
    }
  }

  // ---------- Pickers (client / vehicle / agent) ----------

  Future<void> _selectClient(ClientController ctrl) async {
    final result = await showModalBottomSheet<Client>(
      context: context,
      builder: (context) {
        return Obx(() {
          final list = ctrl.clients;
          if (list.isEmpty) {
            return const Center(child: Text('Aucun client.'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final c = list[index];
              return ListTile(
                title: Text('${c.firstName} ${c.lastName}'),
                subtitle: Text(c.email),
                onTap: () => Navigator.pop(context, c),
              );
            },
          );
        });
      },
    );

    if (result != null) {
      setState(() {
        _selectedClient = result;
        _clientCtrl.text = '${result.firstName} ${result.lastName}';
      });
    }
  }

  Future<void> _selectVehicle(VehicleController ctrl) async {
    final result = await showModalBottomSheet<Vehicle>(
      context: context,
      builder: (context) {
        return Obx(() {
          final list = ctrl.vehicles;
          if (list.isEmpty) {
            return const Center(child: Text('Aucun véhicule.'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final v = list[index];
              return ListTile(
                title: Text(v.displayName),
                subtitle: Text(v.plateNumber),
                onTap: () => Navigator.pop(context, v),
              );
            },
          );
        });
      },
    );

    if (result != null) {
      setState(() {
        _selectedVehicle = result;
        _vehicleCtrl.text = '${result.brand} ${result.model} (${result.plateNumber})';
      });
    }
  }

  Future<void> _selectAgent(AgentController ctrl) async {
    final result = await showModalBottomSheet<Agent>(
      context: context,
      builder: (context) {
        return Obx(() {
          final list = ctrl.agents;
          if (list.isEmpty) {
            return const Center(child: Text('Aucun agent.'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final a = list[index];
              return ListTile(
                title: Text(a.fullName),
                subtitle: Text(a.email),
                onTap: () => Navigator.pop(context, a),
              );
            },
          );
        });
      },
    );

    if (result != null) {
      setState(() {
        _selectedAgent = result;
        _agentCtrl.text = result.fullName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationCtrl = Get.find<ReservationController>();
    final clientCtrl = Get.find<ClientController>();
    final vehicleCtrl = Get.find<VehicleController>();
    final agentCtrl = Get.find<AgentController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reservation == null
              ? 'Nouvelle réservation'
              : 'Modifier la réservation',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---------- Client ----------
            TextFormField(
              controller: _clientCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Client *',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: () => _selectClient(clientCtrl),
              validator: (value) {
                if (_selectedClient == null) {
                  return 'Veuillez choisir un client';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ---------- Véhicule ----------
            TextFormField(
              controller: _vehicleCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Véhicule *',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: () => _selectVehicle(vehicleCtrl),
              validator: (value) {
                if (_selectedVehicle == null) {
                  return 'Veuillez choisir un véhicule';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // ---------- Agent (optionnel) ----------
            TextFormField(
              controller: _agentCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Agent (optionnel)',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: () => _selectAgent(agentCtrl),
            ),

            const SizedBox(height: 16),

            // ---------- Dates ----------
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date début'),
              subtitle: Text(_startDate.toLocal().toString().substring(0, 10)),
              trailing: IconButton(
                icon: const Icon(Icons.date_range),
                onPressed: () => _pickDate(isStart: true),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date fin'),
              subtitle: Text(_endDate.toLocal().toString().substring(0, 10)),
              trailing: IconButton(
                icon: const Icon(Icons.date_range),
                onPressed: () => _pickDate(isStart: false),
              ),
            ),

            TextFormField(
              controller: _totalCtrl,
              keyboardType: TextInputType.number,
              decoration:
              const InputDecoration(labelText: 'Montant total (TND) *'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Champ obligatoire';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Statut'),
              items: const [
                DropdownMenuItem(
                  value: 'pending',
                  child: Text('En attente'),
                ),
                DropdownMenuItem(
                  value: 'approved',
                  child: Text('Confirmée'),
                ),
                DropdownMenuItem(
                  value: 'cancelled',
                  child: Text('Annulée'),
                ),
              ],
              onChanged: (v) => setState(() => _status = v ?? 'pending'),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _paymentStatus,
              decoration:
              const InputDecoration(labelText: 'Statut de paiement'),
              items: const [
                DropdownMenuItem(
                  value: 'unpaid',
                  child: Text('Non payé'),
                ),
                DropdownMenuItem(
                  value: 'paid',
                  child: Text('Payé'),
                ),
                DropdownMenuItem(
                  value: 'partial',
                  child: Text('Partiel'),
                ),
              ],
              onChanged: (v) =>
                  setState(() => _paymentStatus = v ?? 'unpaid'),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Annuler',
                    primary: false,
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: 'Enregistrer',
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      // ⚠️ Sécurité : on vérifie quand même
                      if (_selectedClient == null || _selectedVehicle == null) {
                        Get.snackbar('Erreur', 'Client et véhicule obligatoires');
                        return;
                      }

                      final payload = {
                        'client_id': _selectedClient!.id,
                        'vehicle_id': _selectedVehicle!.id,
                        'agent_id': _selectedAgent?.id,
                        // colonne "date" dans Postgres → on envoie YYYY-MM-DD
                        'start_date':
                        _startDate.toIso8601String().substring(0, 10),
                        'end_date':
                        _endDate.toIso8601String().substring(0, 10),
                        'total_amount':
                        double.tryParse(_totalCtrl.text) ?? 0,
                        'status': _status,
                        'payment_status': _paymentStatus,
                      };

                      await reservationCtrl.saveReservation(
                        existing: widget.reservation,
                        payload: payload,
                      );

                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
