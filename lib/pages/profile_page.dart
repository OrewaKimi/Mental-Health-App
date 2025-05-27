import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = true;
  bool isNotificationsOn = true;
  bool aboutExpanded = false;

  int _selectedIndex = 2; // Profile page index

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Add logout logic here
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Help & Support',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'For assistance, please contact support@yourapp.com or call +62 812 3456 7890.\n\n'
              'You can also visit our FAQ page in the app settings.',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[800]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showModeChangeDialog(String mode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$mode Mode'),
        content: Text('$mode mode has been ${mode == "Dark" ? (isDarkMode ? "enabled" : "disabled") : (isNotificationsOn ? "enabled" : "disabled")}.'),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
        ],
      ),
    );
  }

  void _onNavItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    switch(index) {
      case 0:
        Navigator.pushNamed(context, '/message'); // <- perbaikan route: /message (bukan /messages)
        break;
      case 1:
        Navigator.pushNamed(context, '/home');
        break;
      case 2:
        // Profile, stay here
        break;
    }
  }

  Widget _buildSocialIcon(IconData icon, String tooltip, VoidCallback onTap) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blue900 = Colors.blue[900]!;
    final blue600 = Colors.blue[600]!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue[800],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0,
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          // TODO: Add Support Chat Functionality
        },
        icon: const Icon(Icons.chat_bubble_outline, color: Colors.blue),
        label: Text(
          'Support',
          style: GoogleFonts.poppins(color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth < 600 ? 24 : 80, vertical: 30),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F8FF),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Transform.scale(
                        scale: 1.4,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: Lottie.asset(
                              'assets/profileanimate.json',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Kimi Maulana', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: blue900)),
                  const SizedBox(height: 4),
                  Text('kimimaulana@icloud.com', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
                  const SizedBox(height: 12),
                  AnimatedCrossFade(
                    firstChild: Text(
                      'Flutter Developer | Tech Enthusiast | Coffee Lover',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                    secondChild: Text(
                      'Flutter Developer | Tech Enthusiast | Coffee Lover. Passionate about creating beautiful and functional apps. Loves to explore new tech trends and share knowledge with the community.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
                    ),
                    crossFadeState: aboutExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  TextButton(
                    onPressed: () => setState(() => aboutExpanded = !aboutExpanded),
                    child: Text(aboutExpanded ? 'Show less' : 'Read more', style: GoogleFonts.poppins(color: blue600, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBadge(Icons.star, 'Top Contributor'),
                      const SizedBox(width: 12),
                      _buildBadge(Icons.verified, 'Verified User'),
                      const SizedBox(width: 12),
                      _buildBadge(Icons.school, 'Mentor'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[200],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      // TODO: Navigate to Edit Profile
                    },
                    icon: const Icon(Icons.edit, color: Colors.black87, size: 18),
                    label: const Text("Edit Profile", style: TextStyle(color: Colors.black87, fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon(FontAwesomeIcons.globe, 'Website', () {}),
                const SizedBox(width: 16),
                _buildSocialIcon(Icons.email, 'Email', () {}),
                const SizedBox(width: 16),
                _buildSocialIcon(FontAwesomeIcons.linkedin, 'LinkedIn', () {}),
                const SizedBox(width: 16),
                _buildSocialIcon(FontAwesomeIcons.twitter, 'Twitter', () {}),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Profile Completeness', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: 0.8, backgroundColor: Colors.white24, color: Colors.amberAccent, minHeight: 8),
                  const SizedBox(height: 8),
                  Text('80% complete — Add a bio and phone number', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildOptionTile(icon: Icons.dark_mode, title: 'Dark Mode', trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() => isDarkMode = value);
                _showModeChangeDialog('Dark');
              },
              activeColor: Colors.blue[100],
            )),
            _buildOptionTile(icon: Icons.notifications, title: 'Notifications', trailing: Switch(
              value: isNotificationsOn,
              onChanged: (value) {
                setState(() => isNotificationsOn = value);
                _showModeChangeDialog('Notification');
              },
              activeColor: Colors.blue[100],
            )),
            _buildOptionTile(icon: Icons.link, title: 'Connected: Google', trailing: const Icon(Icons.check_circle, color: Colors.greenAccent), onTap: () {}),
            _buildOptionTile(icon: Icons.help_outline, title: 'Help & Support', onTap: () => _showHelpSupport(context)),
            _buildOptionTile(icon: Icons.logout, title: 'Logout', trailing: const Icon(Icons.exit_to_app, color: Colors.redAccent), onTap: () => _showLogoutConfirmation(context)),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue[700],
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 68,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _onNavItemTapped(0),
                          child: Icon(
                            Icons.message,
                            size: 28,
                            color:
                                _selectedIndex == 0 ? Colors.white : Colors.white54,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 68),
                    SizedBox(
                      width: 68,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _onNavItemTapped(2),
                          child: Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: _selectedIndex == 2 ? Colors.white : Colors.blue[600],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 28,
                              color: _selectedIndex == 2 ? Colors.blue[700] : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () => _onNavItemTapped(1),
                    child: Container(
                      height: 68,
                      width: 68,
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1 ? Colors.white : Colors.blue[600],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.home,
                        size: 28,
                        color: _selectedIndex == 1 ? Colors.blue[700] : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amberAccent.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.poppins(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildOptionTile({required IconData icon, required String title, Widget? trailing, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
        trailing: trailing,
        onTap: onTap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
