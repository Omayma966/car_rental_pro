import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/client_controller.dart';
import '../../models/client.dart';
import 'client_form_page.dart';
import 'client_details_page.dart';

class ClientsListPage extends StatelessWidget {
  const ClientsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ClientController());

    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      body: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Rechercher par nom ou email',
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
              if (ctrl.clients.isEmpty) {
                return const Center(
                  child: Text('Aucun client pour le moment.'),
                );
              }
              return ListView.builder(
                itemCount: ctrl.clients.length,
                itemBuilder: (context, index) {
                  final Client c = ctrl.clients[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    child: ListTile(
                      title: Text(c.fullName),
                      subtitle: Text('${c.email} • ${c.phone}'),
                      onTap: () {
                        Get.to(() => ClientDetailsPage(client: c));
                      },
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Get.to(() => ClientFormPage(client: c));
                          } else if (value == 'delete') {
                            ctrl.deleteClient(c.id);
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
          Get.to(() => const ClientFormPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
