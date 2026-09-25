import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final Map<String, String> task;
  final bool isLast;
  final VoidCallback onToggleDone;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.isLast,
    required this.onToggleDone,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    bool isDone = task['isDone'] == 'true';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Side: Time
        SizedBox(
          width: 70, // Thodi width badhayi taaki AM/PM theek se aaye
          child: Text(
            task['time']!, 
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
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
              color: isDone ? Colors.green : Colors.deepPurple
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

        // Right Side: Task Card with Swipe Gestures (Dismissible)
        Expanded(
          child: Dismissible(
            // Key ek unique ID honi chahiye, humne id use kiya hai
            key: Key(task['id']!), 
            
            // Background jab user Right swipe kare (Done mark karne ke liye)
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.check, color: Colors.white, size: 30),
            ),
            
            // Background jab user Left swipe kare (Delete karne ke liye)
            secondaryBackground: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            
            // Swipe handle karna
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                // Right to Left swipe kiya = Delete
                onDelete();
              } else if (direction == DismissDirection.startToEnd) {
                // Left to Right swipe kiya = Done (Lekin dismissible element ko wapas laane ke liye hum isko false se true karte hain)
                // Dismissible UI se gayab ho jata hai, par hum chahte hain wo list mein rahe as 'Done'.
                // Isliye Swipe to Done theek se tab kaam karega jab hum widget ko dubara render karein.
                onToggleDone();
              }
            },
            
            child: Card(
              elevation: isDone ? 0 : 3, 
              color: isDone ? Colors.grey[200] : Colors.white, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                
                leading: Checkbox(
                  value: isDone,
                  activeColor: Colors.green,
                  shape: const CircleBorder(),
                  onChanged: (value) => onToggleDone(),
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
                  onPressed: onEdit,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
