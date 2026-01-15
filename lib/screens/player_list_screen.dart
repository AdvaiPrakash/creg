import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/player_model.dart';
import '../services/firebase_service.dart';
import 'player_profile_screen.dart';
import 'register_player_screen.dart';

class PlayerListScreen extends StatelessWidget {
  PlayerListScreen({super.key});

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _deletePlayer(BuildContext context, Player player) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.brightness == Brightness.dark ? const Color(0xFF162032) : Colors.white,
        title: Text('Delete Player', style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
        content: Text(
          'Are you sure you want to delete ${player.name}?',
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && player.id != null) {
      try {
        await _firebaseService.deletePlayer(player.id!);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Player deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting player: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // backgroundColor handled by theme
      appBar: AppBar(
        title: Text(
          'Our Players',
          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: 24, // Adjusted for AppBar
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: StreamBuilder<List<Player>>(
        stream: _firebaseService.getPlayers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final players = snapshot.data ?? [];
          if (players.isEmpty) {
            return const Center(child: Text('No players registered yet.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 Columns
              childAspectRatio: 0.70, // Tall cards
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return _buildPlayerCard(context, player);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPlayerScreen()),
          );
        },
        backgroundColor: theme.primaryColor,
        child: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
      ),
    );
  }

  Widget _buildPlayerCard(BuildContext context, Player player) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasImage = player.imageBase64 != null && player.imageBase64!.isNotEmpty;
    
    final cardColor = isDark ? theme.colorScheme.surface : Colors.white;
    final textColor = theme.textTheme.bodyLarge?.color;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge, // To clip image to border
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Image Section (Top Half)
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              child: hasImage
                  ? Image.memory(
                      base64Decode(player.imageBase64!),
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Text(
                        player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                        style: GoogleFonts.inter(
                          fontSize: 40, 
                          color: isDark ? Colors.grey[600] : Colors.grey[400]
                        ),
                      ),
                    ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _deletePlayer(context, player),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

          // 2. Info Section (Bottom Half)
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Name Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          player.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.green, size: 16),
                    ],
                  ),
                  
                  // Description / Role
                  Text(
                    _getRoleText(player),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      height: 1.2,
                    ),
                  ),

                  // Stats / Icons Row (Small)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(Icons.cake, size: 14, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                       const SizedBox(width: 4),
                         Text(
                         player.dob != null ? "${_calculateAge(player.dob!)}" : "-",
                         style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                       ),
                       const SizedBox(width: 12),
                       Icon(Icons.sports_cricket, size: 14, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                       const SizedBox(width: 4),
                       Text(
                         "Pro", // Placeholder or logic
                         style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                       ),
                    ],
                  ),

                  // Action Button (Pill Shape)
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerProfileScreen(player: player),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: isDark ? theme.colorScheme.onPrimary : Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        "View Profile",
                        style: GoogleFonts.inter(
                          fontSize: 12, 
                          fontWeight: FontWeight.w600,
                          color: isDark ? theme.colorScheme.background : Colors.black, // Ensure contrast
                        ),
                      ),
                    ),
                    
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleText(Player player) {
    if (player.role != null && player.role!.isNotEmpty) {
      return player.role!;
    }
    final bat = player.battingHand ?? "";
    final bowl = player.bowlingHand ?? "";
    if (bat.isNotEmpty && bowl.isNotEmpty) return "$bat & $bowl";
    if (bat.isNotEmpty) return "Batsman • $bat";
    if (bowl.isNotEmpty) return "Bowler • $bowl";
    return "Cricket Player";
  }

  int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }
}
