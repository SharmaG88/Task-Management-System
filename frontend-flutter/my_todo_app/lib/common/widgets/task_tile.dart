import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final Map<String, String> task;
  final bool isLast;
  final bool isLate; // Late check karne ke liye flag
  final Function(bool) onStatusChange; 
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.isLast,
    this.isLate = false, // By default late nahi hai
    required this.onStatusChange,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    bool isDone = task['isDone'] == 'true';

    // Timeline ka color decide karte hain
    Color timelineColor = Colors.deepPurple;
    if (isDone) {
      timelineColor = Colors.green;
    } else if (isLate) {
      timelineColor = Colors.redAccent; // Agar late hai toh Red color
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Side: Time
        SizedBox(
          width: 70, 
          child: Text(
            task['time']!, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: isLate && !isDone ? Colors.redAccent : Colors.black54 // Late hone par time bhi red hoga
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 15),

        // Middle: Timeline Line & Dot
        Column(
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.circle, 
              size: 16, 
              color: timelineColor,
            ),
            if (!isLast) 
              Container(
                width: 2,
                height: 80,
                color: Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 15),

        // Right Side: Task Card
        Expanded(
          child: Dismissible(
            key: Key(task['id']!), 
            
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.check, color: Colors.white, size: 30),
            ),
            
            secondaryBackground: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                onStatusChange(true);
                return false; 
              }
              return true; 
            },

            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                onDelete();
              }
            },
            
            child: Card(
              elevation: isDone ? 0 : (isLate ? 4 : 3), // Late wale ka shadow thoda zyada
              color: isDone 
                  ? Colors.grey[200] 
                  : (isLate ? Colors.red[50] : Colors.white), // Late hone par halka red background
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: isLate && !isDone ? const BorderSide(color: Colors.redAccent, width: 1) : BorderSide.none, // Red border agar late hai
              ),
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                
                leading: Checkbox(
                  value: isDone,
                  activeColor: Colors.green,
                  shape: const CircleBorder(),
                  onChanged: (value) => onStatusChange(value ?? false),
                ), 
                
                title: Text(
                  task['title']!, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18,
                    decoration: isDone ? TextDecoration.lineThrough : null, 
                    color: isDone ? Colors.grey : Colors.black87, 
                  )
                ),
                
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                  onPressed: onEdit, // Edit dabane par pop-up aayega jahan time update kar sakte hain
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
