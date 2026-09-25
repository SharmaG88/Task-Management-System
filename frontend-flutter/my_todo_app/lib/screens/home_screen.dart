import 'package:flutter/material.dart';
import '../common/widgets/dashboard_summary.dart';
import '../common/widgets/add_task_bottom_sheet.dart';
import '../common/widgets/empty_state_widget.dart';
import '../common/widgets/task_list_view.dart';
import '../common/utils/time_utils.dart';
import '../services/api_service.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, String>> dummyTasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasksFromDatabase();
  }

  // ---------------------------------------------------
  // 1. API & STATE LOGIC (Data manage karne wale functions)
  // ---------------------------------------------------

  Future<void> _loadTasksFromDatabase() async {
    setState(() => isLoading = true);
    final fetchedTasks = await ApiService.fetchTasks();
    setState(() {
      dummyTasks = fetchedTasks.map<Map<String, String>>((t) => {
        'id': t['id'].toString(),
        'title': t['title'].toString(),
        'time': t['time'].toString(),
        'isDone': t['isDone'] ? 'true' : 'false',
      }).toList();
      isLoading = false;
    });
  }

  int _findTaskIndex(String id) => dummyTasks.indexWhere((task) => task['id'] == id);

  void _changeTaskStatus(String id, bool isDone) async {
    int index = _findTaskIndex(id);
    if (index != -1) {
      setState(() => dummyTasks[index]['isDone'] = isDone ? 'true' : 'false');
      await ApiService.updateTask(id, dummyTasks[index]['title']!, dummyTasks[index]['time']!, isDone);
    }
  }

  void _deleteTask(String id) async {
    setState(() => dummyTasks.removeWhere((task) => task['id'] == id));
    await ApiService.deleteTask(id);
  }

  void _clearCompletedTasks() async {
    setState(() => isLoading = true);
    List<Map<String, String>> doneTasks = dummyTasks.where((t) => t['isDone'] == 'true').toList();
    for (var task in doneTasks) {
      await ApiService.deleteTask(task['id']!);
    }
    await _loadTasksFromDatabase();
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
          onSave: (title, time) async {
            setState(() => isLoading = true);
            if (index != -1) {
              bool isDone = dummyTasks[index]['isDone'] == 'true';
              await ApiService.updateTask(dummyTasks[index]['id']!, title, time, isDone);
            } else {
              await ApiService.createTask(title, time);
            }
            await _loadTasksFromDatabase();
          },
        );
      },
    );
  }

  // ---------------------------------------------------
  // 2. HELPER FUNCTIONS (Logic simplify karne ke liye)
  // ---------------------------------------------------

  // Tasks ko unke time aur status ke hisaab se 3 list mein baantne ka helper function
  Map<String, List<Map<String, String>>> _categorizeTasks() {
    List<Map<String, String>> lateTasks = [];
    List<Map<String, String>> pendingTasks = [];
    List<Map<String, String>> doneTasks = [];

    for (var task in dummyTasks) {
      if (task['isDone'] == 'true') {
        doneTasks.add(task);
      } else {
        if (TimeUtils.isTaskLate(task['time']!)) lateTasks.add(task);
        else pendingTasks.add(task);
      }
    }
    return {'late': lateTasks, 'pending': pendingTasks, 'done': doneTasks};
  }

  // ---------------------------------------------------
  // 3. UI BUILDING (Sirf UI dikhana)
  // ---------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Tasks ko baantna
    final categorizedTasks = _categorizeTasks();
    final lateTasks = categorizedTasks['late']!;
    final pendingTasks = categorizedTasks['pending']!;
    final doneTasks = categorizedTasks['done']!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      
      appBar: AppBar(
        title: const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      floatingActionButton: !isLoading 
          ? FloatingActionButton(
              onPressed: () => _openAddTaskSheet(),
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,

      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : Column(
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
                      // Pura list UI yahan ek line mein simat gaya!
                      : TaskListView(
                          lateTasks: lateTasks,
                          pendingTasks: pendingTasks,
                          doneTasks: doneTasks,
                          onStatusChange: _changeTaskStatus,
                          onDelete: _deleteTask,
                          onEdit: (id) => _openAddTaskSheet(id: id),
                          onClearCompleted: _clearCompletedTasks,
                        ),
                ),
              ],
            ),
    );
  }
}
