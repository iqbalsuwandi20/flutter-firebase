import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView(
      {super.key}); // Constructor dari ProfileView, ambil key dari parent
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile', // Judul halaman profile
          style: TextStyle(color: Colors.white), // Warna teks judul
        ),
        leading: const SizedBox(), // Kosongin leading icon
        backgroundColor: Colors.blue[600], // Warna background AppBar
        actions: [
          IconButton(
            onPressed: () {
              controller.logout(); // Panggil fungsi logout dari controller
            },
            icon: const Icon(
              Icons.logout_outlined, // Icon logout
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: controller.getProfile(), // Ambil data profile dari controller
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue[600], // Spinner loading pas nunggu data
              ),
            );
          }
          if (snapshot.data == null) {
            return Center(
              child: Text(
                "Tidak ada data anda", // Pesan kalo data tidak ada
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold, // Teks bold
                ),
              ),
            );
          } else {
            // Kalo ada datanya, isi controller dengan data yang diambil
            controller.emailC.text = snapshot.data!["email"];
            controller.nameC.text = snapshot.data!["name"];
            controller.phoneC.text = snapshot.data!["phone"];
            return ListView(
              padding: const EdgeInsets.all(30), // Padding untuk ListView
              children: [
                // TextField untuk email
                TextField(
                  readOnly: true, // Email tidak bisa diedit
                  autocorrect: false, // Nonaktifkan autocorrect
                  controller: controller.emailC,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Email",
                    icon: Icon(Icons.email_outlined,
                        color: Colors.blue[600]), // Icon email
                    border: const OutlineInputBorder(), // Border outline
                  ),
                ),
                const SizedBox(height: 20),
                // TextField untuk nama
                TextField(
                  autocorrect: false, // Nonaktifkan autocorrect
                  controller: controller.nameC,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Nama", // Label untuk input nama
                    icon: Icon(Icons.person_2_outlined,
                        color: Colors.blue[600]), // Icon nama
                    border: const OutlineInputBorder(), // Border outline
                  ),
                ),
                const SizedBox(height: 20),
                // TextField untuk nomor HP
                TextField(
                  autocorrect: false, // Nonaktifkan autocorrect
                  controller: controller.phoneC,
                  keyboardType: TextInputType.phone, // Input hanya angka
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Nomor HP",
                    icon: Icon(Icons.phone_android_outlined,
                        color: Colors.blue[600]), // Icon HP
                    border: const OutlineInputBorder(), // Border outline
                  ),
                ),
                const SizedBox(height: 20),
                // TextField untuk kata sandi baru dengan toggle
                Obx(
                  () {
                    return TextField(
                      controller: controller.passC,
                      obscureText:
                          controller.isHidden.value, // Hide/show password
                      autocorrect: false, // Nonaktifkan autocorrect
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.key_off_outlined,
                            color: Colors.blue[600], // Icon kunci
                          ),
                          labelText: "Kata Sandi Baru", // Label untuk password
                          suffixIcon: IconButton(
                              onPressed: () {
                                controller.isHidden
                                    .toggle(); // Toggle hide/show password
                              },
                              icon: Icon(
                                controller.isHidden.isTrue
                                    ? Icons
                                        .remove_red_eye_outlined // Icon untuk lihat password
                                    : Icons
                                        .remove_red_eye_rounded, // Icon untuk sembunyikan password
                                color: Colors.blue[600],
                              )),
                          border: const OutlineInputBorder()), // Border outline
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Menampilkan tanggal akun dibuat
                Text(
                  "Akun anda dibuat:",
                  style: TextStyle(
                      color: Colors.blue[600], fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat.yMMMMEEEEd().add_jms().format(
                        DateTime.parse(
                          snapshot
                              .data!["createdAt"], // Ambil tanggal dari data
                        ),
                      ),
                  style: TextStyle(
                    color: Colors.blue[600],
                  ),
                ),
                const SizedBox(height: 20),
                // Menampilkan foto profil
                Text(
                  "Foto Profil:",
                  style: TextStyle(
                      color: Colors.blue[600], fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GetBuilder<ProfileController>(
                  builder: (c) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cek apakah ada gambar yang dipilih
                        controller.image != null
                            ? Column(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[600],
                                      image: DecorationImage(
                                        image: FileImage(
                                          File(
                                            controller.image!
                                                .path, // Tampilkan gambar dari galeri
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller
                                          .resetImage(); // Hapus gambar yang dipilih
                                    },
                                    child: Text(
                                      "Hapus Gambar", // Tombol untuk hapus gambar
                                      style: TextStyle(
                                        color: Colors.blue[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : snapshot.data?["profilePicture"] != null &&
                                    c.profile.isTrue
                                ? Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.grey[600],
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data![
                                                  "profilePicture"], // Tampilkan gambar dari URL
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Konfirmasi sebelum menghapus gambar profil
                                          Get.defaultDialog(
                                              title:
                                                  "HAPUS GAMBAR SECARA PERMANEN",
                                              middleText:
                                                  "Yakin untuk menghapus foto profil anda?",
                                              actions: [
                                                OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .blue[600]),
                                                    onPressed: () {
                                                      Get.back(); // Kembali ke dialog sebelumnya
                                                    },
                                                    child: const Text(
                                                      "KEMBALI",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .blue[600]),
                                                    onPressed: () {
                                                      controller
                                                          .clearProfile(); // Hapus gambar profil
                                                    },
                                                    child: const Text(
                                                      "YA",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                              ]);
                                        },
                                        child: Text(
                                          "Hapus Gambar Permanen", // Tombol untuk hapus gambar permanen
                                          style: TextStyle(
                                            color: Colors.blue[600],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    "Belum di pilih", // Pesan jika gambar belum dipilih
                                    style: TextStyle(color: Colors.black),
                                  ),
                        // Tombol untuk pilih gambar dari galeri
                        TextButton(
                            onPressed: () {
                              controller
                                  .pickImage(); // Panggil fungsi pickImage
                            },
                            child: Text(
                              "Pilih Gambar", // Teks tombol
                              style: TextStyle(
                                color: Colors.blue[600],
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 50),
                // Tombol untuk update profile
                Obx(
                  () {
                    return ElevatedButton(
                      onPressed: () {
                        if (controller.isLoading.isFalse) {
                          controller
                              .updateProfile(); // Panggil fungsi updateProfile
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600]), // Warna tombol
                      child: Text(
                        controller.isLoading.isFalse
                            ? "GANTI PROFIL" // Teks tombol saat tidak loading
                            : "LAGI PROSES..", // Teks tombol saat loading
                        style:
                            const TextStyle(color: Colors.white), // Warna teks
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
