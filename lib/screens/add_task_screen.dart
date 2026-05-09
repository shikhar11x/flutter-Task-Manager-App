import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/task.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/gradient_button.dart';
import '../widgets/date_picker_field.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String _selectedDate =
      DateFormat('dd/MM/yyyy').format(DateTime.now());

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _firestoreService.addTask(Task(
          id: '',
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          date: _selectedDate,
          userId: _authService.currentUser!.uid,
        ));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task added successfully! ✅')));
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
                    const Text('Add New Task',
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
                                text: 'Add Task',
                                onPressed: _addTask,
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