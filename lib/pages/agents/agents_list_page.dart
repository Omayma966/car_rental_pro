import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/agent_controller.dart';
import '../../models/agent.dart';
import 'agent_form_page.dart';

class AgentsListPage extends StatelessWidget {
  const AgentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AgentController());

    return Scaffold(
      appBar: AppBar(title: const Text('Agents')),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.agents.isEmpty) {
          return const Center(child: Text('Aucun agent.'));
        }
        return ListView.builder(
          itemCount: ctrl.agents.length,
          itemBuilder: (context, index) {
            final Agent a = ctrl.agents[index];
            return Card(
              margin:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ListTile(
                title: Text(a.fullName),
                subtitle:
                Text('${a.email}${a.phone != null ? ' • ${a.phone}' : ''}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.to(() => AgentFormPage(agent: a));
                    } else if (value == 'delete') {
                      ctrl.deleteAgent(a.id);
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
          Get.to(() => const AgentFormPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
