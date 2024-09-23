import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth untuk manajemen autentikasi
import 'package:flutter/material.dart'; // Import material design untuk tampilan UI
import 'package:get/get.dart'; // Import GetX untuk state management dan routing

class ResetPasswordController extends GetxController {
  TextEditingController emailC =
      TextEditingController(); // Controller untuk input email

  RxBool isLoading = false.obs; // Variabel reaktif untuk status loading

  FirebaseAuth auth = FirebaseAuth.instance; // Instance Firebase Auth

  void reset() async {
    // Fungsi untuk mereset kata sandi
    if (emailC.text.isNotEmpty) {
      // Cek apakah email tidak kosong
      isLoading.value = true; // Set loading ke true
      try {
        await auth.sendPasswordResetEmail(
            email: emailC.text); // Kirim email reset kata sandi

        isLoading.value = false; // Set loading ke false
        Get.back(); // Kembali ke halaman sebelumnya

        Get.snackbar(
            "BERHASIL", // Tampilkan snackbar sukses
            "Mohon cek inbox email anda karena sudah dikirim link untuk reset kata sandi");
      } on FirebaseAuthException catch (e) {
        // Cek jika terjadi error dari Firebase
        isLoading.value = false; // Set loading ke false
        Get.snackbar("TERJADI KESALAHAN", e.code); // Tampilkan snackbar error
      } catch (e) {
        // Cek error umum
        isLoading.value = false; // Set loading ke false
        Get.snackbar("TERJADI KESALAHAN",
            "Tidak dapat reset kata sandi ke email ini"); // Tampilkan snackbar error
      }
    } else {
      // Jika email kosong
      Get.snackbar("TERJADI KESALAHAN",
          "Email belum di isi"); // Tampilkan snackbar error
    }
  }
}
