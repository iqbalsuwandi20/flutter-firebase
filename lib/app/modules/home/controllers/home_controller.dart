import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamNotes() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore
        .collection("users")
        .doc(uid)
        .collection("notes")
        .orderBy("createdAt")
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamNameProfile() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("users").doc(uid).snapshots();
  }

  void deleteNote(String docID) async {
    try {
      String uid = auth.currentUser!.uid;

      await firestore
          .collection("users")
          .doc(uid)
          .collection("notes")
          .doc(docID)
          .delete();
    } catch (e) {
      Get.snackbar("TERJADI KESALAHAN", "Tidak dapat menghapus catatan");
    }
  }
}
