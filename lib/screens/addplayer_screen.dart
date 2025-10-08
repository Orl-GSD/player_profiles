import 'package:flutter/material.dart';
import 'package:player_profiles/model/player.dart';
import 'package:player_profiles/widgets/input_field.dart';
import 'package:player_profiles/widgets/level_slider.dart';
import 'package:player_profiles/screens/playerprofiles_screen.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key});

  @override
  State<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _contactNumController = TextEditingController();
  final _emailAdController = TextEditingController();
  final _addressController = TextEditingController();
  final _remarksController = TextEditingController();

  // Level and Strength (with defaults)
  Level _levelStart = Level.beginner;
  Level _levelEnd = Level.intermediate;
  Strength? _strengthStart = Strength.weak;
  Strength? _strengthEnd = Strength.mid;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create new Player
      final newPlayer = Player(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nickname: _nicknameController.text.trim(),
        name: _nameController.text.trim(),
        contactNum: _contactNumController.text.trim(),
        emailAd: _emailAdController.text.trim(),
        address: _addressController.text.trim(),
        remarks: _remarksController.text.trim(),
        levelStart: _levelStart,
        levelEnd: _levelEnd,
        strengthStart: _strengthStart,
        strengthEnd: _strengthEnd,
      );

      Navigator.pop(context, newPlayer);

      // Clear form fields
      _nameController.clear();
      _nicknameController.clear();
      _contactNumController.clear();
      _emailAdController.clear();
      _addressController.clear();
      _remarksController.clear();

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
                'Player added successfully!',
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            spacing: 10,
            children: [
              Icon(
                Icons.error_outline_outlined,
                color: Colors.white
              ),
              Text(
                'Please fix the errors before submitting.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ]
          ), 
          backgroundColor: Color.fromARGB(255, 198, 60, 60),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _nicknameController.dispose();
    _contactNumController.dispose();
    _emailAdController.dispose();
    _addressController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 196, 196, 196),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add New Player',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Full Name
                      InputField(
                        controller: _nameController,
                        labelText: 'Full Name',
                        prefixIcon: Icons.person,
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Full name is required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Nickname
                      InputField(
                        controller: _nicknameController,
                        labelText: 'Nickname',
                        prefixIcon: Icons.person,
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Nickname is required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Mobile Number
                      InputField(
                        controller: _contactNumController,
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

                      // Email
                      InputField(
                        controller: _emailAdController,
                        labelText: 'Email Address',
                        prefixIcon: Icons.mail,
                        isEmail: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address
                      InputField(
                        controller: _addressController,
                        labelText: 'Home Address',
                        prefixIcon: Icons.location_city,
                        maxLines: 3,
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Address is required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Remarks
                      InputField(
                        controller: _remarksController,
                        labelText: 'Remarks',
                        prefixIcon: Icons.book,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Level Slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Level Range',
                            style: TextStyle(
                              fontSize: 18,
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
                                _strengthStart = startStrength;
                                _levelEnd = endLevel;
                                _strengthEnd = endStrength;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Cancel Button
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 48, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Submit Button
                          TextButton(
                            onPressed: _submitForm,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 48, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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
    );
  }
}