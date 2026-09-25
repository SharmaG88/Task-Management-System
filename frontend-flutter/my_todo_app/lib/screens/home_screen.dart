import 'package:flutter/material.dart';

// StatelessWidget tab use karte hain jab screen par koi cheez change nahi ho rahi (static UI)
// Yaad rakhein: Class name ke baad () brackets nahi aate hain jab hum extends karte hain.
class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  // build method is screen ka pura design (UI) return karega
  @override
  Widget build(BuildContext context) {
    // Scaffold ek white canvas (base) ki tarah hota hai jo humein basic structure (AppBar, Body) deta hai.
    return const Scaffold(
      body: Center(
        child: Text('Home Screen (Abhi hum yahan UI banayenge)'),
      ),
    );
  }
}
