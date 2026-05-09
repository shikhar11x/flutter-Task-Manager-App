import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String selectedDate;
  final VoidCallback onTap;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFF4A90E2)),
            const SizedBox(width: 12),
            Text(
              selectedDate,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const Spacer(),
            Icon(Icons.arrow_drop_down, color: Colors.white.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

/// Shared date picker helper — call from any screen
Future<String?> pickDate(BuildContext context) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2024),
    lastDate: DateTime(2030),
    builder: (context, child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4A90E2),
            surface: Color(0xFF1a1a2e),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked == null) return null;
  final d = picked.day.toString().padLeft(2, '0');
  final m = picked.month.toString().padLeft(2, '0');
  final y = picked.year.toString();
  return '$d/$m/$y';
}