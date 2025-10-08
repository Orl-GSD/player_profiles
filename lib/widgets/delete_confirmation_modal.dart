import 'package:flutter/material.dart';

class DeleteConfirmationModal extends StatelessWidget {
  final String playerName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteConfirmationModal({
    super.key,
    required this.playerName,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Remove Player?',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color.fromARGB(255, 31, 31, 31),
        )
      ),
      content: Text('Are you sure you want to remove $playerName? This action cannot be undone.'),
      backgroundColor: Colors.white,
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Color.fromARGB(255, 169, 169, 169),
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}