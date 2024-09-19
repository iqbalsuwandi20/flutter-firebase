import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  RxBool rememberMe = false.obs;

  final box = GetStorage();

  void errorMessage(String msg) {
    Get.snackbar("Terjadi Kesalahan", msg);
  }

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        print(userCredential);

        isLoading.value = false;

        if (userCredential.user!.emailVerified == true) {
          if (box.read("rememberMe") != null) {
            await box.remove("rememberMe");
          }
          if (rememberMe.isTrue) {
            await box.write("rememberMe", {
              "email": emailC.text,
              "password": passC.text,
            });
          }

          Get.offAllNamed(Routes.HOME);
        } else {
          print("User belum terverifikasi dan tidak dapat login");
          Get.defaultDialog(
            title: "Belum terverifikasi",
            middleText: "Apakah kamu ingin mengirim email verifikasi lagi?",
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600]),
                  onPressed: () => Get.back,
                  child: const Text(
                    "TIDAK",
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600]),
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      print("Berhasil kirim link email ke inbox");
                      Get.back();
                      Get.snackbar("Berhasil", "Mohon cek inbox email");
                    } catch (e) {
                      print(e);
                      Get.back();
                      Get.snackbar("Terjadi Kesalahan",
                          "Terlalu banyak mengirim verifikasi");
                    }
                  },
                  child: const Text(
                    "KIRIM LAGI DONG",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          );

          Get.snackbar("Terjadi Kesalahan",
              "Mohon cek inbox email anda untuk verifikasi");
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;

        print(e.code);

        errorMessage(e.code);

        // if (e.code == "user-not-found") {
        //   print("Tidak ditemukan pengguna email tersebut");
        // } else if (e.code == "wrong-passowrd") {
        //   print("Kata sandi yang diberikan tersebut salah.");
        // }
      }
    } else {
      errorMessage("Email dan Kata Sandi harus di isi");
    }
  }
}
