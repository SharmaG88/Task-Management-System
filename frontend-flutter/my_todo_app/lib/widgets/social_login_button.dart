import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 30, color: iconColor),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
