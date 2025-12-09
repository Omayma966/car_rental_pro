import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static late SupabaseClient client;

  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://lptsmxgtkhgshtzxljew.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxwdHNteGd0a2hnc2h0enhsamV3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUyODUzNTcsImV4cCI6MjA4MDg2MTM1N30.nkUI1el1EvcWiJOuQ2Twelij7YLJO53guAuKDnGYMyw',
    );
    client = Supabase.instance.client;
  }
}
