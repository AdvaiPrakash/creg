import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Placeholder data for the "Manager"
  final _nameController = TextEditingController(text: "Manager Name");
  final _emailController = TextEditingController(text: "manager@example.com");
  final _phoneController = TextEditingController(text: "+91 9876543210");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader(theme, "Appearance"),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: SwitchListTile(
              secondary: Icon(
                isDark ? Icons.light_mode_rounded : Icons.nightlight_round,
                color: theme.iconTheme.color,
              ),
              title: Text("Dark Mode", style: theme.textTheme.bodyLarge),
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
          
          const SizedBox(height: 30),
          _buildSectionHeader(theme, "Profile"),
          const SizedBox(height: 10),
          // Name Field
          _buildTextField(theme, "Name", _nameController, Icons.person_outline),
          const SizedBox(height: 16),
          // Email Field
          _buildTextField(theme, "Email", _emailController, Icons.email_outlined),
          const SizedBox(height: 16),
          // Phone Field
          _buildTextField(theme, "Phone Number", _phoneController, Icons.phone_outlined),

          const SizedBox(height: 30),
          _buildSectionHeader(theme, "Security"),
          const SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.lock_reset, color: theme.iconTheme.color),
              title: Text("Reset Password", style: theme.textTheme.bodyLarge),
              subtitle: Text("Send password reset email", style: theme.textTheme.bodySmall),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showResetPasswordDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(ThemeData theme, String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller, // Read-only for now effectively as we don't save
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: theme.cardColor,
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: Text("Send password reset link to ${_emailController.text}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementation would go here:
              // FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password reset email sent (simulation)")),
              );
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }
}
