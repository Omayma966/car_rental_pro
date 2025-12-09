import 'package:get/get.dart';

import 'pages/auth/login_page.dart';
import 'pages/shell/shell_page.dart';
import 'pages/vehicles/vehicles_list_page.dart';
import 'pages/vehicles/vehicle_form_page.dart';
import 'pages/clients/clients_list_page.dart';
import 'pages/clients/client_form_page.dart';
import 'pages/reservations/reservations_list_page.dart';
import 'pages/reservations/reservation_form_page.dart';
import 'pages/agents/agents_list_page.dart';
import 'pages/agents/agent_form_page.dart';

class AppRouter {
  static const String initialRoute = '/login';

  static final routes = <GetPage>[
    GetPage(name: '/login', page: () =>  LoginPage()),
    GetPage(name: '/shell', page: () => const ShellPage()),

    // Vehicles
    GetPage(name: '/vehicles', page: () => const VehiclesListPage()),
    GetPage(name: '/vehicles/new', page: () => const VehicleFormPage()),
    GetPage(
      name: '/vehicles/edit',
      page: () => const VehicleFormPage(),
    ),

    // Clients
    GetPage(name: '/clients', page: () => const ClientsListPage()),
    GetPage(name: '/clients/new', page: () => const ClientFormPage()),

    // Reservations
    GetPage(
        name: '/reservations',
        page: () => const ReservationsListPage()),
    GetPage(
        name: '/reservations/new',
        page: () => const ReservationFormPage()),

    // Agents
    GetPage(name: '/agents', page: () => const AgentsListPage()),
    GetPage(name: '/agents/new', page: () => const AgentFormPage()),
  ];
}
