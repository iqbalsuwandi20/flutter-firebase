import 'package:flutter/material.dart'; // Import material design untuk bikin UI

class SplashScreen extends StatelessWidget {
  // Kelas SplashScreen untuk tampilan awal
  const SplashScreen({super.key}); // Constructor untuk SplashScreen

  @override
  Widget build(BuildContext context) {
    // Fungsi build untuk membangun tampilan
    return MaterialApp(
      // MaterialApp sebagai root widget
      home: Scaffold(
        // Scaffold untuk struktur dasar tampilan
        body: Center(
          // Center untuk memusatkan widget di layar
          child: CircularProgressIndicator(
            // Indikator loading melingkar
            backgroundColor: Colors.blue[600], // Warna background indikator
          ),
        ),
      ),
    );
  }
}
