import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    if (box.read("rememberMe") != null) {
      controller.emailC.text = box.read("rememberMe")["email"];
      controller.passC.text = box.read("rememberMe")["password"];
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: const Text(
          'Login',
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
          Obx(
            () {
              return TextField(
                controller: controller.passC,
                obscureText: controller.isHidden.value,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.key_off_outlined,
                      color: Colors.blue[600],
                    ),
                    labelText: "Kata Sandi",
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.isHidden.toggle();
                        },
                        icon: Icon(
                          controller.isHidden.isTrue
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye_rounded,
                          color: Colors.blue[600],
                        )),
                    border: const OutlineInputBorder()),
              );
            },
          ),
          Obx(
            () {
              return CheckboxListTile(
                value: controller.rememberMe.value,
                onChanged: (value) {
                  controller.rememberMe.toggle();
                },
                title: Text(
                  "Ingatkan Saya",
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.blue[600],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 150,
                child: TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.RESET_PASSWORD);
                    },
                    child: Text(
                      "Reset Kata Sandi?",
                      style: TextStyle(
                        color: Colors.blue[600],
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Obx(
            () {
              return ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.login();
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                child: Text(
                  controller.isLoading.isFalse ? "MASUK" : "LAGI PROSES..",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          TextButton(
              onPressed: () {
                Get.toNamed(Routes.REGISTER);
              },
              child: Text(
                "Buat Akun?",
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
