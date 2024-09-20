import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNoteController extends GetxController {
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addNote() async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        String uid = auth.currentUser!.uid;

        await firestore.collection("users").doc(uid).collection("notes").add({
          "title": titleC.text,
          "description": descC.text,
          "createdAt": DateTime.now().toIso8601String(),
        });

        isLoading.value = false;

        Get.back();
      } catch (e) {
        print(e);
        isLoading.value = false;
        Get.snackbar("TERJADI KESALAHAN", "Tidak dapat menambahkan catatan");
      }
    } else {
      Get.snackbar("TERJADI KESALAHAN", "Data tidak boleh kosong.");
    }
  }
}
