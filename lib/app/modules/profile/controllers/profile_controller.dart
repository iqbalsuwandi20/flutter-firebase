import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  TextEditingController emailC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController passC = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  XFile? image;

  void logout() async {
    try {
      await auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print(e);
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat keluar akun");
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> docUser =
          await firestore.collection("users").doc(uid).get();

      return docUser.data();
    } catch (e) {
      Get.snackbar("TERJADI KESALAHAN", "Tidak dapat menampilkan data anda");
    }
    return null;
  }

  void updateProfile() async {
    if (emailC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        phoneC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        String uid = auth.currentUser!.uid;
        await firestore.collection("users").doc(uid).update({
          "name": nameC.text,
          "phone": phoneC.text,
        });

        if (image != null) {
          String ext = image!.name.split(".").last;
          await storage
              .ref(uid)
              .child("profile.$ext")
              .putFile(File(image!.path));

          String profileLink =
              await storage.ref(uid).child("profile.$ext").getDownloadURL();

          await firestore
              .collection("users")
              .doc(uid)
              .update({"profilePicture": profileLink});
        }

        if (passC.text.isNotEmpty) {
          await auth.currentUser!.updatePassword(passC.text);
          await auth.signOut();

          isLoading.value = false;

          Get.offAllNamed(Routes.LOGIN);
        } else {
          isLoading.value = false;
        }

        // Get.snackbar("BERHASIL", "Berhasil mengganti data anda");
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("TERJADI KESALAHAN", "Tidak dapat ganti data");
      }
    } else {
      Get.snackbar(
          "TERJADI KESALAHAN", "Data yang ingin dirubah tidak boleh kosong");
    }
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      update();
    } else {
      Get.snackbar("TERJADI KESALAHAN", "Anda harus memilih gambar");
    }
  }

  void resetImage() async {
    image = null;

    update();
  }
}
