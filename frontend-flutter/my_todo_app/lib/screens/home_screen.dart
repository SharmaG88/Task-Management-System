import 'package:flutter/material.dart';
import '../widgets/dashboard_summary.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_bottom_sheet.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, String>> dummyTasks = [];

  // BottomSheet ko open karne ka function
  void _openAddTaskSheet({int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Sheet ko keyboard ke upar shift hone deta hai
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddTaskBottomSheet(
          initialTask: index != null ? dummyTasks[index] : null,
          onSave: (title, time) {
            setState(() {
              if (index != null) {
                // Update
                dummyTasks[index]['title'] = title;
                dummyTasks[index]['time'] = time;
              } else {
                // Add new (ID unique honi chahiye swipe to delete ke liye)
                dummyTasks.add({
                  'id': DateTime.now().millisecondsSinceEpoch.toString(), 
                  'title': title,
                  'time': time,
                  'isDone': 'false',
                });
              }
            });
          },
        );
      },
    );
  }

  void _toggleTaskStatus(int index) {
    setState(() {
      bool isDone = dummyTasks[index]['isDone'] == 'true';
      dummyTasks[index]['isDone'] = isDone ? 'false' : 'true';
    });
  }

  void _deleteTask(int index) {
    setState(() {
      dummyTasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    int doneCount = dummyTasks.where((task) => task['isDone'] == 'true').length;
    int pendingCount = dummyTasks.length - doneCount;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      
      appBar: AppBar(
        title: const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      floatingActionButton: dummyTasks.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _openAddTaskSheet(),
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      body: Column(
        children: [
          // Imported Reusable Widget
          DashboardSummary(
            pendingCount: pendingCount,
            doneCount: doneCount,
            lateCount: 0,
          ),
          
          Expanded(
            child: dummyTasks.isEmpty
                ? _buildEmptyState()
                : _buildTaskList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center( 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_month_outlined, size: 100, color: Colors.deepPurpleAccent),
          const SizedBox(height: 20),
          const Text('Your day is clear!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Click below to plan your day.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _openAddTaskSheet(), 
            icon: const Icon(Icons.add), 
            label: const Text('Add Task', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dummyTasks.length,
      itemBuilder: (context, index) {
        return TaskTile(
          task: dummyTasks[index],
          isLast: index == dummyTasks.length - 1,
          onToggleDone: () => _toggleTaskStatus(index),
          onDelete: () => _deleteTask(index),
          onEdit: () => _openAddTaskSheet(index: index),
        );
      },
    );
  }
}
