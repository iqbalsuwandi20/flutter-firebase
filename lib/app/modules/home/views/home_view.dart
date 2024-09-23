import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamNameProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    backgroundColor: Colors.grey[400],
                  );
                }
                Map<String, dynamic>? data = snapshot.data!.data();

                return GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.PROFILE);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[400],
                    backgroundImage: NetworkImage(data?["profilePicture"] !=
                            null
                        ? data!["profilePicture"]
                        : "https://ui-avatars.com/api/?name=${data!["name"]}"),
                  ),
                );
              }),
          const SizedBox(width: 20),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue[600],
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty || snapshot.data == null) {
              return const Center(
                child: Text(
                  "Belum ada data",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              padding: const EdgeInsets.all(5),
              itemBuilder: (context, index) {
                var docNote = snapshot.data!.docs[index];
                Map<String, dynamic> note = docNote.data();
                return ListTile(
                  onTap: () {
                    Get.toNamed(
                      Routes.EDIT_NOTE,
                      arguments: docNote.id,
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[600],
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    "${note["title"]}",
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${note["description"]}",
                    style: TextStyle(color: Colors.blue[600]),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        controller.deleteNote(docNote.id);
                      },
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        color: Colors.blue[600],
                      )),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_NOTE);
        },
        backgroundColor: Colors.blue[600],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
