import 'package:flutter/material.dart';
import 'home_screen.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center( 
        child: SingleChildScrollView( // Agar screen choti ho toh scroll karne ki facility milti hai
          padding: const EdgeInsets.all(24.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              
              const Icon(
                Icons.lock_outline, 
                size: 80, 
                color: Colors.deepPurple
              ),
              const SizedBox(height: 20), 
              
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 26, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              
              const Text(
                'Please enter your details to login',
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.grey
                ),
              ),
              const SizedBox(height: 40), 

              // --- Username / Email Field ---
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Username or Email',
                  prefixIcon: const Icon(Icons.person_outline), 
                  border: OutlineInputBorder( 
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20), 

              // --- Password Field ---
              TextFormField(
                obscureText: true, 
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_open),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30), 
              
              // --- Submit (Login) Button ---
              SizedBox(
                width: double.infinity, 
                height: 55, 
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Homescreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple, 
                    foregroundColor: Colors.white, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), 
                    ),
                  ),
                  child: const Text(
                    'Login', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              
              const SizedBox(height: 25), // Beech mein gap
              
              // --- OR Divider ---
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)), // Line
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(child: Divider(thickness: 1)), // Line
                ],
              ),
              
              const SizedBox(height: 25), // Gap

              // --- Google Login Button ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon( // Outlined button banaya taaki ye main button se alag dikhe
                  onPressed: () {
                    // Google login dabane par bhi abhi Home Screen par bhejenge
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Homescreen()),
                    );
                  },
                  icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red), // Google ka G jaisa icon
                  label: const Text(
                    'Login with Google',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.grey), // Grey border
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
