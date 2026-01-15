import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'player_list_screen.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: null,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.nightlight_round),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleTheme(!isDarkMode(context));
            },
          ),
        ],
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back,",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            Text(
              "Manager", // Placeholder name
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildDashboardItem(
                    context,
                    title: "Run Scorer",
                    icon: Icons.sports_cricket_outlined,
                    color: Colors.orange,
                    onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Run Scorer: Coming Soon!")),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    context,
                    title: "Players",
                    icon: Icons.groups_outlined,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlayerListScreen()),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    context,
                    title: "Teams",
                    icon: Icons.shield_outlined,
                    color: Colors.redAccent,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Teams: Coming Soon!")),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    context,
                    title: "Tournaments",
                    icon: Icons.emoji_events_outlined,
                    color: Colors.amber,
                    onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Tournaments: Coming Soon!")),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    context,
                    title: "Auction",
                    icon: Icons.gavel_outlined,
                    color: Colors.purple,
                    onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Auction: Coming Soon!")),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    context,
                    title: "Settings",
                    icon: Icons.settings_outlined,
                    color: Colors.grey,
                    onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Settings: Coming Soon!")),
                      );
                    },
                  ),
                  _buildDashboardItem(
                    context,
                    title: "Users",
                    icon: Icons.person_pin_outlined,
                    color: Colors.green,
                    onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Users: Coming Soon!")),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget _buildDashboardItem(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
