import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/client_controller.dart';
import '../../models/client.dart';
import '../../widgets/app_button.dart';

class ClientFormPage extends StatefulWidget {
  final Client? client;

  const ClientFormPage({super.key, this.client});

  @override
  State<ClientFormPage> createState() => _ClientFormPageState();
}

class _ClientFormPageState extends State<ClientFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _typeCtrl = TextEditingController(text: 'Particulier');
  final _segmentCtrl = TextEditingController(text: 'Régulier');
  final _addressCtrl = TextEditingController();
  final _cinCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      final c = widget.client!;
      _firstCtrl.text = c.firstName;
      _lastCtrl.text = c.lastName;
      _emailCtrl.text = c.email;
      _phoneCtrl.text = c.phone;
      _typeCtrl.text = c.type;
      _segmentCtrl.text = c.segment;
      _addressCtrl.text = c.address ?? '';
      _cinCtrl.text = c.cin ?? '';
    }
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _typeCtrl.dispose();
    _segmentCtrl.dispose();
    _addressCtrl.dispose();
    _cinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ClientController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.client == null ? 'Nouveau client' : 'Modifier le client',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_firstCtrl, 'Prénom *'),
            _field(_lastCtrl, 'Nom *'),
            _field(_emailCtrl, 'Email *',
                keyboardType: TextInputType.emailAddress),
            _field(_phoneCtrl, 'Téléphone *',
                keyboardType: TextInputType.phone),
            _field(_typeCtrl, 'Type (Particulier / Société)'),
            _field(_segmentCtrl, 'Segment (Régulier / VIP...)'),
            _field(_addressCtrl, 'Adresse'),
            _field(_cinCtrl, 'CIN'),

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

                      final payload = {
                        'first_name': _firstCtrl.text.trim(),
                        'last_name': _lastCtrl.text.trim(),
                        'email': _emailCtrl.text.trim(),
                        'phone': _phoneCtrl.text.trim(),
                        'type': _typeCtrl.text.trim(),
                        'segment': _segmentCtrl.text.trim(),
                        'address': _addressCtrl.text.trim().isEmpty
                            ? null
                            : _addressCtrl.text.trim(),
                        'cin': _cinCtrl.text.trim().isEmpty
                            ? null
                            : _cinCtrl.text.trim(),
                      };

                      await ctrl.saveClient(
                          existing: widget.client, payload: payload);

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

  Widget _field(TextEditingController c, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    final requiredField = label.contains('*');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label.replaceAll('*', '')),
        validator: requiredField
            ? (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Champ obligatoire';
          }
          return null;
        }
            : null,
      ),
    );
  }
}
