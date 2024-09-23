import 'package:flutter/material.dart'; // Import material design untuk UI
import 'package:get/get.dart'; // Import GetX untuk state management dan routing

import '../controllers/reset_password_controller.dart'; // Import controller untuk reset password

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key}); // Constructor untuk ResetPasswordView
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold untuk struktur dasar tampilan
      appBar: AppBar(
        // AppBar sebagai header
        title: const Text(
          // Judul AppBar
          'Reset Password',
          style: TextStyle(color: Colors.white), // Gaya teks putih
        ),
        leading: const SizedBox(), // Hapus ikon back
        backgroundColor: Colors.blue[600], // Warna background AppBar
      ),
      body: ListView(
        // ListView untuk scrollable content
        padding: const EdgeInsets.all(20), // Padding untuk konten
        children: [
          TextField(
            // Input untuk email
            controller: controller.emailC, // Controller untuk mengakses input
            autocorrect: false, // Nonaktifkan autocorrect
            textInputAction: TextInputAction.next, // Action saat tekan next
            decoration: InputDecoration(
              // Gaya input
              icon: Icon(Icons.email_outlined,
                  color: Colors.blue[600]), // Ikon email
              labelText: "Email", // Label untuk input
              border: const OutlineInputBorder(), // Border input
            ),
          ),
          const SizedBox(height: 50), // Spasi antara input dan button
          Obx(
            // Reaktif widget dari GetX
            () {
              return ElevatedButton(
                // Tombol untuk reset password
                onPressed: () {
                  // Fungsi saat tombol ditekan
                  if (controller.isLoading.isFalse) {
                    // Cek status loading
                    controller.reset(); // Panggil fungsi reset dari controller
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600]), // Gaya tombol
                child: Text(
                  // Teks pada tombol
                  controller.isLoading.isFalse // Cek loading untuk teks
                      ? "RESET KATA SANDI" // Teks jika tidak loading
                      : "LAGI PROSES..", // Teks jika loading
                  style:
                      const TextStyle(color: Colors.white), // Gaya teks putih
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
