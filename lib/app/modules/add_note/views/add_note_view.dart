import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_note_controller.dart';

class AddNoteView extends GetView<AddNoteController> {
  const AddNoteView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Note',
          style: TextStyle(color: Colors.white),
        ),
        leading: const SizedBox(),
        backgroundColor: Colors.blue[600],
      ),
      body: ListView(
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
                    controller.addNote();
                  }
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                child: Text(
                  controller.isLoading.isFalse
                      ? "TAMBAH CATATAN"
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
