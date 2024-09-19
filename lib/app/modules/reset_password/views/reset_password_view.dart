import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        leading: const SizedBox(),
        backgroundColor: Colors.blue[600],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.emailC,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              icon: Icon(Icons.email_outlined, color: Colors.blue[600]),
              labelText: "Email",
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 50),
          Obx(
            () {
              return ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.reset();
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                child: Text(
                  controller.isLoading.isFalse
                      ? "RESET KATA SANDI"
                      : "LAGI PROSES..",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
