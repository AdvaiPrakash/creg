import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/player_model.dart';
import 'register_player_screen.dart';

class PlayerProfileScreen extends StatelessWidget {
  final Player player;

  const PlayerProfileScreen({super.key, required this.player});




  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isImageAvailable = player.imageBase64 != null && player.imageBase64!.isNotEmpty;

    // Use theme colors
    final primaryAccent = theme.primaryColor;
    final cardColor = isDark ? theme.colorScheme.surface : const Color(0xFF0B1221);
    final cardTextColor = isDark ? theme.textTheme.bodyLarge?.color : Colors.white; 
    
    return Scaffold(
      // Background handled by theme
      body: Stack(
        children: [
          // 1. Top Decorative Background (Half Circle / Splash)
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: size.width * 1.2,
              height: size.width * 1.2,
              decoration: BoxDecoration(
                color: primaryAccent.withOpacity(0.1), // Very subtle tint
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 2. Custom App Bar


          // 4. Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.1), // Spacing from top

                // Large Player Image (Rotated Plate Style)
                Center(
                  child: Container(
                    width: size.width * 0.7,
                    height: size.width * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      image: isImageAvailable
                          ? DecorationImage(
                              image: MemoryImage(base64Decode(player.imageBase64!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: isImageAvailable ? null : theme.colorScheme.surface,
                      border: Border.all(
                        color: theme.dividerColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                     child: !isImageAvailable
                        ? Center(
                            child: Text(
                              player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                              style: TextStyle(fontSize: 60, color: theme.disabledColor),
                            ),
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 40),

                // Overlapping Card
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Role Label (Small Ticket Style)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _determineRole(player),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Use Black on Neon Lime for contrast
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Player Name
                      Text(
                        player.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: cardTextColor,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Subtitle
                      Text(
                        "Registered Player",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Details List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Player Statistics",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      


                      _buildDetailItem(
                        context,
                        icon: Icons.sports_cricket,
                        label: "Batting Style",
                        value: player.battingHand ?? "Not Specified",
                        color: isDark ? const Color(0xFF3E2723) : const Color(0xFFFFF4E0), // Darker/Lighter Orange bg
                        iconColor: Colors.orange,
                      ),
                      _buildDetailItem(
                        context,
                        icon: Icons.circle_outlined,
                        label: "Bowling Style",
                        value: player.bowlingHand ?? "Not Specified",
                        color: isDark ? const Color(0xFF006064) : const Color(0xFFE0F7FA), // Darker/Lighter Cyan bg
                        iconColor: Colors.cyan,
                      ),
                      _buildDetailItem(
                        context,
                        icon: Icons.cake,
                        label: "Age",
                        value: player.dob != null 
                            ? "${_calculateAge(player.dob!)} Years" 
                            : "Not Specified",
                        color: isDark ? const Color(0xFF4A148C) : const Color(0xFFF3E5F5), // Darker/Lighter Purple bg
                        iconColor: Colors.purple,
                      ),
                      _buildDetailItem(
                        context,
                        icon: Icons.email_outlined,
                        label: "Email",
                        value: player.email,
                        color: isDark ? const Color(0xFF004D40) : const Color(0xFFE0F2F1), // Teal
                        iconColor: Colors.teal,
                      ),
                       _buildDetailItem(
                        context,
                        icon: Icons.contact_phone,
                        label: "Contact",
                        value: player.phone,
                        color: isDark ? const Color(0xFF1B5E20) : const Color(0xFFE8F5E9), // Darker/Lighter Green bg
                        iconColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),

          // Back Button (Moved to top of stack for z-index)
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: theme.canvasColor,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 4. Bottom Floating Action Button (Edit)
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: SizedBox(
               height: 60,
               child: ElevatedButton(
                 onPressed: () async {
                   await Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => RegisterPlayerScreen(player: player)),
                   );
                   if (context.mounted) Navigator.pop(context);
                 },
                 style: ElevatedButton.styleFrom(
                   backgroundColor: primaryAccent,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                   elevation: 4,
                   shadowColor: primaryAccent.withOpacity(0.4),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(
                       "Edit Profile",
                       style: GoogleFonts.inter(
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                         color: Colors.black, // Dark text on Neon
                       ),
                     ),
                     const SizedBox(width: 8),
                     const Icon(Icons.edit, color: Colors.black),
                   ],
                 ),
               ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  String _determineRole(Player player) {
    if (player.role != null && player.role!.isNotEmpty) return player.role!;
    if (player.battingHand != null && player.bowlingHand != null) return "All Rounder";
    if (player.battingHand != null) return "Batsman";
    if (player.bowlingHand != null) return "Bowler";
    return "Player";
  }

  Widget _buildDetailItem(BuildContext context, {required IconData icon, required String label, required String value, required Color color, required Color iconColor}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor, // Use theme card color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
        ]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
