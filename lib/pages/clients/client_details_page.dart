import 'package:flutter/material.dart';

import '../../models/client.dart';

class ClientDetailsPage extends StatelessWidget {
  final Client client;

  const ClientDetailsPage({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(client.fullName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _row('Nom complet', client.fullName),
            _row('Email', client.email),
            _row('Téléphone', client.phone),
            _row('Type', client.type),
            _row('Segment', client.segment),
            if (client.address != null && client.address!.isNotEmpty)
              _row('Adresse', client.address!),
            if (client.cin != null && client.cin!.isNotEmpty)
              _row('CIN', client.cin!),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label :',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
