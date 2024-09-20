import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_note_controller.dart';

class EditNoteView extends GetView<EditNoteController> {
  const EditNoteView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Note',
          style: TextStyle(color: Colors.white),
        ),
        leading: const SizedBox(),
        backgroundColor: Colors.blue[600],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
          future: controller.getNoteByID(
            Get.arguments.toString(),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue[600],
                ),
              );
            }

            if (snapshot.data == null) {
              return const Center(
                  child: Text(
                "Tidak dapat mengambil catatan anda",
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
            } else {
              controller.titleC.text = snapshot.data!["title"];
              controller.descC.text = snapshot.data!["description"];
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  TextField(
                    controller: controller.titleC,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        labelText: "Judul",
                        icon: Icon(
                          Icons.title_outlined,
                          color: Colors.blue[600],
                        ),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller.descC,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        labelText: "Deskripsi",
                        icon: Icon(
                          Icons.description_outlined,
                          color: Colors.blue[600],
                        ),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 50),
                  Obx(
                    () {
                      return ElevatedButton(
                        onPressed: () {
                          if (controller.isLoading.isFalse) {
                            controller.editNote(
                              Get.arguments.toString(),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[600]),
                        child: Text(
                          controller.isLoading.isFalse
                              ? "MENGUBAH CATATAN"
                              : "LAGI PROSES..",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          }),
    );
  }
}
