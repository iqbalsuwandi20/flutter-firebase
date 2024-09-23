import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final box =
      GetStorage(); // Ini buat nyimpen data lokal pake GetStorage, praktis banget guys
  @override
  Widget build(BuildContext context) {
    // Cek dulu nih, kalo ada data "rememberMe" di GetStorage, kita set email sama password di controller
    if (box.read("rememberMe") != null) {
      controller.emailC.text = box.read(
          "rememberMe")["email"]; // Auto-fill email dari data "rememberMe"
      controller.passC.text = box.read("rememberMe")[
          "password"]; // Auto-fill password dari data "rememberMe"
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[
            600], // Set warna AppBar jadi biru, biar matching ama tema app
        title: const Text(
          'Login', // Teks di AppBar, simpel aja tulis "Login"
          style: TextStyle(
              color: Colors
                  .white), // Set warna teks jadi putih biar kontras ama biru
        ),
        leading:
            const SizedBox(), // Gak pake tombol back di AppBar biar user stay di halaman login
      ),
      body: ListView(
        padding: const EdgeInsets.all(
            30), // Padding buat ngatur jarak item di dalam ListView biar ga dempet
        children: [
          // TextField buat input email user, lengkap sama icon email di sebelah kiri
          TextField(
            controller: controller
                .emailC, // Gunain controller email dari LoginController
            autocorrect:
                false, // Auto-correct dimatiin biar gak ada typo random
            textInputAction: TextInputAction
                .next, // Kalo tekan enter langsung ke input berikutnya
            decoration: InputDecoration(
                icon: Icon(
                  Icons
                      .email_outlined, // Icon email biar user tau ini buat input email
                  color: Colors
                      .blue[600], // Set warna icon jadi biru, matching ama tema
                ),
                labelText: "Email", // Teks label di TextField buat email
                border:
                    const OutlineInputBorder()), // Biar ada border di TextField-nya, jadi keliatan rapih
          ),
          const SizedBox(
              height: 20), // Jarak vertikal antar widget biar ga nempel

          // TextField buat input password user, dilengkapi icon visibility toggle buat hide/show password
          Obx(
            () {
              return TextField(
                controller: controller
                    .passC, // Gunain controller password dari LoginController
                obscureText: controller.isHidden
                    .value, // ObscureText biar password ga keliatan pas diketik
                autocorrect:
                    false, // Auto-correct dimatiin biar password ga berubah
                textInputAction: TextInputAction
                    .next, // Kalo tekan enter langsung ke input berikutnya
                decoration: InputDecoration(
                    icon: Icon(
                      Icons
                          .key_off_outlined, // Icon kunci biar user tau ini buat input password
                      color: Colors
                          .blue[600], // Warna icon biru, match ama tema app
                    ),
                    labelText:
                        "Kata Sandi", // Teks label di TextField buat password
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.isHidden
                              .toggle(); // Buat toggle hide/show password kalo icon di-klik
                        },
                        icon: Icon(
                          controller.isHidden.isTrue
                              ? Icons
                                  .remove_red_eye_outlined // Icon mata buat nunjukin password lagi disembunyiin
                              : Icons
                                  .remove_red_eye_rounded, // Icon mata terbuka buat nunjukin password keliatan
                          color: Colors.blue[
                              600], // Warna icon matching ama warna biru tema
                        )),
                    border:
                        const OutlineInputBorder()), // Set border TextField biar rapi
              );
            },
          ),

          // Checkbox buat pilihan "Ingatkan Saya", kalo dicentang, email dan password akan disimpan
          Obx(
            () {
              return CheckboxListTile(
                value: controller
                    .rememberMe.value, // Checkbox value dari LoginController
                onChanged: (value) {
                  controller.rememberMe
                      .toggle(); // Toggle status "Remember Me" kalo dicentang atau dihapus centangnya
                },
                title: Text(
                  "Ingatkan Saya", // Teks label buat pilihan "Remember Me"
                  style: TextStyle(
                    color: Colors
                        .blue[600], // Warna teks biru, biar match ama tema app
                    fontWeight: FontWeight
                        .bold, // Biar teksnya lebih stand out, ditambahin fontWeight bold
                  ),
                ),
                controlAffinity: ListTileControlAffinity
                    .leading, // Set posisi checkbox di sebelah kiri teks
                activeColor: Colors.blue[600], // Warna checkbox biru kalo aktif
              );
            },
          ),

          // Baris button buat navigasi ke halaman reset password kalo user lupa password
          Row(
            mainAxisAlignment:
                MainAxisAlignment.end, // Atur posisi button di pojok kanan
            children: [
              SizedBox(
                width: 150, // Lebar button dibatesin biar proporsional
                child: TextButton(
                    onPressed: () {
                      Get.toNamed(Routes
                          .RESET_PASSWORD); // Kalo button di-klik, navigasi ke halaman reset password
                    },
                    child: Text(
                      "Reset Kata Sandi?", // Teks di button buat reset password
                      style: TextStyle(
                        color: Colors.blue[600], // Warna teks biru
                        fontWeight: FontWeight
                            .bold, // Font weight bold biar teksnya lebih mencolok
                      ),
                    )),
              ),
            ],
          ),

          const SizedBox(
              height:
                  50), // Jarak vertikal sebelum button login biar ga terlalu mepet

          // Button buat login, teksnya berubah jadi "LAGI PROSES.." kalo lagi loading
          Obx(
            () {
              return ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller
                        .login(); // Panggil function login dari LoginController kalo button di-klik
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors
                        .blue[600]), // Style button biru biar match ama tema
                child: Text(
                  controller.isLoading.isFalse
                      ? "MASUK"
                      : "LAGI PROSES..", // Teks button berubah kalo lagi loading
                  style: const TextStyle(
                      color: Colors
                          .white), // Warna teks putih biar kontras ama warna button biru
                ),
              );
            },
          ),

          // Button buat navigasi ke halaman register kalo user belum punya akun
          TextButton(
              onPressed: () {
                Get.toNamed(Routes
                    .REGISTER); // Navigasi ke halaman register kalo button di-klik
              },
              child: Text(
                "Buat Akun?", // Teks di button buat register akun baru
                style: TextStyle(
                  color: Colors.blue[600], // Warna teks biru, matching ama tema
                  fontWeight:
                      FontWeight.bold, // Font bold biar teks lebih stand out
                ),
              )),
        ],
      ),
    );
  }
}
