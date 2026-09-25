import 'package:flutter/material.dart';

class DashboardSummary extends StatelessWidget {
  final int pendingCount;
  final int doneCount;
  final int lateCount;

  const DashboardSummary({
    super.key,
    required this.pendingCount,
    required this.doneCount,
    required this.lateCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSummaryBox('Pending', pendingCount, Colors.orangeAccent),
          _buildSummaryBox('Done', doneCount, Colors.greenAccent),
          _buildSummaryBox('Late', lateCount, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String title, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(), 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)
        ),
        Text(
          title, 
          style: const TextStyle(fontSize: 14, color: Colors.white70)
        ),
      ],
    );
  }
}
