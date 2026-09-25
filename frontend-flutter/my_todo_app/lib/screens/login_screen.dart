import 'package:flutter/material.dart';
import 'home_screen.dart'; // Login dabane ke baad yahan jana hai

// StatelessWidget banaya hai kyunki abhi sirf UI dikhana hai (koi data load/change nahi ho raha)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Screen ka rang safed
      body: Center( // Sab kuch screen ke bilkul centre mein
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Charon taraf se 24 pixels ki space
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Items ko vertically center mein laane ke liye
            children: [
              
              // Ek Lock ka Icon
              const Icon(
                Icons.lock_outline, 
                size: 100, 
                color: Colors.deepPurple
              ),
              const SizedBox(height: 30), // Beech mein 30px ka gap (Khali jagah)
              
              // Welcome text
              const Text(
                'Welcome to Todo App',
                style: TextStyle(
                  fontSize: 26, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              
              // Subtitle text
              const Text(
                'Please login to manage your tasks.',
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.grey
                ),
              ),
              const SizedBox(height: 50), // Thoda bada gap login button se pehle
              
              // Google Login Button (Dummy)
              SizedBox(
                width: double.infinity, // Button ko screen ki full width (poori chaudai) tak lamba karne ke liye
                height: 55, // Button ki height
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Jab koi button dabayega, toh Navigator usko Home Screen par le jayega
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Homescreen()),
                    );
                  },
                  icon: const Icon(Icons.login), // Login ka chota sa icon
                  label: const Text(
                    'Login with Google', 
                    style: TextStyle(fontSize: 18)
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, // Button ka background color
                    foregroundColor: Colors.white, // Button ke text aur icon ka color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Button ke kinaron (corners) ko gol karne ke liye
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
