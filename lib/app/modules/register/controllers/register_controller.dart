import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController phoneC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void errorMessage(String msg) {
    Get.snackbar("Terjadi Kesalahan", msg);
  }

  void register() async {
    if (nameC.text.isNotEmpty &&
        phoneC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );
        print(userCredential);

        isLoading.value = false;

        await userCredential.user!.sendEmailVerification();

        await firestore.collection("users").doc(userCredential.user!.uid).set({
          "name": nameC.text,
          "phone": phoneC.text,
          "email": emailC.text,
          "uid": userCredential.user!.uid,
          "createdAt": DateTime.now().toIso8601String(),
        });

        Get.offAllNamed(Routes.LOGIN);
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        print(e.code);

        errorMessage(e.code);
        // if (e.code == "weak-password") {
        //   print("password provided is too weak");
        // } else if (e.code == "email-already-in-use") {
        //   print("The account already exists for that email");
        // }
      } catch (e) {
        isLoading.value = false;
        print(e);
        errorMessage("$e");
      }
    } else {
      errorMessage("Semua form harus di isi");
    }
  }
}
