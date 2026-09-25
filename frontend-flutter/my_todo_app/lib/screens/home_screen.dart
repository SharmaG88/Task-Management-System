import 'package:flutter/material.dart';
import '../widgets/dashboard_summary.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_bottom_sheet.dart';
import '../widgets/empty_state_widget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, String>> dummyTasks = [];

  int _findTaskIndex(String id) {
    return dummyTasks.indexWhere((task) => task['id'] == id);
  }

  bool _isTaskLate(String timeStr) {
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

  void _openAddTaskSheet({String? id}) {
    int index = id != null ? _findTaskIndex(id) : -1;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return AddTaskBottomSheet(
          initialTask: index != -1 ? dummyTasks[index] : null,
          onSave: (title, time) {
            setState(() {
              if (index != -1) {
                dummyTasks[index]['title'] = title;
                dummyTasks[index]['time'] = time;
              } else {
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

  void _changeTaskStatus(String id, bool isDone) {
    setState(() {
      int index = _findTaskIndex(id);
      if (index != -1) dummyTasks[index]['isDone'] = isDone ? 'true' : 'false';
    });
  }

  void _deleteTask(String id) {
    setState(() {
      dummyTasks.removeWhere((task) => task['id'] == id);
    });
  }

  void _clearCompletedTasks() {
    setState(() {
      dummyTasks.removeWhere((task) => task['isDone'] == 'true');
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> lateTasks = [];
    List<Map<String, String>> pendingTasks = [];
    List<Map<String, String>> doneTasks = [];

    for (var task in dummyTasks) {
      if (task['isDone'] == 'true') {
        doneTasks.add(task);
      } else {
        if (_isTaskLate(task['time']!)) lateTasks.add(task);
        else pendingTasks.add(task);
      }
    }

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
          DashboardSummary(pendingCount: pendingTasks.length, doneCount: doneTasks.length, lateCount: lateTasks.length),
          
          Expanded(
            child: dummyTasks.isEmpty
                ? EmptyStateWidget(
                    title: 'Your day is clear!',
                    subtitle: 'Click below to plan your day.',
                    icon: Icons.calendar_month_outlined,
                    actionText: 'Add Task',
                    onActionPressed: () => _openAddTaskSheet(),
                  )
                : _buildTaskList(lateTasks, pendingTasks, doneTasks),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Map<String, String>> lateTasks, List<Map<String, String>> pendingTasks, List<Map<String, String>> doneTasks) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (lateTasks.isNotEmpty) ...[
          const Text('Late Tasks (Overdue)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          const Divider(color: Colors.redAccent, thickness: 1),
          const SizedBox(height: 10),
          ...lateTasks.map((task) => TaskTile(
            key: ValueKey(task['id']), task: task, isLast: task == lateTasks.last && pendingTasks.isEmpty && doneTasks.isEmpty,
            isLate: true, onStatusChange: (isDone) => _changeTaskStatus(task['id']!, isDone),
            onDelete: () => _deleteTask(task['id']!), onEdit: () => _openAddTaskSheet(id: task['id']),
          )),
          const SizedBox(height: 20),
        ],

        if (pendingTasks.isNotEmpty) ...[
          if (lateTasks.isNotEmpty) const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upcoming Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              Divider(color: Colors.deepPurple, thickness: 1),
              SizedBox(height: 10),
            ],
          ),
          ...pendingTasks.map((task) => TaskTile(
            key: ValueKey(task['id']), task: task, isLast: task == pendingTasks.last && doneTasks.isEmpty, isLate: false,
            onStatusChange: (isDone) => _changeTaskStatus(task['id']!, isDone),
            onDelete: () => _deleteTask(task['id']!), onEdit: () => _openAddTaskSheet(id: task['id']),
          )),
        ],

        if (doneTasks.isNotEmpty) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Completed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
              TextButton.icon(
                onPressed: _clearCompletedTasks,
                icon: const Icon(Icons.delete_sweep, color: Colors.red),
                label: const Text('Clear', style: TextStyle(color: Colors.red)),
              )
            ],
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 10),
          ...doneTasks.map((task) => TaskTile(
            key: ValueKey(task['id']), task: task, isLast: task == doneTasks.last, isLate: false,
            onStatusChange: (isDone) => _changeTaskStatus(task['id']!, isDone),
            onDelete: () => _deleteTask(task['id']!), onEdit: () => _openAddTaskSheet(id: task['id']),
          )),
        ],
      ],
    );
  }
}
