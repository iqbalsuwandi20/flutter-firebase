import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        leading: const SizedBox(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          TextField(
            controller: controller.emailC,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.email_outlined,
                  color: Colors.blue[600],
                ),
                labelText: "Email",
                border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller.passC,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.key_off_outlined,
                  color: Colors.blue[600],
                ),
                labelText: "Kata Sandi",
                border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 50),
          Obx(
            () {
              return ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.register();
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                child: Text(
                  controller.isLoading.isFalse ? "BUAT AKUN" : "LAGI PROSES..",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          TextButton(
              onPressed: () {
                Get.toNamed(Routes.LOGIN);
              },
              child: Text(
                "Sudah Punya Akun?",
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }
}
