import 'package:flutter/material.dart';

class DialogAnimate extends StatelessWidget {
  final String title;
  final String content;
  final int? secondsTime;

  const DialogAnimate({
    super.key,
    required this.title,
    required this.content,
    required this.secondsTime,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String content,
    int? secondsTime,
  }) {
    final int delayTime = secondsTime ?? 3; // Default ke 3 detik jika null
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween(begin: 0.5, end: 1.0).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: AlertDialog(
              title: Text(title),
              content: Text(content),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
    // Future.delayed untuk menutup dialog setelah 3 detik
    Future.delayed(Duration(seconds: delayTime), () {
      if (context.mounted) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
