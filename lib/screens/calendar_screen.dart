import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'activity_form_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, Map<String, dynamic>> _activities = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final activitiesJson = prefs.getString('activities');
    if (activitiesJson != null) {
      final Map<String, dynamic> activitiesMap = json.decode(activitiesJson);
      _activities = activitiesMap.map(
        (key, value) => MapEntry(DateTime.parse(key), Map<String, dynamic>.from(value)),
      );
      setState(() {});
    }
  }

  Future<void> _saveActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final activitiesMap = _activities.map(
      (key, value) => MapEntry(key.toIso8601String(), value),
    );
    await prefs.setString('activities', json.encode(activitiesMap));
  }

  List<Map<String, dynamic>> _getLast7DaysData() {
    final List<Map<String, dynamic>> data = [];
    final now = DateTime.now();
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      final activity = _activities[dateKey];
      
      data.add({
        'date': DateFormat('d MMM', 'bn').format(date),
        'quran': activity?['quran'] ?? 0,
        'hadith': activity?['hadith'] ?? 0,
        'literature': activity?['literature'] ?? 0,
        'salat': activity?['salat'] ?? 0,
        'study': activity?['study'] ?? 0,
        'friends': activity?['friends'] ?? 0,
        'workings': activity?['workings'] ?? 0,
        'criticism': activity?['criticism'] ?? 0,
        'isToday': i == 0,
      });
    }
    
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final last7DaysData = _getLast7DaysData();
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with Bismillah
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2E7D6B).withOpacity(0.1),
                  const Color(0xFF4A90A4).withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D6B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'পরম করুণাময় আল্লাহর নামে',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A90A4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Calendar section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Month header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: Color(0xFF2E7D6B)),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                          });
                        },
                      ),
                      Text(
                        DateFormat('MMMM yyyy', 'bn').format(_focusedDay),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D6B),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, color: Color(0xFF2E7D6B)),
                        onPressed: () {
                          setState(() {
                            _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                          });
                        },
                      ),
                    ],
                  ),
                  
                  // Calendar
                  TableCalendar<String>(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    eventLoader: (day) {
                      return [];
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      weekendTextStyle: const TextStyle(color: Color(0xFFE57373)),
                      defaultTextStyle: const TextStyle(color: Color(0xFF2E7D6B)),
                      selectedDecoration: BoxDecoration(
                        color: const Color(0xFF2E7D6B),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFF4A90A4),
                        shape: BoxShape.circle,
                      ),
                      markersMaxCount: 1,
                      markerDecoration: const BoxDecoration(
                        color: Color(0xFF6B9BD2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        _showActivityForm(selectedDay);
                      }
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    locale: 'bn_BD',
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Last 7 days summary
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D6B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.timeline,
                          color: Color(0xFF2E7D6B),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Last 7 Days Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D6B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Summary cards
                  ...last7DaysData.map((data) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: data['isToday'] == true 
                          ? const Color(0xFF2E7D6B).withOpacity(0.1)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: data['isToday'] == true 
                          ? Border.all(color: const Color(0xFF2E7D6B).withOpacity(0.3))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Text(
                                data['date'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: data['isToday'] == true 
                                      ? const Color(0xFF2E7D6B)
                                      : Colors.black87,
                                ),
                              ),
                              if (data['isToday'] == true)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E7D6B),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'Today',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(child: _buildActivityScore('Quran', data['quran'])),
                        Expanded(child: _buildActivityScore('Hadith', data['hadith'])),
                        Expanded(child: _buildActivityScore('Literature', data['literature'])),
                        Expanded(child: _buildActivityScore('Salat', data['salat'])),
                        Expanded(child: _buildActivityScore('Study', data['study'])),
                        Expanded(child: _buildActivityScore('Friends', data['friends'])),
                        Expanded(child: _buildActivityScore('Work', data['workings'])),
                        Expanded(child: _buildActivityScore('Criticism', data['criticism'])),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActivityScore(String label, int score) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: score > 0 ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            score.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: score > 0 ? const Color(0xFF4CAF50) : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  void _showActivityForm(DateTime selectedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityFormScreen(
          selectedDate: selectedDate,
          existingData: _activities[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)],
          onSave: (data) {
            setState(() {
              _activities[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)] = data;
            });
            _saveActivities();
          },
        ),
      ),
    );
  }
}
