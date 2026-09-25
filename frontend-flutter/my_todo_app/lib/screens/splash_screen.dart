import 'package:flutter/material.dart';
import 'login_screen.dart'; // Ab Splash Screen se hum Login Screen par jayenge

// StatefulWidget tab use karte hain jab page par kuch "Change" hone wala ho
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});   

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  
  @override
  void initState() {
    super.initState();
    
    // 2 seconds wait karega
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context, 
        // Yahan par class ka naam 'LoginScreen' (Capital L) hona chahiye, dart mein classes ka naam UpperCamelCase hota hai.
        MaterialPageRoute(builder: (context) => const LoginScreen()) 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Text(
          'Todo App',
          style: TextStyle(
            fontSize: 32, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
