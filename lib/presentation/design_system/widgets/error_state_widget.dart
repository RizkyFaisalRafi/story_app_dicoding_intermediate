import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;

  const ErrorStateWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.contains("Failed to connect to the network")) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/no_connection.json',
                width: 300,
                height: 300,
              ),
              const Text(
                'Tidak Ada Koneksi Internet!',
                // style: GoogleFonts.robotoCondensed(
                //   fontSize: 16,
                //   color: Colors.black,
                //   fontWeight: FontWeight.w400,
                // ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/error.json',
                width: 300,
                height: 300,
              ),
              const Text(
                'Terjadi Kesalahan Pada Server!',
                // style: GoogleFonts.robotoCondensed(
                //   fontSize: 16,
                //   color: Colors.black,
                //   fontWeight: FontWeight.w400,
                // ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
