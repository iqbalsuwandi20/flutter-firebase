import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: const SizedBox(),
        backgroundColor: Colors.blue[600],
        actions: [
          IconButton(
            onPressed: () {
              controller.logout();
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: controller.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue[600],
              ),
            );
          }
          if (snapshot.data == null) {
            return Center(
              child: Text(
                "Tidak ada data anda",
                style: TextStyle(
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            controller.emailC.text = snapshot.data!["email"];
            controller.nameC.text = snapshot.data!["name"];
            controller.phoneC.text = snapshot.data!["phone"];
            return ListView(
              padding: const EdgeInsets.all(30),
              children: [
                TextField(
                  readOnly: true,
                  autocorrect: false,
                  controller: controller.emailC,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Email",
                    icon: Icon(Icons.email_outlined, color: Colors.blue[600]),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  autocorrect: false,
                  controller: controller.nameC,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Nama",
                    icon:
                        Icon(Icons.person_2_outlined, color: Colors.blue[600]),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  autocorrect: false,
                  controller: controller.phoneC,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Nomor HP",
                    icon: Icon(Icons.phone_android_outlined,
                        color: Colors.blue[600]),
                    border: const OutlineInputBorder(),
                  ),
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
                          labelText: "Kata Sandi Baru",
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
                const SizedBox(height: 20),
                Text(
                  "Akun anda dibuat:",
                  style: TextStyle(
                      color: Colors.blue[600], fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat.yMMMMEEEEd().add_jms().format(
                        DateTime.parse(
                          snapshot.data!["createdAt"],
                        ),
                      ),
                  style: TextStyle(
                    color: Colors.blue[600],
                  ),
                ),
                const SizedBox(height: 50),
                Obx(
                  () {
                    return ElevatedButton(
                      onPressed: () {
                        if (controller.isLoading.isFalse) {
                          controller.updateProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600]),
                      child: Text(
                        controller.isLoading.isFalse
                            ? "GANTI PROFIL"
                            : "LAGI PROSES..",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
