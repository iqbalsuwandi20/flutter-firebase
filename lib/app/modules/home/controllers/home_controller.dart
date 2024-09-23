import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // FirebaseAuth buat handle autentikasi user
  FirebaseAuth auth = FirebaseAuth.instance;
  // FirebaseFirestore buat akses database Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Ini nih function streamNotes buat dapetin semua catatan user
  Stream<QuerySnapshot<Map<String, dynamic>>> streamNotes() async* {
    // Pertama ambil uid user yang lagi login sekarang
    String uid = auth.currentUser!.uid;

    // Abis itu akses koleksi 'notes' dari user tersebut, diurut berdasarkan 'createdAt'
    yield* firestore
        .collection("users") // Masuk ke koleksi 'users'
        .doc(uid) // Akses dokumen user berdasarkan uid
        .collection("notes") // Akses koleksi 'notes' di dalam dokumen user
        .orderBy("createdAt") // Urutkan berdasarkan waktu pembuatan catatan
        .snapshots(); // Dapetin stream data realtime dari Firestore
  }

  // Ini function buat stream data profile, kayak nama user misalnya
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamNameProfile() async* {
    // Ambil uid user yang lagi login sekarang
    String uid = auth.currentUser!.uid;

    // Ambil data profile user dari Firestore
    yield* firestore
        .collection("users") // Masuk ke koleksi 'users'
        .doc(uid) // Ambil dokumen user berdasarkan uid
        .snapshots(); // Stream data dokumen user secara realtime
  }

  // Ini function deleteNote buat hapus catatan spesifik
  void deleteNote(String docID) async {
    try {
      // Ambil uid user yang lagi login
      String uid = auth.currentUser!.uid;

      // Akses dokumen catatan berdasarkan docID dan hapus dari Firestore
      await firestore
          .collection("users") // Akses koleksi 'users'
          .doc(uid) // Ambil dokumen user berdasarkan uid
          .collection("notes") // Akses koleksi 'notes' di dalam dokumen user
          .doc(docID) // Pilih catatan spesifik berdasarkan docID
          .delete(); // Hapus catatannya dari Firestore
    } catch (e) {
      // Kalo ada error, kasih notifikasi ke user
      Get.snackbar("TERJADI KESALAHAN", "Tidak dapat menghapus catatan");
    }
  }
}
