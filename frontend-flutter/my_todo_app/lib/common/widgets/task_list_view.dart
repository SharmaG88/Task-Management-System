import 'package:flutter/material.dart';
import 'task_tile.dart';

class TaskListView extends StatelessWidget {
  final List<Map<String, String>> lateTasks;
  final List<Map<String, String>> pendingTasks;
  final List<Map<String, String>> doneTasks;
  
  // Callbacks
  final Function(String, bool) onStatusChange;
  final Function(String) onDelete;
  final Function(String) onEdit;
  final VoidCallback onClearCompleted;

  const TaskListView({
    super.key,
    required this.lateTasks,
    required this.pendingTasks,
    required this.doneTasks,
    required this.onStatusChange,
    required this.onDelete,
    required this.onEdit,
    required this.onClearCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        
        // --- 1. Late Tasks ---
        if (lateTasks.isNotEmpty) ...[
          _buildHeader('Late Tasks (Overdue)', Colors.redAccent),
          ...lateTasks.map((task) => TaskTile(
            key: ValueKey(task['id']), 
            task: task, 
            isLast: task == lateTasks.last && pendingTasks.isEmpty && doneTasks.isEmpty,
            isLate: true, 
            onStatusChange: (isDone) => onStatusChange(task['id']!, isDone),
            onDelete: () => onDelete(task['id']!), 
            onEdit: () => onEdit(task['id']!),
          )),
          const SizedBox(height: 20),
        ],

        // --- 2. Upcoming Tasks ---
        if (pendingTasks.isNotEmpty) ...[
          if (lateTasks.isNotEmpty) 
            _buildHeader('Upcoming Tasks', Colors.deepPurple),
          ...pendingTasks.map((task) => TaskTile(
            key: ValueKey(task['id']), 
            task: task, 
            isLast: task == pendingTasks.last && doneTasks.isEmpty, 
            isLate: false,
            onStatusChange: (isDone) => onStatusChange(task['id']!, isDone),
            onDelete: () => onDelete(task['id']!), 
            onEdit: () => onEdit(task['id']!),
          )),
        ],

        // --- 3. Completed Tasks ---
        if (doneTasks.isNotEmpty) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Completed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
              TextButton.icon(
                onPressed: onClearCompleted,
                icon: const Icon(Icons.delete_sweep, color: Colors.red),
                label: const Text('Clear', style: TextStyle(color: Colors.red)),
              )
            ],
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 10),
          ...doneTasks.map((task) => TaskTile(
            key: ValueKey(task['id']), 
            task: task, 
            isLast: task == doneTasks.last, 
            isLate: false,
            onStatusChange: (isDone) => onStatusChange(task['id']!, isDone),
            onDelete: () => onDelete(task['id']!), 
            onEdit: () => onEdit(task['id']!),
          )),
        ],
      ],
    );
  }

  // Header draw karne ka helper function taaki code repeat na ho
  Widget _buildHeader(String title, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Divider(color: color, thickness: 1),
        const SizedBox(height: 10),
      ],
    );
  }
}
