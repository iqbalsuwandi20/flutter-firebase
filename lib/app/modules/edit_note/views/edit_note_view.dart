import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_note_controller.dart';

class EditNoteView extends GetView<EditNoteController> {
  const EditNoteView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Ini buat nampilin AppBar dengan judul "Edit Note"
        title: const Text(
          'Edit Note', // Judul AppBar, biar user tau lagi edit catatan
          style: TextStyle(
              color: Colors
                  .white), // Style teks putih biar kontras sama background
        ),
        leading:
            const SizedBox(), // Ini buat ngilangin tombol back default di kiri
        backgroundColor:
            Colors.blue[600], // Warna AppBar biru muda gitu, biar adem
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
          // FutureBuilder buat handle data catatan yang diambil dari Firestore
          future: controller.getNoteByID(
            Get.arguments
                .toString(), // Ambil docID yang dilempar dari halaman sebelumnya
          ),
          builder: (context, snapshot) {
            // Cek dulu nih kalo status connection-nya masih loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue[
                      600], // Warna loading indicatornya biru juga biar matching
                ),
              );
            }

            // Kalo data yang didapet kosong atau null, kasih pesan error
            if (snapshot.data == null) {
              return const Center(
                  child: Text(
                "Tidak dapat mengambil catatan anda", // Pesan error kalo ga bisa ambil data
                style: TextStyle(
                    fontWeight: FontWeight.bold), // Style biar teksnya tebel
              ));
            } else {
              // Kalo datanya ada, isiin ke TextField buat diedit
              controller.titleC.text =
                  snapshot.data!["title"]; // Isi text judul
              controller.descC.text =
                  snapshot.data!["description"]; // Isi text deskripsi

              return ListView(
                padding: const EdgeInsets.all(
                    20), // Padding biar ada jarak antara tepi layar
                children: [
                  // TextField buat input judul catatan
                  TextField(
                    controller: controller
                        .titleC, // Controller yang udah diisi dengan data catatan
                    textInputAction: TextInputAction
                        .next, // Biar tombol enter lanjut ke field berikutnya
                    decoration: InputDecoration(
                        labelText: "Judul", // Label di atas text field
                        icon: Icon(
                          Icons.title_outlined, // Icon judul biar lebih visual
                          color: Colors.blue[
                              600], // Iconnya biru juga biar nyatu sama tema
                        ),
                        border:
                            const OutlineInputBorder()), // Biar ada border di sekitar field
                  ),
                  const SizedBox(
                      height:
                          20), // Jarak antara text field judul dan deskripsi

                  // TextField buat input deskripsi catatan
                  TextField(
                    controller: controller
                        .descC, // Controller buat deskripsi yang juga udah diisi
                    textInputAction: TextInputAction
                        .done, // Biar tombol enter submit data kalo udah selesai
                    decoration: InputDecoration(
                        labelText: "Deskripsi", // Label buat deskripsi
                        icon: Icon(
                          Icons
                              .description_outlined, // Icon deskripsi buat mempermudah user
                          color: Colors
                              .blue[600], // Iconnya sama biru biar enak dilihat
                        ),
                        border:
                            const OutlineInputBorder()), // Border di sekitar text field biar rapi
                  ),
                  const SizedBox(
                      height:
                          50), // Jarak yang lebih gede sebelum tombol submit

                  // Obx buat meng-handle perubahan loading state secara real-time
                  Obx(
                    () {
                      return ElevatedButton(
                        // Kalo lagi ga loading, tombolnya bisa di klik
                        onPressed: () {
                          if (controller.isLoading.isFalse) {
                            // Panggil fungsi editNote kalo tombol ditekan
                            controller.editNote(
                              Get.arguments
                                  .toString(), // Ambil docID buat di-update catatannya
                            );
                          }
                        },
                        // Styling tombol, warnanya biru biar konsisten sama AppBar dan lainnya
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue[600]), // Warna tombolnya biru muda
                        // Teks di tombol berubah kalo lagi loading
                        child: Text(
                          controller.isLoading.isFalse
                              ? "MENGUBAH CATATAN" // Kalo ga loading, tulisannya 'MENGUBAH CATATAN'
                              : "LAGI PROSES..", // Kalo lagi loading, tulisannya 'LAGI PROSES..'
                          style: const TextStyle(
                              color: Colors.white), // Teks putih biar kontras
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          }),
    );
  }
}
