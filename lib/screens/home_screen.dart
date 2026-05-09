import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/quote_service.dart';
import '../models/task.dart';
import '../widgets/app_background.dart';
import '../widgets/stat_card.dart';
import '../widgets/task_card.dart';
import '../widgets/user_avatar.dart';
import '../widgets/logout_button.dart';
import '../widgets/quote_card.dart';
import '../widgets/delete_dialog.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final QuoteService _quoteService = QuoteService();

  String _quote = '';
  String _author = '';
  bool _quoteLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuote();
  }

  // load quote
  Future<void> _loadQuote() async {
    setState(() {
      _quoteLoading = true;
      _quote = '';
      _author = '';
    });
    try {
      final data = await _quoteService.fetchQuote();
      setState(() {
        _quote = data['quote']!;
        _author = data['author']!;
        _quoteLoading = false;
      });
    } catch (e) {
      setState(() {
        _quote = 'Stay focused and never give up!';
        _author = 'Unknown';
        _quoteLoading = false;
      });
    }
  }

  // logout
  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  // delete task
  Future<void> _deleteTask(String taskId) async {
    showDialog(
      context: context,
      builder: (ctx) => DeleteDialog(
        onConfirm: () async {
          await _firestoreService.deleteTask(taskId);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task deleted! 🗑️')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUser!.uid;
    final email = _authService.currentUser!.email ?? '';
    final username = email.split('@')[0];

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    UserAvatar(username: username),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello, $username 👋',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          Text('Stay productive today!',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    LogoutButton(onTap: _logout),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Stats Row ──
              StreamBuilder<List<Task>>(
                stream: _firestoreService.getTasks(userId),
                builder: (context, snapshot) {
                  final tasks = snapshot.data ?? [];
                  final total = tasks.length;
                  final completed =
                      tasks.where((t) => t.isCompleted).length;
                  final pending = total - completed;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        StatCard(
                          label: 'Total',
                          value: total.toString(),
                          icon: Icons.list_alt,
                          color: const Color(0xFF4A90E2),
                        ),
                        const SizedBox(width: 12),
                        StatCard(
                          label: 'Done',
                          value: completed.toString(),
                          icon: Icons.check_circle_outline,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 12),
                        StatCard(
                          label: 'Pending',
                          value: pending.toString(),
                          icon: Icons.pending_actions,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ── Quote Card ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: QuoteCard(
                  quote: _quote,
                  author: _author,
                  isLoading: _quoteLoading,
                  onRefresh: _loadQuote,
                ),
              ),

              const SizedBox(height: 20),

              // ── Tasks Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Tasks',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddTaskScreen()),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A90E2), Color(0xFF7B5EA7)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF4A90E2).withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Add Task',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Tasks List ──
              Expanded(
                child: StreamBuilder<List<Task>>(
                  stream: _firestoreService.getTasks(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Colors.white));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.05),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Icon(Icons.task_outlined,
                                  size: 50,
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                            const SizedBox(height: 16),
                            Text('Nothing to do right now!',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            Text('Add tasks using the "+" button..',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.3),
                                    fontSize: 13)),
                          ],
                        ),
                      );
                    }

                    final tasks = snapshot.data!;
                    return ListView.builder(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskCard(
                          task: task,
                          onToggle: () =>
                              _firestoreService.toggleComplete(
                                  task.id, task.isCompleted),
                          onEdit: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    EditTaskScreen(task: task)),
                          ),
                          onDelete: () => _deleteTask(task.id),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTaskScreen()),
        ),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}