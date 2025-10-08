import 'package:flutter/material.dart';
import 'package:player_profiles/model/player.dart';
import 'package:player_profiles/widgets/input_field.dart';
import 'package:player_profiles/widgets/level_slider.dart';

class UpdatePlayerScreen extends StatefulWidget {
  final Player player;
  const UpdatePlayerScreen({super.key, required this.player});

  @override
  State<UpdatePlayerScreen> createState() => _UpdatePlayerScreenState();
}

class _UpdatePlayerScreenState extends State<UpdatePlayerScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nicknameController;
  late TextEditingController nameController;
  late TextEditingController contactNumController;
  late TextEditingController emailAdController;
  late TextEditingController addressController;
  late TextEditingController remarksController;
  late Level _levelStart;
  late Level _levelEnd;
  late Strength _strengthStart;
  late Strength _strengthEnd;

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController(text: widget.player.nickname);
    nameController = TextEditingController(text: widget.player.name);
    contactNumController = TextEditingController(text: widget.player.contactNum);
    emailAdController = TextEditingController(text: widget.player.emailAd);
    addressController = TextEditingController(text: widget.player.address);
    remarksController = TextEditingController(text: widget.player.remarks);

    _levelStart = widget.player.levelStart;
    _levelEnd = widget.player.levelEnd;
    _strengthStart = widget.player.strengthStart ?? Strength.weak;
    _strengthEnd = widget.player.strengthEnd ?? Strength.mid;
  }

  @override
  void dispose() {
    nicknameController.dispose();
    nameController.dispose();
    contactNumController.dispose();
    emailAdController.dispose();
    addressController.dispose();
    remarksController.dispose();
    super.dispose();
  }

void _saveChanges() {
  if (_formKey.currentState!.validate()) {
    final updatedPlayer = Player(
      id: widget.player.id,
      nickname: nicknameController.text.trim(),
      name: nameController.text.trim(),
      contactNum: contactNumController.text.trim(),
      emailAd: emailAdController.text.trim(),
      address: addressController.text.trim(),
      remarks: remarksController.text.trim(),
      levelStart: _levelStart,
      levelEnd: _levelEnd,
      strengthStart: _strengthStart,
      strengthEnd: _strengthEnd,
    );
    Navigator.pop(context, updatedPlayer);

  // Snackbar for Successful Player Update
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          spacing: 10,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white
            ),
            Text(
              'Player updated successfully!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ]
        ), 
        backgroundColor: Colors.green,
      ),
    );
  }
}

  // Delete Confirmation Modal and Snackbar for Successful Player Deletion
  void _deletePlayer() async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Remove Player?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color.fromARGB(255, 31, 31, 31),
          )
        ),
        content: Text('Are you sure you want to remove ${widget.player.name}? This action cannot be undone.'),
          backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color.fromARGB(255, 169, 169, 169),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmDelete == true) {
      Navigator.pop(context, 'delete');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            spacing: 10,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white
              ),
              Text(
                'Player deleted!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ]
          ), 
          backgroundColor: Color.fromARGB(255, 218, 60, 60),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Update Player',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.blueAccent,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Name Input Field
                      InputField(
                        controller: nameController,
                        labelText: 'Full Name',
                        prefixIcon: Icons.person,
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Full name is required' : null,
                      ),

                      const SizedBox(height: 16),
                      
                      // Nickname Input Field
                      InputField(
                        controller: nicknameController,
                        labelText: 'Nickname',
                        prefixIcon: Icons.person_outline,
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Nickname is required' : null,
                      ),

                      const SizedBox(height: 16),
                      
                      // Contact Number Input Field
                      InputField(
                        controller: contactNumController,
                        labelText: 'Mobile Number',
                        prefixIcon: Icons.phone,
                        isNumber: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Mobile number is required';
                          }
                          if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                            return 'Enter a valid mobile number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      
                      // Email Address Input Field
                      InputField(
                        controller: emailAdController,
                        labelText: 'Email Address',
                        prefixIcon: Icons.mail,
                        isEmail: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      
                      // Address Input Field
                      InputField(
                        controller: addressController,
                        labelText: 'Home Address',
                        prefixIcon: Icons.location_city,
                        maxLines: 3,
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Address is required' : null,
                      ),

                      const SizedBox(height: 16),
                      
                      // Remarks Input Field
                      InputField(
                        controller: remarksController,
                        labelText: 'Remarks',
                        prefixIcon: Icons.book,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),

                      // Level Range Slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Level Range',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(221, 54, 54, 54),
                            ),
                          ),
                          const SizedBox(height: 8),
                          LevelSlider(
                            initialStartLevel: _levelStart,
                            initialEndLevel: _levelEnd,
                            initialStartStrength: _strengthStart,
                            initialEndStrength: _strengthEnd,
                            onChanged: (startLevel, startStrength, endLevel, endStrength) {
                              setState(() {
                                _levelStart = startLevel;
                                _strengthStart = startStrength ?? Strength.weak;
                                _levelEnd = endLevel;
                                _strengthEnd = endStrength ?? Strength.mid;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Actions (Delete, Cancel, and Update Buttons)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _deletePlayer,
                            icon: const Icon(Icons.delete, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: _saveChanges,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Update',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}