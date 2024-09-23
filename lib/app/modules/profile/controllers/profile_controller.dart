import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth
      .instance; // Ini FirebaseAuth buat autentikasi, jadi pake ini buat manage user login/out
  FirebaseFirestore firestore = FirebaseFirestore
      .instance; // Firestore ini buat simpen dan ambil data user dari cloud database
  s.FirebaseStorage storage = s.FirebaseStorage
      .instance; // FirebaseStorage ini buat handle file, kayak foto profil user

  TextEditingController emailC =
      TextEditingController(); // Controller buat input email di TextField
  TextEditingController nameC =
      TextEditingController(); // Controller buat input nama di TextField
  TextEditingController phoneC =
      TextEditingController(); // Controller buat input nomor telepon di TextField
  TextEditingController passC =
      TextEditingController(); // Controller buat input password di TextField

  RxBool isLoading = false
      .obs; // Ini observable buat nge-track loading state, true kalo lagi loading
  RxBool isHidden = true
      .obs; // Observable ini buat toggle hide/show password di form, awalnya disembunyiin
  RxBool profile = false
      .obs; // Observable buat nge-track status tampilan profile, jadi kalo profile ditampilin, ini jadi true

  XFile?
      image; // Variabel buat nyimpen file gambar, entar dipake buat foto profil

  // Fungsi buat logout user, kalo berhasil, user langsung dibawa ke halaman login
  void logout() async {
    try {
      await auth.signOut(); // Ini buat log out dari Firebase Auth
      Get.offAllNamed(
          Routes.LOGIN); // Abis logout, navigasi balik ke halaman login
    } catch (e) {
      print(e); // Print error ke console biar gampang debugging
      Get.snackbar("Terjadi Kesalahan",
          "Tidak dapat keluar akun"); // Snackbar buat nunjukin error kalo gagal logout
    }
  }

  // Fungsi ini buat dapetin data profile user dari Firestore, hasilnya dalam bentuk map
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      String uid =
          auth.currentUser!.uid; // Ambil UID user yang lagi login sekarang
      DocumentSnapshot<Map<String, dynamic>> docUser = await firestore
          .collection("users")
          .doc(uid)
          .get(); // Ambil data user dari Firestore berdasarkan UID

      profile.value = true; // Set profile value jadi true biar profile keliatan

      return docUser.data(); // Return data profile user
    } catch (e) {
      Get.snackbar("TERJADI KESALAHAN",
          "Tidak dapat menampilkan data anda"); // Snackbar buat nunjukin kalo ada error
    }
    return null; // Kalo ada error, return null
  }

  // Fungsi buat update profile user, termasuk nama, nomor telepon, password, dan foto profil
  void updateProfile() async {
    if (emailC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        phoneC.text.isNotEmpty) {
      try {
        isLoading.value =
            true; // Set loading state jadi true biar user tau lagi proses update
        String uid = auth.currentUser!.uid; // Ambil UID user
        await firestore.collection("users").doc(uid).update({
          "name": nameC.text, // Update nama user di Firestore
          "phone": phoneC.text, // Update nomor telepon user di Firestore
        });

        if (image != null) {
          // Cek kalo ada gambar yang diupload
          String ext =
              image!.name.split(".").last; // Ambil ekstensi file gambar
          await storage
              .ref(uid)
              .child("profile.$ext")
              .putFile(File(image!.path)); // Upload gambar ke Firebase Storage

          String profileLink = await storage
              .ref(uid)
              .child("profile.$ext")
              .getDownloadURL(); // Dapetin URL gambar yang udah di-upload

          await firestore.collection("users").doc(uid).update({
            "profilePicture": profileLink
          }); // Update link gambar profil di Firestore
        }

        if (passC.text.isNotEmpty) {
          // Kalo password baru diisi, update juga password-nya
          await auth.currentUser!.updatePassword(
              passC.text); // Update password user di Firebase Auth
          await auth
              .signOut(); // Abis ganti password, otomatis logout biar user login ulang

          isLoading.value = false; // Loading selesai

          Get.offAllNamed(
              Routes.LOGIN); // Kembali ke halaman login setelah logout
        } else {
          isLoading.value = false; // Loading selesai kalo password kosong
        }

        // Snackbar buat kasih tau kalo update berhasil, ini di-comment karena udah cukup user tau dari UI loading
        // Get.snackbar("BERHASIL", "Berhasil mengganti data anda");
      } catch (e) {
        isLoading.value = false; // Set loading false kalo ada error
        Get.snackbar("TERJADI KESALAHAN",
            "Tidak dapat ganti data"); // Snackbar buat nunjukin kalo ada error
      }
    } else {
      Get.snackbar("TERJADI KESALAHAN",
          "Data yang ingin dirubah tidak boleh kosong"); // Snackbar buat nunjukin kalo input kosong
    }
  }

  // Fungsi buat milih gambar dari galeri pake ImagePicker
  void pickImage() async {
    final ImagePicker picker = ImagePicker(); // Instance dari ImagePicker
    image = await picker.pickImage(
        source: ImageSource.gallery); // Buka galeri dan pilih gambar

    if (image != null) {
      update(); // Kalo ada gambar yang dipilih, panggil update() buat refresh UI
    } else {
      Get.snackbar("TERJADI KESALAHAN",
          "Anda harus memilih gambar"); // Snackbar kalo user gak pilih gambar
    }
  }

  // Fungsi buat reset atau hapus gambar yang dipilih
  void resetImage() async {
    image = null; // Set gambar jadi null
    update(); // Refresh UI
  }

  // Fungsi buat hapus gambar profil user dari Firestore
  void clearProfile() async {
    try {
      String uid = auth.currentUser!.uid; // Ambil UID user

      await firestore.collection("users").doc(uid).update({
        "profilePicture":
            FieldValue.delete(), // Hapus field "profilePicture" dari Firestore
      });

      Get.back(); // Kembali ke halaman sebelumnya

      profile.value =
          false; // Set profile value jadi false biar tampilan update

      update(); // Refresh UI
    } catch (e) {
      Get.snackbar("TERJADI KESALAHAN",
          "Tidak dapat menghapus gambar profil"); // Snackbar kalo ada error pas hapus gambar
    }
  }
}
