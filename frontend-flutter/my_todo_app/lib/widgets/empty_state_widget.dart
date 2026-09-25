import 'package:flutter/material.dart';
import 'primary_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onActionPressed;
  final String actionText;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onActionPressed,
    required this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center( 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.deepPurpleAccent),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          
          // Width limit karke reusable button use kiya hai
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: PrimaryButton(
              text: actionText,
              icon: Icons.add,
              onPressed: onActionPressed,
            ),
          )
        ],
      ),
    );
  }
}
