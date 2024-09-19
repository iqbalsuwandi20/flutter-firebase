import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController emailC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();

  RxBool isLoading = false.obs;

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
    try {
      isLoading.value = true;
      String uid = auth.currentUser!.uid;
      await firestore.collection("users").doc(uid).update({
        "name": nameC.text,
        "phone": phoneC.text,
      });
      isLoading.value = false;

      Get.snackbar("BERHASIL", "Berhasil mengganti data anda");
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("TERJADI KESALAHAN", "Tidak dapat ganti data");
    }
  }
}
