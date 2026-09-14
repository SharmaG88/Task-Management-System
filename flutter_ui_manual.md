# Flutter UI - Step-by-Step Instruction Manual

Kyunki hum pehle Frontend (UI) par kaam kar rahe hain, yeh manual aapko Flutter mein beautiful UI banane ka tareeka sikhayega. Hum Google Calendar jaisa Timeline aur Color-coded states design karenge.

---

## Step 1: Frontend Project Banana
Terminal mein apne main project folder (`e:\Project`) ke andar yeh command run karein:
```bash
flutter create frontend
```
Is command se `frontend` naam ka folder ban jayega jisme ek basic Flutter app hogi. Ab us folder mein jayein:
```bash
cd frontend
```

## Step 2: Zaroori Packages Install Karna
Humare design mein SVG images aur Google Fonts chahiye. Terminal mein yeh run karein:
```bash
flutter pub add flutter_svg google_fonts
```

## Step 3: Main App aur Theme Setup (`lib/main.dart`)
Flutter app humesha `main.dart` se start hoti hai. Is file ka saara purana code delete karke yeh code daalein:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Modern fonts ke liye
import 'screens/home_screen.dart'; // Hum yeh screen abhi banayenge

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false, // Right side se debug banner hatane ke liye
      theme: ThemeData(
        // App ka main color Deep Purple set kar rahe hain
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Modern font use karenge poori app mein
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      // App open hone par sabse pehle konsi screen dikhegi
      home: const HomeScreen(), 
    );
  }
}
```

## Step 4: Home Screen Banana (`lib/screens/home_screen.dart`)
Pehle `lib` folder ke andar ek naya folder banayein `screens`. Phir usme `home_screen.dart` banayein aur yeh code dalein:

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color thoda greyish white rakhenge
      backgroundColor: Colors.grey[100], 
      
      appBar: AppBar(
        title: const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0, // AppBar ki shadow hatane ke liye
      ),
      
      // Floating Action Button (Naya task add karne ke liye)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Bottom sheet open karne ka logic yahan aayega
        },
        child: const Icon(Icons.add),
      ),
      
      // Screen ka main hissa
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Summary (Pending | Done)
            const Text(
              "Today's Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDashboard(), // Niche ek helper method banaya hai iske liye
            
            const SizedBox(height: 20),
            
            // Timeline aur Task List (Abhi dummy UI)
            Expanded(
              child: Center(
                // Agar koi task nahi hai toh yeh text dikhega
                child: Text('Relax, no tasks for today!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dashboard UI banane ka helper method
  Widget _buildDashboard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Text('⏱️ 3 Pending', style: TextStyle(color: Colors.blue)),
          Text('✅ 5 Done', style: TextStyle(color: Colors.green)),
          Text('🔥 1 Late', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
```

---
Bhai, pehle itna code apne Flutter project mein set karke dekhiye. Jab yeh UI aapke emulator ya phone mein dikhne lag jaye, toh hum `TaskTile` aur `BottomSheet` ka design banana seekhenge!
