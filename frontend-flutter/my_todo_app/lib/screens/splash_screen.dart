import 'package:flutter/material.dart';
// import 'login_screen.dart'; // Jab login screen banayenge tab ise on karenge
import 'home_screen.dart'; // Abhi ke liye 2 seconds baad seedha Home Screen par bhej rahe hain

// StatefulWidget tab use karte hain jab page par kuch "Change" hone wala ho (jaise time ke baad navigate hona)
// Note: Class ke aage () nahi lagate hain
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});   

  @override
  // Yeh is page ki "State" (halat/data) banata hai
  State<Splashscreen> createState() => _SplashscreenState();
}

// Yeh class upar wali Splashscreen ka actual logic aur UI handle karti hai
class _SplashscreenState extends State<Splashscreen> {
  
  // initState ek special function hai jo tab chalta hai jab yeh screen pehli baar load hoti hai
  @override
  void initState() {
    super.initState(); // Original initState ko call karna zaroori hai
    
    // Future.delayed ek Timer ki tarah kaam karta hai. Yahan hum 2 seconds wait kar rahe hain.
    Future.delayed(const Duration(seconds: 2), () {
      
      // 2 seconds ke baad hum Navigator (Navigation system) ko bol rahe hain naye page par jao.
      // pushReplacement isliye use kiya taaki user phone ka 'Back' button dabakar wapas Splash par na aa sake.
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const Homescreen()) 
      );
    });
  }

  // build method ke andar hum apni screen ka UI (design) banate hain
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple, // Screen ka background color
      body: Center(
        // Center widget apne andar ki cheezon ko bilkul screen ke beech (middle) mein laata hai
        child: Text(
          'Todo App', // Abhi ke liye simple text dikha rahe hain
          style: TextStyle(
            fontSize: 32, 
            fontWeight: FontWeight.bold, 
            color: Colors.white // Text ka rang safed
          ),
        ),
      ),
    );
  }
}
