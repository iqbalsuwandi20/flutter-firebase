import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailC =
      TextEditingController(text: "iqbalsuwandi20@gmail.com");
  TextEditingController passC = TextEditingController(text: "iqbalganteng20");

  RxBool isLoading = false.obs;

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        print(userCredential);

        isLoading.value = false;

        Get.offAllNamed(Routes.HOME);
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;

        print(e.code);

        // if (e.code == "user-not-found") {
        //   print("Tidak ditemukan pengguna email tersebut");
        // } else if (e.code == "wrong-passowrd") {
        //   print("Kata sandi yang diberikan tersebut salah.");
        // }
      }
    }
  }
}
