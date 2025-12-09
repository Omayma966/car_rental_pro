import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Obx(() {
        if (authCtrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (v) =>
                  (v == null || v.isEmpty) ? 'Email obligatoire' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  decoration:
                  const InputDecoration(labelText: 'Mot de passe'),
                  obscureText: true,
                  validator: (v) =>
                  (v == null || v.length < 8) ? 'Min 8 caractères' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    authCtrl.login(
                      _emailCtrl.text.trim(),
                      _passwordCtrl.text.trim(),
                    );
                  },
                  child: const Text('Se connecter'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
