// lib/screens/user_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:player_profiles/model/settings.dart';
import 'package:player_profiles/widgets/input_field.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _settingsService = Settings();

  // Controllers for the text fields
  final _courtNameController = TextEditingController();
  final _courtRateController = TextEditingController();
  final _shuttlePriceController = TextEditingController();

  // State for the checkbox
  bool _divideEqually = true;
  // State to show a loading spinner
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is removed
    _courtNameController.dispose();
    _courtRateController.dispose();
    _shuttlePriceController.dispose();
    super.dispose();
  }

  // --- Data Functions ---

  Future<void> _loadSettings() async {
    // Show loading spinner
    setState(() { _isLoading = true; });

    final settings = await _settingsService.loadSettings();

    // Set the state with the loaded data
    setState(() {
      _courtNameController.text = settings['courtName'];
      _courtRateController.text = settings['courtRate'].toString();
      _shuttlePriceController.text = settings['shuttlePrice'].toString();
      _divideEqually = settings['divideEqually'];
      
      // Hide loading spinner
      _isLoading = false;
    });
  }

  void _saveSettings() async {
    // 1. Validate the form
    if (_formKey.currentState!.validate()) {
      // 2. Save the data using the service
      await _settingsService.saveSettings(
        courtName: _courtNameController.text,
        courtRate: double.tryParse(_courtRateController.text) ?? 0.0,
        shuttlePrice: double.tryParse(_shuttlePriceController.text) ?? 0.0,
        divideEqually: _divideEqually,
      );

      // 3. Show a confirmation message (Snackbar)
      if (mounted) { // Check if the widget is still on screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  // --- Build Function ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Settings'),
        // Add a save button to the app bar
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.blueAccent, 
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          // Show a spinner while loading
          ? const Center(child: CircularProgressIndicator())
          // Show the form once loaded
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // --- Default Court Name ---
                      InputField(
                        labelText: 'Default Court Name',
                        controller: _courtNameController,
                        prefixIcon: Icons.place,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a court name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // --- Default Court Rate ---
                      InputField(
                        labelText: 'Default Court Rate (per hour)',
                        controller: _courtRateController,
                        prefixIcon: Icons.monetization_on,
                        isNumber: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a rate';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // --- Default Shuttlecock Price ---
                      InputField(
                        labelText: 'Default Shuttlecock Price',
                        controller: _shuttlePriceController,
                        prefixIcon: Icons.price_change,
                        isNumber: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // --- Divide Equally Checkbox ---
                      CheckboxListTile(
                        title: const Text('Divide the court equally among players'),
                        value: _divideEqually,
                        onChanged: (newValue) {
                          setState(() {
                            _divideEqually = newValue ?? true;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading, // Checkbox on the left
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}