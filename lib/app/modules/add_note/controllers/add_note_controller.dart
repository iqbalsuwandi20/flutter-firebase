import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNoteController extends GetxController {
  // Ini controller buat handle input judul, nih
  TextEditingController titleC = TextEditingController();

  // Controller buat deskripsi catatan, bro
  TextEditingController descC = TextEditingController();

  // Buat ngecek status loading, biar user tau kalo lagi proses gitu
  RxBool isLoading = false.obs;

  // Instance buat akses autentikasi Firebase, loh
  FirebaseAuth auth = FirebaseAuth.instance;

  // Firestore ini buat simpen data catatan yang user masukin
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fungsi buat nambahin catatan ke Firestore, coy
  void addNote() async {
    // Cek dulu nih, judul sama deskripsinya ga boleh kosong gitu lho
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      // Kalo udah, set loading jadi true biar UI nunjukin kalo lagi loading
      isLoading.value = true;
      try {
        // Ambil UID dari user yang lagi login, kan penting tuh
        String uid = auth.currentUser!.uid;

        // Masukin deh catatannya ke Firestore, udah pasti di koleksi notes
        await firestore.collection("users").doc(uid).collection("notes").add({
          "title": titleC.text, // Ini judul catatan yang diinput
          "description": descC.text, // Deskripsi catatan, beb
          "createdAt": DateTime.now()
              .toIso8601String(), // Timestamp biar tau kapan dibikin
        });

        // Setelah berhasil, matiin loadingnya biar UI balik normal
        isLoading.value = false;

        // Balik ke halaman sebelumnya setelah catatan ditambah
        Get.back();
      } catch (e) {
        // Kalo ada error, langsung tampilkan biar user tau ada apa
        isLoading.value = false;
        Get.snackbar("TERJADI KESALAHAN", "Tidak dapat menambahkan catatan");
      }
    } else {
      // Kalo ada field yang kosong, kasih warning biar user aware gitu
      Get.snackbar("TERJADI KESALAHAN", "Data tidak boleh kosong.");
    }
  }
}
