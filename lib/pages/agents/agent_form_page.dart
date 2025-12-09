import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/agent_controller.dart';
import '../../models/agent.dart';
import '../../widgets/app_button.dart';

class AgentFormPage extends StatefulWidget {
  final Agent? agent;

  const AgentFormPage({super.key, this.agent});

  @override
  State<AgentFormPage> createState() => _AgentFormPageState();
}

class _AgentFormPageState extends State<AgentFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _active = true;

  @override
  void initState() {
    super.initState();
    if (widget.agent != null) {
      final a = widget.agent!;
      _fullNameCtrl.text = a.fullName;
      _emailCtrl.text = a.email;
      _phoneCtrl.text = a.phone ?? '';
      _active = a.active;
    }
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AgentController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.agent == null ? 'Nouvel agent' : 'Modifier l’agent',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_fullNameCtrl, 'Nom complet *'),
            _field(
              _emailCtrl,
              'Email *',
              keyboardType: TextInputType.emailAddress,
            ),
            _field(
              _phoneCtrl,
              'Téléphone',
              keyboardType: TextInputType.phone,
            ),
            SwitchListTile(
              title: const Text('Actif'),
              value: _active,
              onChanged: (v) => setState(() => _active = v),
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

                      //final user =
                        //  Supabase.instance.client.auth.currentUser;



                      final payload = {
                     //   'profile_id': user.id, // 🔥 automatique
                        'full_name': _fullNameCtrl.text.trim(),
                        'email': _emailCtrl.text.trim(),
                        'phone': _phoneCtrl.text.trim().isEmpty
                            ? null
                            : _phoneCtrl.text.trim(),
                        'active': _active,
                      };

                      try {
                        await ctrl.saveAgent(
                          existing: widget.agent,
                          payload: payload,
                        );
                        Get.back();
                      } catch (e) {
                        Get.snackbar(
                          'Erreur',
                          e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
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

  Widget _field(
      TextEditingController c,
      String label, {
        TextInputType keyboardType = TextInputType.text,
      }) {
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
