import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

enum MessageFilter { all, unread }

class _MessagePageState extends State<MessagePage> {
  List<Map<String, dynamic>> messages = [
    {
      'id': 1,
      'name': 'Dr. Sarah Williams',
      'lastMessage': 'How are you today? 😊',
      'time': DateTime.now().subtract(const Duration(minutes: 10)),
      'unread': true,
      'online': true,
      'messageType': 'text',
      'animation': 'assets/profileanimate.json',
    },
    {
      'id': 2,
      'name': 'Dr. Michael Lee',
      'lastMessage': 'Let’s catch up tomorrow.',
      'time': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      'unread': false,
      'online': false,
      'messageType': 'text',
      'animation': 'assets/profileanimate.json',
    },
    {
      'id': 3,
      'name': 'Dr. Emily Johnson',
      'lastMessage': 'Sent you the file. 📁',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'unread': true,
      'online': false,
      'messageType': 'file',
      'animation': 'assets/profileanimate.json',
    },
  ];

  String searchText = '';
  MessageFilter currentFilter = MessageFilter.all;

  int _selectedIndex = 0;

  String formatTimeAgo(DateTime time) {
    return timeago.format(time);
  }

  void deleteMessage(int id) {
    setState(() {
      messages.removeWhere((msg) => msg['id'] == id);
    });
  }

  void toggleReadStatus(int id) {
    setState(() {
      final msg = messages.firstWhere((msg) => msg['id'] == id);
      msg['unread'] = !(msg['unread'] ?? false);
    });
  }

  void _onNavItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Already on MessagePage, do nothing or reload if you want
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    List<Map<String, dynamic>> filtered = messages.where((m) {
      final matchesSearch =
          m['name'].toLowerCase().contains(searchText.toLowerCase());
      final matchesFilter = currentFilter == MessageFilter.all ||
          (currentFilter == MessageFilter.unread && (m['unread'] ?? false));
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.blue[800],
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[850] : Colors.blue[700],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Messages',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<MessageFilter>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (value) {
              setState(() {
                currentFilter = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: MessageFilter.all,
                child: Text('All Messages',
                    style: GoogleFonts.poppins(
                        fontWeight: currentFilter == MessageFilter.all
                            ? FontWeight.bold
                            : FontWeight.normal)),
              ),
              PopupMenuItem(
                value: MessageFilter.unread,
                child: Text('Unread Only',
                    style: GoogleFonts.poppins(
                        fontWeight: currentFilter == MessageFilter.unread
                            ? FontWeight.bold
                            : FontWeight.normal)),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.blue[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  style: GoogleFonts.poppins(color: Colors.white),
                  onChanged: (value) {
                    setState(() => searchText = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search therapist...',
                    hintStyle: GoogleFonts.poppins(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/emptybox.json',
                            width: 250,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "You have no messages yet.\nStart a conversation!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        return Dismissible(
                          key: Key(item['id'].toString()),
                          background: slideRightBackground(),
                          secondaryBackground: slideLeftBackground(),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              final res = await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content:
                                      Text('Delete chat with ${item['name']}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (res == true) {
                                deleteMessage(item['id']);
                                return true;
                              } else {
                                return false;
                              }
                            } else {
                              toggleReadStatus(item['id']);
                              return false;
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/chat_detail',
                                arguments: item,
                              );
                              if (item['unread'] == true) {
                                toggleReadStatus(item['id']);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey[800]
                                    : Colors.blue[600],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isDark
                                                ? Colors.tealAccent
                                                : Colors.white,
                                            width: 3,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: Lottie.asset(
                                            item['animation'] ??
                                                'assets/profileanimate.json',
                                            fit: BoxFit.cover,
                                            repeat: true,
                                          ),
                                        ),
                                      ),
                                      if (item['online'] == true)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: Colors.greenAccent,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isDark
                                                    ? Colors.grey[900]!
                                                    : Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item['name'],
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (item['unread'] == true)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 6),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  'Unread',
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _shortenText(
                                                    item['lastMessage'], 40),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white70,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            _iconByMessageType(
                                                item['messageType']),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        formatTimeAgo(item['time']),
                                        style: GoogleFonts.poppins(
                                          color: Colors.white60,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? Colors.tealAccent[700] : Colors.white,
        foregroundColor: isDark ? Colors.black : Colors.blueAccent,
        icon: const Icon(Icons.chat_bubble_outline, size: 24),
        label: Text(
          'New Chat',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 6,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: isDark ? Colors.grey[850] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  'Start New Chat',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                content: Text(
                  'This feature is coming soon!\nStay tuned for updates 😊',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          isDark ? Colors.tealAccent : Colors.blueAccent,
                      textStyle:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        margin: const EdgeInsets.all(12),
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
                          color: _selectedIndex == 0
                              ? Colors.white
                              : Colors.white54,
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
                            color: _selectedIndex == 2
                                ? Colors.white
                                : Colors.blue[600],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 28,
                            color: _selectedIndex == 2
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
                    ),
                    child: Icon(
                      Icons.home,
                      size: 28,
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
    );
  }

  String _shortenText(String text, int maxLen) {
    if (text.length <= maxLen) return text;
    return '${text.substring(0, maxLen)}...';
  }

  Widget _iconByMessageType(String type) {
    switch (type) {
      case 'text':
        return const SizedBox.shrink();
      case 'file':
        return const Icon(Icons.attach_file, color: Colors.white70, size: 16);
      case 'audio':
        return const Icon(Icons.mic, color: Colors.white70, size: 16);
      case 'image':
        return const Icon(Icons.image, color: Colors.white70, size: 16);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        children: const [
          Icon(Icons.mark_email_read, color: Colors.white),
          SizedBox(width: 8),
          Text('Mark Read/Unread',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(width: 8),
          Text('Delete',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
