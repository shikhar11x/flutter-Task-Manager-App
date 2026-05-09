import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/firestore_service.dart';
import '../models/task.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/date_picker_field.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  const EditTaskScreen({super.key, required this.task});
  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;
  late String _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.task.title);
    _descController =
        TextEditingController(text: widget.task.description);
    _selectedDate = widget.task.date;
  }

  Future<void> _updateTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _firestoreService.updateTask(Task(
          id: widget.task.id,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          date: _selectedDate,
          isCompleted: widget.task.isCompleted,
          userId: widget.task.userId,
        ));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Task updated successfully! ✅')));
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter:
                              ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                            child: const Icon(Icons.arrow_back_ios,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('Edit Task',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter:
                          ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // Title
                              const Text('Task Title',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13)),
                              const SizedBox(height: 8),
                              GlassTextField(
                                controller: _titleController,
                                label: 'Enter title',
                                icon: Icons.title,
                                validator: (val) => val!.isEmpty
                                    ? 'Please enter a title'
                                    : null,
                              ),
                              const SizedBox(height: 20),

                              // Description
                              const Text('Description',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13)),
                              const SizedBox(height: 8),
                              GlassTextField(
                                controller: _descController,
                                label: 'Enter description',
                                icon: Icons.description_outlined,
                                maxLines: 4,
                                validator: (val) => val!.isEmpty
                                    ? 'Please enter a description'
                                    : null,
                              ),
                              const SizedBox(height: 20),

                              // Date
                              const Text('Due Date',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13)),
                              const SizedBox(height: 8),
                              DatePickerField(
                                selectedDate: _selectedDate,
                                onTap: () async {
                                  final date = await pickDate(context);
                                  if (date != null) {
                                    setState(
                                        () => _selectedDate = date);
                                  }
                                },
                              ),
                              const SizedBox(height: 32),

                              GradientButton(
                                text: 'Update Task',
                                onPressed: _updateTask,
                                isLoading: _isLoading,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}