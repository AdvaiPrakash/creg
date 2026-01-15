import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'player_list_screen.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: null, // No title as requested
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFF0F172A)]
                : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFF1F5F9)],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // 1. Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 100, 24, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back,",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: isDark 
                            ? [Colors.blueAccent, Colors.cyanAccent] 
                            : [theme.primaryColor, Colors.indigo],
                      ).createShader(bounds),
                      child: Text(
                        "Manager",
                        style: GoogleFonts.outfit(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Required for ShaderMask
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Primary Actions (Run Scorer & Players) - Side by Side
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85, // Taller cards
                children: [
                  _buildPrimaryCard(
                    context,
                    title: "Run Scorer",
                    subtitle: "Start Match",
                    icon: Icons.sports_cricket,
                    gradientColors: [const Color(0xFFFF8C00), const Color(0xFFFF0080)],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Run Scorer: Coming Soon!")),
                      );
                    },
                  ),
                  _buildPrimaryCard(
                    context,
                    title: "Players",
                    subtitle: "Manage Squad",
                    icon: Icons.groups,
                    gradientColors: [const Color(0xFF00C6FF), const Color(0xFF0072FF)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlayerListScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // 3. Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  "Management",
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                  ),
                ),
              ),
            ),

            // 4. Secondary Grid (Teams, Tournament, Auction, Users, Settings)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              sliver: SliverGrid.count(
                crossAxisCount: 3, // 3 columns for smaller items
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
                children: [
                  _buildSecondaryCard(context, "Teams", Icons.shield_outlined, Colors.redAccent, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Teams: Coming Soon!")),
                    );
                  }),
                  _buildSecondaryCard(context, "Tournaments", Icons.emoji_events_outlined, Colors.amber, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Tournaments: Coming Soon!")),
                    );
                  }),
                   _buildSecondaryCard(context, "Auction", Icons.gavel_outlined, Colors.purpleAccent, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Auction: Coming Soon!")),
                    );
                  }),
                   _buildSecondaryCard(context, "Users", Icons.person_pin_circle_outlined, Colors.teal, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Users: Coming Soon!")),
                    );
                  }),
                  _buildSecondaryCard(context, "Settings", Icons.tune, Colors.blueGrey, () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                  }),
                ],
              ),
            ),
             const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required List<Color> gradientColors, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.cardColor.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
          width: 1,
        ),
         boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
