import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: task.isCompleted
                  ? Colors.white.withOpacity(0.04)
                  : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: task.isCompleted
                    ? Colors.white.withOpacity(0.08)
                    : const Color(0xFF4A90E2).withOpacity(0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: onToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: task.isCompleted
                            ? const LinearGradient(colors: [
                                Color(0xFF4A90E2),
                                Color(0xFF7B5EA7)
                              ])
                            : null,
                        color: task.isCompleted
                            ? null
                            : Colors.transparent,
                        border: Border.all(
                          color: task.isCompleted
                              ? Colors.transparent
                              : Colors.white38,
                          width: 2,
                        ),
                        boxShadow: task.isCompleted
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF4A90E2)
                                      .withOpacity(0.4),
                                  blurRadius: 8,
                                )
                              ]
                            : null,
                      ),
                      child: task.isCompleted
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: task.isCompleted
                                ? Colors.white30
                                : Colors.white,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: Colors.white30,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          task.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 11,
                                color: Colors.white.withOpacity(0.4)),
                            const SizedBox(width: 4),
                            Text(task.date,
                                style: TextStyle(
                                    fontSize: 11,
                                    color:
                                        Colors.white.withOpacity(0.4))),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: task.isCompleted
                                    ? Colors.green.withOpacity(0.15)
                                    : Colors.orange.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: task.isCompleted
                                      ? Colors.green.withOpacity(0.4)
                                      : Colors.orange.withOpacity(0.4),
                                ),
                              ),
                              child: Text(
                                task.isCompleted
                                    ? '✓ Done'
                                    : '⏳ Pending',
                                style: TextStyle(
                                  color: task.isCompleted
                                      ? Colors.green.shade300
                                      : Colors.orange.shade300,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions
                  Column(
                    children: [
                      GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A90E2)
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFF4A90E2)
                                    .withOpacity(0.3)),
                          ),
                          child: const Icon(Icons.edit_outlined,
                              color: Color(0xFF4A90E2), size: 16),
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Icon(Icons.delete_outline,
                              color: Colors.red.shade300, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}