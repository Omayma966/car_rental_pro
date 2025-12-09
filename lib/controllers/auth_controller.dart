import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../models/user_profile.dart';
import '../app_router.dart';

class AuthController extends GetxController {
  final AuthService _service = AuthService();

  final RxBool isLoading = false.obs;
  final Rxn<UserProfile> profile = Rxn<UserProfile>();

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _service.signIn(email, password);
      profile.value = await _service.getCurrentProfile();
      Get.offAllNamed('/shell');
    } catch (e) {
      Get.snackbar('Erreur de connexion', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
