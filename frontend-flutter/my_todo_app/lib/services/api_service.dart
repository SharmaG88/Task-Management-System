import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ IMPORTANT:
  // Agar aap Emulator use kar rahe hain, toh 'http://10.0.2.2:3000' likhiye.
  // Agar aap Asli Phone (Physical Device) Wi-Fi ke zariye use kar rahe hain, 
  // toh aapko apne PC ka local IP (IPv4 Address) yahan likhna padega.
  // Example: 'http://192.168.1.5:3000'
  static const String baseUrl = 'http://192.168.1.5:3000'; // Isko apne PC ke IP se badalna mat bhulna

  // 1. GET: Saare tasks lana
  static Future<List<dynamic>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks'));
      if (response.statusCode == 200) {
        return json.decode(response.body); // JSON string ko Dart List mein convert karna
      }
    } catch (e) {
      print("Fetch Error: $e");
    }
    return [];
  }

  // 2. POST: Naya task database mein dalna
  static Future<bool> createTask(String title, String time) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'time': time,
          'isDone': false
        }),
      );
      return response.statusCode == 201; // Success hone par true dega
    } catch (e) {
      print("Create Error: $e");
      return false;
    }
  }

  // 3. PUT: Task ko update karna (Title, Time ya Done mark karne ke liye)
  static Future<bool> updateTask(String id, String title, String time, bool isDone) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'time': time,
          'isDone': isDone
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Update Error: $e");
      return false;
    }
  }

  // 4. DELETE: Task ko delete karna
  static Future<bool> deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
      return response.statusCode == 200;
    } catch (e) {
      print("Delete Error: $e");
      return false;
    }
  }
}
