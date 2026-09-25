import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, 
      height: 55, 
      child: icon != null
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            style: _btnStyle(),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: _btnStyle(),
            child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
    );
  }

  ButtonStyle _btnStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple, 
      foregroundColor: Colors.white, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), 
      ),
    );
  }
}
