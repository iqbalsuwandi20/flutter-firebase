import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth buat autentikasi
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core untuk inisialisasi Firebase
import 'package:flutter/material.dart'; // Import material design untuk UI
import 'package:flutter_firebase/firebase_options.dart'; // Import pengaturan Firebase
import 'package:get/get.dart'; // Import GetX untuk state management
import 'package:get_storage/get_storage.dart'; // Import GetStorage untuk penyimpanan lokal

import 'app/modules/splash/splash_screen.dart'; // Import tampilan splash screen
import 'app/routes/app_pages.dart'; // Import pengaturan rute aplikasi

void main() async {
  // Fungsi utama untuk menjalankan aplikasi
  WidgetsFlutterBinding
      .ensureInitialized(); // Pastikan widget binding siap sebelum inisialisasi

  await Firebase.initializeApp(
    // Inisialisasi Firebase dengan pengaturan yang sesuai
    options: DefaultFirebaseOptions
        .currentPlatform, // Pilih pengaturan sesuai platform
  );

  FirebaseAuth auth =
      FirebaseAuth.instance; // Buat instance FirebaseAuth untuk autentikasi

  await GetStorage.init(); // Inisialisasi GetStorage untuk penyimpanan lokal

  runApp(
    // Jalankan aplikasi Flutter
    StreamBuilder<User?>(
        // StreamBuilder untuk mendengarkan perubahan status autentikasi
        stream: auth
            .authStateChanges(), // Mendengarkan perubahan status autentikasi
        builder: (context, snap) {
          // Builder untuk membangun tampilan berdasarkan snapshot
          if (snap.connectionState == ConnectionState.waiting) {
            // Jika koneksi masih menunggu
            return const SplashScreen(); // Tampilkan splash screen
          }
          return GetMaterialApp(
            // Aplikasi utama dengan GetX
            title: "Application", // Judul aplikasi
            initialRoute: snap.data != null &&
                    snap.data!.emailVerified == true // Tentukan rute awal
                ? Routes
                    .HOME // Jika user sudah verifikasi email, arahkan ke HOME
                : AppPages.INITIAL, // Jika belum, arahkan ke rute awal
            debugShowCheckedModeBanner: false, // Hilangkan banner debug
            getPages: AppPages.routes, // Daftar rute aplikasi
          );
        }),
  );
}
