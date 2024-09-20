import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNoteController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getNoteByID(String docID) async {
    try {
      String uid = auth.currentUser!.uid;

      DocumentSnapshot<Map<String, dynamic>> doc = await firestore
          .collection("users")
          .doc(uid)
          .collection("notes")
          .doc(docID)
          .get();

      return doc.data();
    } catch (e) {
      return null;
    }
  }

  void editNote(String docID) async {
    if (titleC.text.isNotEmpty && descC.text.isNotEmpty) {
      isLoading.value = true;

      try {
        String uid = auth.currentUser!.uid;

        await firestore
            .collection("users")
            .doc(uid)
            .collection("notes")
            .doc(docID)
            .update({
          "title": titleC.text,
          "description": descC.text,
        });

        isLoading.value = false;

        Get.back();
      } catch (e) {
        print(e);

        Get.snackbar("TERJADI KESALAHAN", "Mohon cek kembali data anda");
      }
    } else {
      Get.snackbar("TERJADI KESALAHAN", "Data tidak boleh kosong");
    }
  }
}
