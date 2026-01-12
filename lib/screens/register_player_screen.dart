import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/player_model.dart';
import '../services/firebase_service.dart';
import '../theme/theme_provider.dart';

class RegisterPlayerScreen extends StatefulWidget {
  const RegisterPlayerScreen({super.key});

  @override
  State<RegisterPlayerScreen> createState() => _RegisterPlayerScreenState();
}

class _RegisterPlayerScreenState extends State<RegisterPlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _battingHand;
  String? _bowlingHand;
  DateTime? _dob;
  XFile? _imageFile;
  bool _isLoading = false;

  final FirebaseService _firebaseService = FirebaseService();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              surface: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final player = Player(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          battingHand: _battingHand,
          bowlingHand: _bowlingHand,
          dob: _dob,
          photoUrl: null, 
        );

        await _firebaseService.addPlayer(player);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Player registered successfully!')),
          );
          _formKey.currentState!.reset();
          setState(() {
             _dob = null;
             _imageFile = null;
             _battingHand = null;
             _bowlingHand = null;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error registering player: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: false, // Changed to false for cleaner layout with SafeArea
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode_rounded : Icons.nightlight_round),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme(!isDarkMode);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Text(
                        'Sign up',
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join the team and start your journey.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Photo Upload (Simplified)
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              shape: BoxShape.circle,
                              image: _imageFile != null
                                  ? DecorationImage(
                                      image: kIsWeb
                                          ? NetworkImage(_imageFile!.path)
                                          : FileImage(File(_imageFile!.path)) as ImageProvider,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                              border: Border.all(
                                color: _imageFile == null ? theme.colorScheme.surface : theme.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: _imageFile == null
                                ? Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 30,
                                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                       child: Text(
                         'Add Profile Photo', 
                         style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                       )
                      ),
                      const SizedBox(height: 32),

                      // Fields
                      _buildLabel(theme, "Full Name"),
                      TextFormField(
                        controller: _nameController,
                        style: theme.textTheme.bodyLarge,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: "Enter your full name",
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),

                      _buildLabel(theme, "Phone Number"),
                      TextFormField(
                        controller: _phoneController,
                        style: theme.textTheme.bodyLarge,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: "Enter your phone number",
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),

                      _buildLabel(theme, "Email Address"),
                      TextFormField(
                        controller: _emailController,
                        style: theme.textTheme.bodyLarge,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Enter your email",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          if (!value.contains('@')) return 'Invalid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                       // Row for Hands to save space and look cool
                       Row(
                         children: [
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                  _buildLabel(theme, "Batting Hand"),
                                  DropdownButtonFormField<String>(
                                    value: _battingHand,
                                    padding: EdgeInsets.zero,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    ),
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                    items: ['Right Hand', 'Left Hand'].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) => setState(() => _battingHand = newValue),
                                    validator: (value) => value == null ? 'Required' : null,
                                  ),
                               ],
                             ),
                           ),
                           const SizedBox(width: 16),
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                  _buildLabel(theme, "Bowling Hand"),
                                  DropdownButtonFormField<String>(
                                    value: _bowlingHand,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    ),
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                    items: ['Right Arm', 'Left Arm'].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) => setState(() => _bowlingHand = newValue),
                                    validator: (value) => value == null ? 'Required' : null,
                                  ),
                               ],
                             ),
                           ),
                         ],
                       ),
                      const SizedBox(height: 20),

                      _buildLabel(theme, "Date of Birth"),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: IgnorePointer( // To propagate tap to InkWell
                          child: TextFormField(
                            controller: TextEditingController(
                                text: _dob == null
                                    ? ''
                                    : DateFormat('MMMM d, yyyy').format(_dob!)),
                             style: theme.textTheme.bodyLarge,
                            decoration: const InputDecoration(
                              hintText: "Select Date",
                              suffixIcon: Icon(Icons.calendar_today_rounded, size: 20),
                            ),
                            validator: (value) => _dob == null ? 'Required' : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Button
                      SizedBox(
                        width: double.infinity,
                        height: 56, // Taller button
                        child: FilledButton(
                          onPressed: _submitForm,
                          child: const Text('Register'),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildLabel(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.textTheme.bodyMedium?.color,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
