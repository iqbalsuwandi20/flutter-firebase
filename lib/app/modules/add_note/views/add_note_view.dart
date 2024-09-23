import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/add_note_controller.dart';

class AddNoteView extends GetView<AddNoteController> {
  const AddNoteView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Ini buat bikin AppBar dengan judul Add Note
        title: const Text(
          'Add Note', // Judul AppBar, bro
          style: TextStyle(color: Colors.white), // Style biar teksnya putih
        ),
        // Ini biar tombol back dihilangin aja
        leading: const SizedBox(),
        backgroundColor: Colors.blue[600], // Warna backgroundnya biru gitu
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(20), // Padding biar ada jarak di sekitar form
        children: [
          // TextField buat input judul catatan, ya kan
          TextField(
            controller: controller.titleC, // Controller buat handle input judul
            textInputAction:
                TextInputAction.next, // Aksi lanjut ke field berikutnya
            decoration: InputDecoration(
                labelText: "Judul", // Label biar user tau ini buat judul
                icon: Icon(
                  Icons.title_outlined, // Icon buat ngasih visual yang nyambung
                  color: Colors.blue[600], // Warnanya disamain biru gitu
                ),
                border:
                    const OutlineInputBorder()), // Biar ada border di text fieldnya
          ),
          const SizedBox(
              height: 20), // Jarak antara text field judul sama deskripsi

          // TextField buat input deskripsi catatan
          TextField(
            controller:
                controller.descC, // Controller buat handle input deskripsi
            textInputAction:
                TextInputAction.done, // Aksi selesai ngetik di field ini
            decoration: InputDecoration(
                labelText: "Deskripsi", // Label buat deskripsi
                icon: Icon(
                  Icons.description_outlined, // Icon deskripsi biar pas aja
                  color: Colors.blue[600], // Sama, warnanya biru
                ),
                border: const OutlineInputBorder()), // Ada border juga di sini
          ),
          const SizedBox(
              height: 50), // Jarak lebih gede sebelum button di bawah

          // Obx buat handle perubahan UI secara real-time, cuy
          Obx(
            () {
              // ElevatedButton buat tombol tambah catatan
              return ElevatedButton(
                onPressed: () {
                  // Cek dulu kalo lagi ga loading baru bisa klik
                  if (controller.isLoading.isFalse) {
                    controller
                        .addNote(); // Kalo ga loading, langsung panggil fungsi addNote
                  }
                },
                // Styling tombol, biar warnanya biru kayak AppBar
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                // Teks di tombol bakal berubah sesuai status loading
                child: Text(
                  controller.isLoading.isFalse
                      ? "TAMBAH CATATAN" // Kalo ga loading, teksnya Tambah Catatan
                      : "LAGI PROSES..", // Kalo lagi loading, teksnya Lagi Proses
                  style: const TextStyle(
                      color: Colors.white), // Teks putih biar jelas
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
