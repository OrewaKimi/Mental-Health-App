import 'package:flutter/material.dart';
import 'package:mentalhealthapp/pages/chat_detail_page.dart';
import 'package:mentalhealthapp/pages/login_page.dart';
import 'package:mentalhealthapp/pages/message_page.dart';
import 'package:mentalhealthapp/pages/home_page.dart';
import 'package:mentalhealthapp/pages/profile_page.dart';

void main() {
  runApp(const MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {
  const MentalHealthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mental Health App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/message': (context) => const MessagePage(),
        '/chat_detail': (context) => const ChatDetailPage(therapistName: 'Therapist A'),
        '/profile': (context) => const ProfilePage(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('404 - Page Not Found')),
        ),
      ),
    );
  }
}

class InteractiveBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const InteractiveBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  State<InteractiveBottomNavBar> createState() => _InteractiveBottomNavBarState();
}

class _InteractiveBottomNavBarState extends State<InteractiveBottomNavBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _hoverAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _onHover(bool hovering) {
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = widget.currentIndex == index;
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, -_hoverAnimation.value),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.white54, size: isSelected ? 30 : 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blue[700],
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.message, 0),
            _buildNavItem(Icons.favorite, 1),
            _buildNavItem(Icons.home, 2),
            _buildNavItem(Icons.person, 3),
          ],
        ),
      ),
    );
  }
}

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _selectedIndex = 2; // Home

  final List<Widget> _pages = const [
    MessagePage(),
    Placeholder(), // Replace with your Save/Favorite Page
    HomePage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: InteractiveBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
