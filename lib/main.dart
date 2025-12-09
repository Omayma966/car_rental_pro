import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_router.dart';
import 'services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init(); // init Supabase

  runApp(const CarRentalProApp());
}

class CarRentalProApp extends StatelessWidget {
  const CarRentalProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CarRental Pro',
      debugShowCheckedModeBanner: false,
  //    theme: AppTheme.darkTheme,
      initialRoute: AppRouter.initialRoute,
      getPages: AppRouter.routes,
    );
  }
}
