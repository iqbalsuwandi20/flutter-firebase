import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void register() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
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

        Get.offAllNamed(Routes.LOGIN);
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        print(e.code);
        // if (e.code == "weak-password") {
        //   print("password provided is too weak");
        // } else if (e.code == "email-already-in-use") {
        //   print("The account already exists for that email");
        // }
      } catch (e) {
        isLoading.value = false;
        print(e);
      }
    }
  }
}
