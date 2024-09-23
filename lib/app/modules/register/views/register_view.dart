import 'package:flutter/material.dart'; // Import material design untuk tampilan UI
import 'package:get/get.dart'; // Import GetX untuk state management dan routing

import '../../../routes/app_pages.dart'; // Import routes untuk navigasi
import '../controllers/register_controller.dart'; // Import controller untuk registrasi

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key}); // Constructor untuk RegisterView
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600], // Set warna background app bar
        title: const Text(
          'Register', // Judul halaman
          style: TextStyle(color: Colors.white), // Gaya teks judul
        ),
        leading: const SizedBox(), // Hapus icon leading
      ),
      body: ListView(
        padding: const EdgeInsets.all(30), // Padding untuk body
        children: [
          TextField(
            controller: controller.nameC, // Controller untuk nama
            autocorrect: false, // Nonaktifkan autocorrect
            keyboardType: TextInputType.name, // Set tipe keyboard untuk nama
            textInputAction: TextInputAction.next, // Set action selanjutnya
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person_3_outlined, // Icon untuk nama
                  color: Colors.blue[600], // Warna icon
                ),
                labelText: "Nama", // Label untuk field nama
                border: const OutlineInputBorder()), // Border untuk field
          ),
          const SizedBox(height: 20), // Spasi antara field
          TextField(
            controller: controller.phoneC, // Controller untuk nomor HP
            autocorrect: false, // Nonaktifkan autocorrect
            keyboardType:
                TextInputType.phone, // Set tipe keyboard untuk nomor HP
            textInputAction: TextInputAction.next, // Set action selanjutnya
            decoration: InputDecoration(
                icon: Icon(
                  Icons.phone_android_outlined, // Icon untuk nomor HP
                  color: Colors.blue[600], // Warna icon
                ),
                labelText: "Nomor HP", // Label untuk field nomor HP
                border: const OutlineInputBorder()), // Border untuk field
          ),
          const SizedBox(height: 20), // Spasi antara field
          TextField(
            controller: controller.emailC, // Controller untuk email
            autocorrect: false, // Nonaktifkan autocorrect
            keyboardType:
                TextInputType.emailAddress, // Set tipe keyboard untuk email
            textInputAction: TextInputAction.next, // Set action selanjutnya
            decoration: InputDecoration(
                icon: Icon(
                  Icons.email_outlined, // Icon untuk email
                  color: Colors.blue[600], // Warna icon
                ),
                labelText: "Email", // Label untuk field email
                border: const OutlineInputBorder()), // Border untuk field
          ),
          const SizedBox(height: 20), // Spasi antara field
          Obx(
            () {
              return TextField(
                controller: controller.passC, // Controller untuk password
                obscureText: controller.isHidden.value, // Hide/show password
                autocorrect: false, // Nonaktifkan autocorrect
                textInputAction: TextInputAction.next, // Set action selanjutnya
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.key_off_outlined, // Icon untuk password
                      color: Colors.blue[600], // Warna icon
                    ),
                    labelText: "Kata Sandi", // Label untuk field password
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.isHidden
                              .toggle(); // Toggle hide/show password
                        },
                        icon: Icon(
                          controller.isHidden.isTrue
                              ? Icons
                                  .remove_red_eye_outlined // Icon mata untuk hide
                              : Icons
                                  .remove_red_eye_rounded, // Icon mata untuk show
                          color: Colors.blue[600], // Warna icon
                        )),
                    border: const OutlineInputBorder()), // Border untuk field
              );
            },
          ),
          const SizedBox(height: 50), // Spasi sebelum tombol
          Obx(
            () {
              return ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller
                        .register(); // Panggil fungsi register dari controller
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600]), // Gaya tombol
                child: Text(
                  controller.isLoading.isFalse
                      ? "BUAT AKUN"
                      : "LAGI PROSES..", // Teks tombol
                  style: const TextStyle(color: Colors.white), // Gaya teks
                ),
              );
            },
          ),
          TextButton(
              onPressed: () {
                Get.toNamed(Routes.LOGIN); // Navigasi ke halaman login
              },
              child: Text(
                "Sudah Punya Akun?", // Teks untuk mengalihkan ke login
                style: TextStyle(
                  color: Colors.blue[600], // Warna teks
                  fontWeight: FontWeight.bold, // Gaya teks tebal
                ),
              )),
        ],
      ),
    );
  }
}
