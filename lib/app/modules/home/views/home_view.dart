import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Warna AppBar ini biru banget nih, biar keliatan fresh
        backgroundColor: Colors.blue[600],
        title: const Text(
          'Home',
          style: TextStyle(
              color: Colors.white), // Teksnya putih biar kontras ama background
        ),
        actions: [
          // StreamBuilder buat nampilin profile picture user secara realtime
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller
                  .streamNameProfile(), // Mantau data profile user dari Firestore
              builder: (context, snapshot) {
                // Kalau koneksi lagi nunggu, tampilkan avatar bulat warna abu-abu gitu
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    backgroundColor:
                        Colors.grey[400], // Warna default abu-abu buat loading
                  );
                }

                // Ambil data user dari snapshot
                Map<String, dynamic>? data = snapshot.data!.data();

                // GestureDetector biar bisa klik buat menuju halaman profile
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes
                        .PROFILE); // Kalo diklik, langsung ke halaman profile
                  },
                  child: CircleAvatar(
                    backgroundColor:
                        Colors.grey[400], // Background warna abu-abu
                    backgroundImage: NetworkImage(
                        // Cek apakah user punya profile picture atau enggak
                        data?["profilePicture"] != null
                            ? data![
                                "profilePicture"] // Kalau ada, tampilkan profile picture
                            : "https://ui-avatars.com/api/?name=${data!["name"]}"), // Kalo gak ada, generate avatar dari nama user
                  ),
                );
              }),
          const SizedBox(width: 20), // Jarak antara avatar dan tepi layar
        ],
      ),

      // StreamBuilder buat nampilin semua notes user secara realtime
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamNotes(), // Stream data notes dari Firestore
          builder: (context, snapshot) {
            // Kalo koneksi lagi nunggu, tampilin loading spinner biru biar aesthetic
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors
                      .blue[600], // Spinner warna biru biar matching ama tema
                ),
              );
            }

            // Kalo belum ada data catatan, tampilkan teks "Belum ada data"
            if (snapshot.data!.docs.isEmpty || snapshot.data == null) {
              return const Center(
                child: Text(
                  "Belum ada data", // Pesan buat user kalo belum ada catatan yang tersimpan
                  style: TextStyle(
                      fontWeight:
                          FontWeight.bold), // Bold biar lebih jelas kelihatan
                ),
              );
            }

            // ListView.builder buat nampilin list semua catatan user
            return ListView.builder(
              itemCount: snapshot.data!.docs
                  .length, // Jumlah item sesuai banyaknya data dari Firestore
              padding: const EdgeInsets.all(
                  5), // Padding biar itemnya gak mepet ke tepi layar
              itemBuilder: (context, index) {
                var docNote = snapshot
                    .data!.docs[index]; // Dapetin masing-masing dokumen catatan
                Map<String, dynamic> note =
                    docNote.data(); // Ambil data dari dokumen

                // Tampilin ListTile buat masing-masing catatan
                return ListTile(
                  // Kalo diklik, langsung menuju halaman edit catatan
                  onTap: () {
                    Get.toNamed(
                      Routes.EDIT_NOTE, // Navigasi ke halaman Edit Note
                      arguments:
                          docNote.id, // Kirim ID catatan ke halaman Edit Note
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor:
                        Colors.blue[600], // Avatar bulat dengan background biru
                    child: Text(
                      "${index + 1}", // Teks di dalam avatar, urutan catatan
                      style: const TextStyle(
                          color: Colors.white), // Teks putih biar kontras
                    ),
                  ),
                  title: Text(
                    "${note["title"]}", // Tampilkan judul catatan
                    style: TextStyle(
                      color:
                          Colors.blue[600], // Warna biru biar matching ama tema
                      fontWeight:
                          FontWeight.bold, // Bold biar judulnya lebih mencolok
                    ),
                  ),
                  subtitle: Text(
                    "${note["description"]}", // Tampilkan deskripsi catatan
                    style: TextStyle(
                        color:
                            Colors.blue[600]), // Warna biru juga biar seragam
                  ),
                  trailing: IconButton(
                      // Tombol hapus catatan
                      onPressed: () {
                        controller.deleteNote(docNote
                            .id); // Panggil function deleteNote buat hapus catatan
                      },
                      icon: Icon(
                        Icons.delete_forever_outlined, // Icon tong sampah
                        color: Colors.blue[600], // Warna icon biru biar senada
                      )),
                );
              },
            );
          }),

      // FloatingActionButton buat nambah catatan baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(
              Routes.ADD_NOTE); // Navigasi ke halaman Add Note kalo diklik
        },
        backgroundColor:
            Colors.blue[600], // Warna button biru matching ama tema
        child: const Icon(
          Icons.add, // Icon tambah (+)
          color: Colors.white, // Icon warna putih biar kontras
        ),
      ),
    );
  }
}
