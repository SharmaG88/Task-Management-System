import 'package:flutter/material.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Map<String, String>? initialTask; // Agar update karna hai toh purana data
  final Function(String title, String time) onSave;

  const AddTaskBottomSheet({
    super.key,
    this.initialTask,
    required this.onSave,
  });

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController timeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialTask?['title'] ?? '');
    timeController = TextEditingController(text: widget.initialTask?['time'] ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    timeController.dispose();
    super.dispose();
  }

  // Real Clock UI se time pick karne ka function
  void _pickTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null && mounted) {
      // Time select hone ke baad text field mein daalenge
      setState(() {
        timeController.text = selectedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isUpdate = widget.initialTask != null;

    // MediaQuery taaki keyboard open hone par bottom sheet upar shift ho jaye
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Keyboard padding
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Jitni jagah chahiye utni le
        children: [
          Text(
            isUpdate ? 'Update Task' : 'Add New Task',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Task Name input
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Task Name', 
              hintText: 'e.g. Do Yoga',
              prefixIcon: const Icon(Icons.task_alt),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 15),
          
          // Time Picker input (Is par click karne par clock khulegi)
          TextField(
            controller: timeController,
            readOnly: true, // Type nahi kar sakte, tap karke pick karna hoga
            onTap: _pickTime,
            decoration: InputDecoration(
              labelText: 'Time', 
              hintText: 'Tap to select time',
              prefixIcon: const Icon(Icons.access_time),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          
          // Save Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && timeController.text.isNotEmpty) {
                  widget.onSave(nameController.text, timeController.text);
                  Navigator.pop(context); // Sheet band kardo
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Task', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
