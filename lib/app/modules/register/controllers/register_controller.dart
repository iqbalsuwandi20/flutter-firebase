import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore untuk database
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth untuk autentikasi
import 'package:flutter/material.dart'; // Import material design untuk UI
import 'package:get/get.dart'; // Import GetX untuk state management dan routing

import '../../../routes/app_pages.dart'; // Import route untuk navigasi

class RegisterController extends GetxController {
  // Controller untuk form registrasi
  TextEditingController nameC =
      TextEditingController(); // Controller untuk nama
  TextEditingController phoneC =
      TextEditingController(); // Controller untuk nomor HP
  TextEditingController emailC =
      TextEditingController(); // Controller untuk email
  TextEditingController passC =
      TextEditingController(); // Controller untuk password

  RxBool isLoading = false.obs; // Variabel untuk loading state
  RxBool isHidden = true.obs; // Variabel untuk hide/show password

  FirebaseAuth auth = FirebaseAuth.instance; // Instance Firebase Auth
  FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Instance Firestore

  void errorMessage(String msg) {
    // Fungsi untuk menampilkan pesan error
    Get.snackbar("Terjadi Kesalahan", msg); // Menampilkan snackbar dengan pesan
  }

  void register() async {
    // Fungsi untuk melakukan registrasi
    if (nameC.text.isNotEmpty && // Cek apakah semua field terisi
        phoneC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        passC.text.isNotEmpty) {
      isLoading.value = true; // Set loading menjadi true
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text, // Ambil email dari controller
          password: passC.text, // Ambil password dari controller
        );

        isLoading.value = false; // Set loading menjadi false

        await userCredential.user!
            .sendEmailVerification(); // Kirim verifikasi email

        // Simpan data user ke Firestore
        await firestore.collection("users").doc(userCredential.user!.uid).set({
          "name": nameC.text, // Simpan nama
          "phone": phoneC.text, // Simpan nomor HP
          "email": emailC.text, // Simpan email
          "uid": userCredential.user!.uid, // Simpan UID user
          "createdAt": DateTime.now().toIso8601String(), // Simpan waktu dibuat
        });

        Get.offAllNamed(Routes.LOGIN); // Navigasi ke halaman login
      } on FirebaseAuthException catch (e) {
        isLoading.value = false; // Set loading menjadi false jika ada error

        errorMessage(e.code); // Tampilkan pesan error sesuai kode
        // if (e.code == "weak-password") {
        //   print("password provided is too weak"); // Cek jika password lemah
        // } else if (e.code == "email-already-in-use") {
        //   print("The account already exists for that email"); // Cek jika email sudah terdaftar
        // }
      } catch (e) {
        isLoading.value =
            false; // Set loading menjadi false jika ada error lain
        errorMessage("$e"); // Tampilkan pesan error
      }
    } else {
      errorMessage(
          "Semua form harus di isi"); // Pesan jika ada field yang kosong
    }
  }
}
