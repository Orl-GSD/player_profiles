// lib/widgets/add_game_schedule_dialog.dart

import 'package:flutter/material.dart';
import 'package:player_profiles/model/game_schedule.dart';
import 'package:player_profiles/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddGameScheduleDialog extends StatefulWidget {
  const AddGameScheduleDialog({super.key});

  @override
  State<AddGameScheduleDialog> createState() => _AddGameScheduleDialogState();
}

class _AddGameScheduleDialogState extends State<AddGameScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _courtNumberController = TextEditingController();
  final _uuid = const Uuid();
  
  // State for date/time pickers
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // --- Date/Time Picker Functions ---

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 7)), // Allow booking in the past?
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(bool isStartTime) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStartTime ? _startTime : _endTime) ?? now,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  // --- Submit Function ---

  void _submit() {
    // 1. Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Validate date/time
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time range'), backgroundColor: Colors.red),
      );
      return;
    }
    
    // 3. Combine Date and Time
    final startDateTime = DateTime(
      _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
      _startTime!.hour, _startTime!.minute,
    );
    final endDateTime = DateTime(
      _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
      _endTime!.hour, _endTime!.minute,
    );
    
    // 4. Validate time range
    if(endDateTime.isBefore(startDateTime) || endDateTime.isAtSameMomentAs(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time'), backgroundColor: Colors.red),
      );
      return;
    }

    // 5. Create the new schedule object
    final newSchedule = GameSchedule(
      id: _uuid.v4(),
      courtNumber: _courtNumberController.text,
      gameDate: _selectedDate!,
      startTime: startDateTime,
      endTime: endDateTime,
    );
    
    // 6. Return it to the AddGameScreen
    Navigator.pop(context, newSchedule);
  }
  
  // --- Helpers for display ---
  String _formatDate(DateTime? date) {
    return date == null ? 'Select Date' : DateFormat.yMMMd().format(date);
  }
  
  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Schedule'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Court # ---
              InputField(
                labelText: 'Court Number',
                hintText: 'e.g., "1" or "Main"',
                controller: _courtNumberController,
                prefixIcon: Icons.pin,
                validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              // --- Date Picker ---
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                title: const Text('Date'),
                subtitle: Text(_formatDate(_selectedDate)),
                onTap: _pickDate,
                trailing: const Icon(Icons.chevron_right),
              ),
              
              // --- Start Time Picker ---
              ListTile(
                leading: const Icon(Icons.access_time, color: Colors.blueAccent),
                title: const Text('Start Time'),
                subtitle: Text(_formatTime(_startTime)),
                onTap: () => _pickTime(true),
                trailing: const Icon(Icons.chevron_right),
              ),
              
              // --- End Time Picker ---
              ListTile(
                leading: const Icon(Icons.access_time_filled, color: Colors.blueAccent),
                title: const Text('End Time'),
                subtitle: Text(_formatTime(_endTime)),
                onTap: () => _pickTime(false),
                trailing: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close without data
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          child: const Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}