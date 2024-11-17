// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

class LogoButton extends StatelessWidget {
  final Function() onPressed;
  final String logoIcon;
  const LogoButton({
    super.key,
    required this.onPressed,
    required this.logoIcon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        backgroundColor: Colors.transparent,
        side: const BorderSide(
          color: Colors.white,
          width: 2.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Iconify(
        size: 28,
        logoIcon,
      ),
    );
  }
}
