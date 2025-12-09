import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      body: const Center(
        child: Text(
          'Tableau de bord (stats à ajouter)',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
