import 'package:flutter/material.dart';
import 'prayer_times_screen.dart';
import 'custom_reminder_screen.dart';
import 'calendar_screen.dart';
import 'daily_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PrayerTimesScreen(),
    const CustomReminderScreen(),
    const CalendarScreen(),
    const DailyEntryScreen(),
  ];

  final List<String> _titles = [
    'নামাজের সময়সূচী',
    'কাস্টম রিমাইন্ডার',
    'মাসিক পরিকল্পনা',
    'দৈনিক এন্ট্রি',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: Colors.green,
              size: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'ইসলামী দৈনিক ট্র্যাকার',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.blue,
            ),
            onPressed: () {
              _showMenu(context);
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.mosque),
            label: 'নামাজ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'রিমাইন্ডার',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'ক্যালেন্ডার',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'এন্ট্রি',
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'মেনু',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuOption(
                Icons.home,
                'হোম',
                () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              _buildMenuOption(
                Icons.mosque,
                'নামাজের সময়সূচী',
                () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              _buildMenuOption(
                Icons.alarm,
                'কাস্টম রিমাইন্ডার',
                () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
              _buildMenuOption(
                Icons.calendar_month,
                'মাসিক পরিকল্পনা',
                () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
              _buildMenuOption(
                Icons.bar_chart,
                'মাসিক অগ্রগতি',
                () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }
}
