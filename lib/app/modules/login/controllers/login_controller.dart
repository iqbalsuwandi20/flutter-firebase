import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  FirebaseAuth auth =
      FirebaseAuth.instance; // Inisialisasi FirebaseAuth buat autentikasi user

  TextEditingController emailC =
      TextEditingController(); // Buat controller input email
  TextEditingController passC =
      TextEditingController(); // Buat controller input password

  RxBool isLoading = false.obs; // Variabel buat ngecek loading state
  RxBool isHidden = true.obs; // Variabel buat hide/show password pas input
  RxBool rememberMe = false.obs; // Variabel buat toggle "Remember Me"

  final box =
      GetStorage(); // Inisialisasi GetStorage buat nyimpen data di local storage

  // Function buat nampilin error message kalo ada kesalahan
  void errorMessage(String msg) {
    Get.snackbar("Terjadi Kesalahan",
        msg); // Pop up pesan error biar user tau ada yang salah
  }

  // Function buat login user ke app
  void login() async {
    // Cek apakah email dan password udah diisi
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value =
          true; // Tampilkan loading state biar user tau lagi diproses
      try {
        // Panggil Firebase Authentication buat login pakai email dan password
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        print(
            userCredential); // Buat debug, nampilin informasi user credential di console

        isLoading.value = false; // Loading selesai, reset loading state

        // Cek apakah email user udah diverifikasi atau belum
        if (userCredential.user!.emailVerified == true) {
          // Kalau user pilih "Remember Me", simpen email dan password di local storage
          if (box.read("rememberMe") != null) {
            await box.remove("rememberMe"); // Hapus data lama kalo ada
          }
          if (rememberMe.isTrue) {
            await box.write("rememberMe", {
              "email": emailC.text,
              "password": passC.text,
            }); // Simpen email dan password di GetStorage
          }

          // Navigasi ke halaman HOME setelah berhasil login
          Get.offAllNamed(Routes.HOME);
        } else {
          // Kalau user belum verifikasi email, tampilin dialog buat konfirmasi pengiriman ulang
          Get.defaultDialog(
            title: "Belum terverifikasi",
            middleText:
                "Apakah kamu ingin mengirim email verifikasi lagi?", // Tanya user mau kirim email verifikasi lagi atau nggak
            actions: [
              // Tombol TIDAK buat batal kirim verifikasi ulang
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[
                          600]), // Warna tombol biru biar matching ama tema
                  onPressed: () => Get.back, // Kalo diklik, dialognya ditutup
                  child: const Text(
                    "TIDAK", // Teks di tombol "TIDAK"
                    style: TextStyle(
                        color: Colors
                            .white), // Warna teks putih biar kontras ama background
                  )),
              // Tombol buat kirim ulang verifikasi email
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600]), // Warna tombol biru
                  onPressed: () async {
                    try {
                      await userCredential.user!
                          .sendEmailVerification(); // Kirim ulang email verifikasi
                      Get.back(); // Tutup dialog
                      Get.snackbar("Berhasil",
                          "Mohon cek inbox email"); // Kasih pesan kalau email verifikasi udah dikirim
                    } catch (e) {
                      Get.back(); // Tutup dialog
                      Get.snackbar("Terjadi Kesalahan",
                          "Terlalu banyak mengirim verifikasi"); // Error message kalo gagal kirim ulang email
                    }
                  },
                  child: const Text(
                    "KIRIM LAGI DONG", // Teks tombol buat kirim ulang
                    style: TextStyle(color: Colors.white), // Warna teks putih
                  )),
            ],
          );

          // Notifikasi tambahan biar user tau dia harus verifikasi email
          Get.snackbar("Terjadi Kesalahan",
              "Mohon cek inbox email anda untuk verifikasi");
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false; // Reset loading state kalo ada error

        errorMessage(
            e.code); // Kasih error message ke user biar tau ada kesalahan apa

        // Commented block buat handle error khusus
        // if (e.code == "user-not-found") {
        //   print("Tidak ditemukan pengguna email tersebut");
        // } else if (e.code == "wrong-password") {
        //   print("Kata sandi yang diberikan tersebut salah.");
        // }
      }
    } else {
      errorMessage(
          "Email dan Kata Sandi harus di isi"); // Pesan error kalau email atau password belum diisi
    }
  }
}
