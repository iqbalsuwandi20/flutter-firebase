import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  void logout() async {
    try {
      await auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print(e);
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat keluar akun");
    }
  }
}
