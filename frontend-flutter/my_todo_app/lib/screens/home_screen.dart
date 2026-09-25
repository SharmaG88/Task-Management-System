import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // Ab hum 'isDone' (true/false) bhi save karenge taaki pata chale task complete hua hai ya nahi.
  List<Map<String, String>> dummyTasks = [];

  void _showTaskDialog({int? index}) {
    bool isUpdate = index != null;

    TextEditingController nameController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    if (isUpdate) {
      nameController.text = dummyTasks[index]['title']!;
      timeController.text = dummyTasks[index]['time']!;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUpdate ? 'Update Task' : 'Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Task Name', hintText: 'e.g. Do Yoga'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time (Timer)', hintText: 'e.g. 10:00 AM - 11:00 AM'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && timeController.text.isNotEmpty) {
                  setState(() {
                    if (isUpdate) {
                      // Update karte waqt 'isDone' ka purana status hi rakhna hai
                      dummyTasks[index] = {
                        'title': nameController.text,
                        'time': timeController.text,
                        'isDone': dummyTasks[index]['isDone']!, // Purana status
                      };
                    } else {
                      // Naya task humesha 'false' (pending) se start hoga
                      dummyTasks.add({
                        'title': nameController.text,
                        'time': timeController.text,
                        'isDone': 'false', 
                      });
                    }
                  });
                  Navigator.pop(context); 
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], 
      
      appBar: AppBar(
        title: const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: dummyTasks.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showTaskDialog(), 
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null, 

      body: dummyTasks.isEmpty
          ? _buildEmptyState() 
          : _buildTaskList(),  
    );
  }

  Widget _buildEmptyState() {
    return Center( 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assignment_add, size: 100, color: Colors.deepPurpleAccent),
          const SizedBox(height: 20),
          const Text('Koi task nahi hai!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Naya task add karne ke liye neeche click karein', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _showTaskDialog(), 
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
        
        // Check kar rahe hain ki yeh wala task complete hai ya nahi
        bool isDone = dummyTasks[index]['isDone'] == 'true';

        return Card(
          elevation: isDone ? 0 : 2, // Agar complete hai toh shadow hata denge (flat ho jayega)
          color: isDone ? Colors.grey[200] : Colors.white, // Complete hone par grey rang ka box
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            
            // --- Checkbox (Tick Option) ---
            leading: Checkbox(
              value: isDone,
              activeColor: Colors.green, // Tick green color ka aayega
              onChanged: (bool? value) {
                // Jab user tick karega toh yeh code chalega
                setState(() {
                  dummyTasks[index]['isDone'] = value! ? 'true' : 'false';
                });
              },
            ), 
            
            // Task ka naam (Agar done hai toh kata hua text aayega)
            title: Text(
              dummyTasks[index]['title']!, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                decoration: isDone ? TextDecoration.lineThrough : null, // Line through (kata hua)
                color: isDone ? Colors.grey : Colors.black, // Color fade out
              )
            ),
            
            // Task ka time
            subtitle: Text(
              dummyTasks[index]['time']!, 
              style: TextStyle(
                color: isDone ? Colors.grey : Colors.deepOrange, 
                fontWeight: FontWeight.w500,
                decoration: isDone ? TextDecoration.lineThrough : null,
              )
            ),
            
            trailing: Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showTaskDialog(index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      dummyTasks.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
