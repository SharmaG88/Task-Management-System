import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center( 
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(24.0), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20), 
              
              const Text('Welcome Back!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              const Text('Please enter your details to login', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 40), 

              // Reusable Widgets
              const CustomTextField(labelText: 'Username or Email', prefixIcon: Icons.person_outline),
              const SizedBox(height: 20), 
              const CustomTextField(labelText: 'Password', prefixIcon: Icons.lock_open, obscureText: true),
              const SizedBox(height: 30), 
              
              PrimaryButton(
                text: 'Login',
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Homescreen()),
                ),
              ),
              
              const SizedBox(height: 25), 
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)), 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("OR", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(child: Divider(thickness: 1)), 
                ],
              ),
              const SizedBox(height: 25), 

              SocialLoginButton(
                text: 'Login with Google',
                icon: Icons.g_mobiledata,
                iconColor: Colors.red,
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Homescreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
