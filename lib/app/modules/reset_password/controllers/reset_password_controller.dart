import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  TextEditingController emailC = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void reset() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);

        isLoading.value = false;
        Get.back();

        Get.snackbar("BERHASIL",
            "Mohon cek inbox email anda karena sudah dikirim link untuk reset kata sandi");
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        Get.snackbar("TERJADI KESALAHAN", e.code);
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
            "TERJADI KESALAHAN", "Tidak dapat reset kata sandi ke email ini");
      }
    } else {
      Get.snackbar("TERJADI KESALAHAN", "Email belum di isi");
    }
  }
}
