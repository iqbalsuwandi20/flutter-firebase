import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNoteController extends GetxController {
  // Buat nge-track loading state, biar user tau kalo lagi proses gitu, ya kan
  RxBool isLoading = false.obs;

  // Controller buat handle input judul sama deskripsi yang mau diedit
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  // Instance buat autentikasi user Firebase
  FirebaseAuth auth = FirebaseAuth.instance;
  // Ini buat akses database Firestore, bro
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Function buat ambil note berdasarkan docID dari Firestore
  Future<Map<String, dynamic>?> getNoteByID(String docID) async {
    try {
      // Ambil UID user yang lagi login, penting nih buat ngefilter data usernya
      String uid = auth.currentUser!.uid;

      // Ambil dokumen catatan yang sesuai sama docID yang dikasih
      DocumentSnapshot<Map<String, dynamic>> doc = await firestore
          .collection("users")
          .doc(uid)
          .collection("notes")
          .doc(docID)
          .get();

      // Kalo dapet datanya, balikin deh datanya
      return doc.data();
    } catch (e) {
      // Kalo ada error, balikin null aja biar aman, ga usah ribet-ribet
      return null;
    }
  }

  // Function buat edit note berdasarkan docID, bro
  void editNote(String docID) async {
    // Cek dulu nih, field judul sama deskripsinya jangan sampe kosong
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      // Set loading jadi true biar user tau kalo lagi ada proses edit
      isLoading.value = true;

      try {
        // Ambil UID user yang lagi login buat referensi dokumen catatan yang mau diedit
        String uid = auth.currentUser!.uid;

        // Update catatan yang sesuai sama docID pake data baru dari user
        await firestore
            .collection("users")
            .doc(uid)
            .collection("notes")
            .doc(docID)
            .update({
          "title": titleC.text, // Update judul catatan
          "description": descC.text, // Update deskripsi catatan
        });

        // Setelah berhasil update, set loading jadi false lagi
        isLoading.value = false;

        // Balikin user ke halaman sebelumnya setelah update berhasil
        Get.back();
      } catch (e) {
        // Kalo ada error, tampilkan pesan biar user tau ada yang salah
        Get.snackbar("TERJADI KESALAHAN", "Mohon cek kembali data anda");
      }
    } else {
      // Kalo ada field yang kosong, kasih warning ke user
      Get.snackbar("TERJADI KESALAHAN", "Data tidak boleh kosong");
    }
  }
}
