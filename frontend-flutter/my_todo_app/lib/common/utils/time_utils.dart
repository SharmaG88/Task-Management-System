import 'package:flutter/material.dart';

// Yeh class time se related common functions handle karegi
class TimeUtils {
  
  // String time (e.g. "10:30 AM") ko real time se compare karke batayega ki late hai ya nahi
  static bool isTaskLate(String timeStr) {
    try {
      final now = TimeOfDay.now();
      String lower = timeStr.toLowerCase();
      bool isPM = lower.contains('pm');
      bool isAM = lower.contains('am');
      
      String cleanTime = lower.replaceAll('am', '').replaceAll('pm', '').trim();
      List<String> parts = cleanTime.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1].split(' ')[0]); 
      
      if (isPM && hour < 12) hour += 12;
      if (isAM && hour == 12) hour = 0;
      
      if (now.hour > hour) return true;
      if (now.hour == hour && now.minute > minute) return true;
      return false;
    } catch (e) {
      return false;
    }
  }
}
