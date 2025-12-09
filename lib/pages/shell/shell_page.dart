import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard/dashboard_page.dart';
import '../reservations/reservations_list_page.dart';
import '../clients/clients_list_page.dart';
import '../vehicles/vehicles_list_page.dart';
import '../agents/agents_list_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  final _pages = const [
    DashboardPage(),
    ReservationsListPage(),
    ClientsListPage(),
    VehiclesListPage(),
    AgentsListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _index,                 // ⬅️ indique l'onglet actif
        selectedItemColor: Colors.black,      // icône + label sélectionnés
        unselectedItemColor: Colors.grey,     // icônes non sélectionnés
        elevation: 8,
        onTap: (int newIndex) {               // ⬅️ changer de page
          setState(() {
            _index = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Réservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Véhicules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Agents',
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                'CarRental Pro',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.badge),
              title: const Text('Agents'),
              onTap: () {
                Get.to(() => const AgentsListPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
