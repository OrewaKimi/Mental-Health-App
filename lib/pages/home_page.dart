import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:mentalhealthapp/pages/message_page.dart';
import 'package:mentalhealthapp/pages/profile_page.dart';
import 'package:mentalhealthapp/util/emoticon_face.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<dynamic> exercises = [];
  List<dynamic> filteredExercises = [];
  final Map<int, bool> _expanded = {};
  final Map<int, double> _progress = {};
  String moodText = '';
  bool showMoodResponse = false;
  final TextEditingController searchController = TextEditingController();
  int unreadNotificationCount = 3;

  int _selectedIndex = 1; // Home di tengah = index 1

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadExercises() async {
    try {
      final jsonString = await rootBundle.loadString('assets/exercise.json');
      final List<dynamic> data = json.decode(jsonString);
      setState(() {
        exercises = data;
        filteredExercises = data;
        for (int i = 0; i < exercises.length; i++) {
          _expanded[i] = false;
          _progress[i] = 0.0;
        }
      });
    } catch (e) {
      debugPrint('Error loading exercises JSON: $e');
    }
  }

  void _filterExercises(String query) {
    setState(() {
      filteredExercises = exercises
          .where((exercise) => exercise['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _increaseProgress(int index, int totalTasks) {
    setState(() {
      double currentProgress = _progress[index] ?? 0.0;
      double newProgress = currentProgress + (1 / totalTasks);
      _progress[index] = newProgress.clamp(0.0, 1.0);
    });
  }

  void showMoodDialog(String emoticon) {
    String label = '';
    String message = '';

    switch (emoticon) {
      case '😫':
        label = 'Bad';
        message = 'Don\'t worry, it\'s okay to have tough days. Keep pushing!';
        break;
      case '😐':
        label = 'Fine';
        message = 'You\'re doing alright! Keep up the steady pace.';
        break;
      case '😃':
        label = 'Well';
        message = 'Great to hear you\'re feeling good! Keep shining!';
        break;
      case '🥳':
        label = 'Excellent';
        message = 'Awesome! Keep spreading your positive vibes!';
        break;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$emoticon  $label', style: GoogleFonts.poppins()),
          content: Text(message, style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  moodText = label;
                  showMoodResponse = true;
                });
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  void _showNotifications() {
    setState(() {
      unreadNotificationCount = 0;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Notifications', style: GoogleFonts.poppins()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.notifications),
                title: Text('You have completed 3 exercises today!',
                    style: GoogleFonts.poppins()),
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: Text('New exercise: Mindfulness Added',
                    style: GoogleFonts.poppins()),
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: Text('Don’t forget to log your mood!',
                    style: GoogleFonts.poppins()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  void _onNavItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MessagePage()),
      );
    } else if (index == 1) {
      // Home, tetap di halaman ini
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
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
              Row(
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
                  SizedBox(width: 68), // spacer tengah
                  SizedBox(
                    width: 68,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _onNavItemTapped(2),
                        child: Icon(
                          Icons.person,
                          size: 28,
                          color:
                              _selectedIndex == 2 ? Colors.white : Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ],
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
                        color: _selectedIndex == 1
                            ? Colors.white
                            : Colors.blue[600],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.home,
                        size: 36,
                        color: _selectedIndex == 1
                            ? Colors.blue[700]
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Kimi Maulana!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '15 May, 2025',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _showNotifications,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child:
                              const Icon(Icons.notifications, color: Colors.white),
                        ),
                        if (unreadNotificationCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints:
                                  const BoxConstraints(minWidth: 20, minHeight: 20),
                              child: Center(
                                child: Text(
                                  '$unreadNotificationCount',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: _filterExercises,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search exercises...',
                        hintStyle: GoogleFonts.poppins(color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  Text(
                    'How do you feel?',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMood('😫', 'Bad'),
                  _buildMood('😐', 'Fine'),
                  _buildMood('😃', 'Well'),
                  _buildMood('🥳', 'Excellent'),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Exercises',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: filteredExercises.isEmpty
                          ? Center(
                              child: Text(
                                'No exercises found',
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredExercises.length,
                              itemBuilder: (context, index) {
                                final item = filteredExercises[index];
                                bool isExpanded = _expanded[index] ?? false;
                                int total = item['count'];
                                List<String> details = List.generate(
                                  total,
                                  (i) => '${item['name']} Task ${i + 1}',
                                );
                                double progress = _progress[index] ?? 0.0;
                                Color baseColor =
                                    Color(int.parse(item['color'].toString()));
                                Color expandedBgColor =
                                    baseColor.withOpacity(0.15);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: isExpanded
                                          ? expandedBgColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () {
                                          setState(() {
                                            _expanded[index] = !isExpanded;
                                          });
                                        },
                                        splashColor: baseColor.withOpacity(0.3),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    _getIcon(item['icon']),
                                                    color: baseColor,
                                                    size: 30,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item['name'],
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        '$total exercises',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          color: Colors.grey[700],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      SizedBox(
                                                        width: 150,
                                                        height: 6,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(3),
                                                          child: LinearProgressIndicator(
                                                            value: progress,
                                                            color: baseColor,
                                                            backgroundColor:
                                                                baseColor.withOpacity(0.2),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        '${(progress * 100).toInt()}%',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          color: Colors.black54,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              AnimatedRotation(
                                                turns: isExpanded ? 0.5 : 0,
                                                duration:
                                                    const Duration(milliseconds: 300),
                                                child: Icon(
                                                  Icons.expand_more,
                                                  color: baseColor,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    AnimatedSize(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      child: ConstrainedBox(
                                        constraints: isExpanded
                                            ? const BoxConstraints()
                                            : const BoxConstraints(maxHeight: 0),
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(top: 6, bottom: 15),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: expandedBgColor,
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: details
                                                .map(
                                                  (detail) => GestureDetector(
                                                    onTap: () =>
                                                        _increaseProgress(index, total),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 6.0),
                                                      child: Text(
                                                        detail,
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 16,
                                                          color: Colors.blueGrey[900],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMood(String emoji, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => showMoodDialog(emoji),
          child: EmoticonFace(emotionface: emoji),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'favorite':
        return Icons.favorite;
      case 'book':
        return Icons.book;
      case 'create':
        return Icons.create;
      case 'headphones':
        return Icons.headphones;
      case 'lightbulb':
        return Icons.lightbulb;
      default:
        return Icons.help_outline;
    }
  }
}
