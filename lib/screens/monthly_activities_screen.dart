import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class MonthlyActivitiesScreen extends StatefulWidget {
  const MonthlyActivitiesScreen({super.key});

  @override
  State<MonthlyActivitiesScreen> createState() => _MonthlyActivitiesScreenState();
}

class _MonthlyActivitiesScreenState extends State<MonthlyActivitiesScreen> {
  DateTime _selectedMonth = DateTime.now();
  Map<DateTime, Map<String, dynamic>> _activities = {};
  Map<String, double> _monthlyTotals = {};

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final activitiesJson = prefs.getString('activities');
    if (activitiesJson != null) {
      final Map<String, dynamic> activitiesMap = json.decode(activitiesJson);
      setState(() {
        _activities = activitiesMap.map(
          (key, value) => MapEntry(DateTime.parse(key), Map<String, dynamic>.from(value)),
        );
      });
      _calculateMonthlyTotals();
    }
  }

  void _calculateMonthlyTotals() {
    final monthKey = DateFormat('yyyy-MM').format(_selectedMonth);
    _monthlyTotals.clear();
    
    final activityKeys = ['quran', 'hadith', 'literature', 'salat', 'study', 'friends', 'workings', 'criticism'];
    
    for (String key in activityKeys) {
      _monthlyTotals[key] = 0.0;
    }
    
    _activities.forEach((date, activity) {
      if (DateFormat('yyyy-MM').format(date) == monthKey) {
        for (String key in activityKeys) {
          final value = activity[key];
          if (value is int) {
            _monthlyTotals[key] = _monthlyTotals[key]! + value;
          } else if (value is double) {
            _monthlyTotals[key] = _monthlyTotals[key]! + value;
          }
        }
      }
    });
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: AppBar(
        title: const Text('Monthly Activities'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Month selector
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D6B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.bar_chart,
                          color: Color(0xFF2E7D6B),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Monthly Activities',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D6B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: Color(0xFF2E7D6B)),
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
                            _calculateMonthlyTotals();
                          });
                        },
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(_selectedMonth),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D6B),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, color: Color(0xFF2E7D6B)),
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
                            _calculateMonthlyTotals();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Monthly totals
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
                            color: const Color(0xFF4A90A4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.analytics,
                            color: Color(0xFF4A90A4),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Monthly Totals',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D6B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Activity totals grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      children: [
                        _buildTotalCard('Quran Reading', _monthlyTotals['quran'] ?? 0, Icons.menu_book, const Color(0xFF2E7D6B)),
                        _buildTotalCard('Hadith Study', _monthlyTotals['hadith'] ?? 0, Icons.auto_stories, const Color(0xFF4A90A4)),
                        _buildTotalCard('Islamic Literature', _monthlyTotals['literature'] ?? 0, Icons.library_books, const Color(0xFF6B9BD2)),
                        _buildTotalCard('Salat (Prayers)', _monthlyTotals['salat'] ?? 0, Icons.mosque, const Color(0xFF8B7ED8)),
                        _buildTotalCard('Academic Study', _monthlyTotals['study'] ?? 0, Icons.school, const Color(0xFF9C27B0)),
                        _buildTotalCard('Friends & Social', _monthlyTotals['friends'] ?? 0, Icons.people, const Color(0xFFE91E63)),
                        _buildTotalCard('Work Activities', _monthlyTotals['workings'] ?? 0, Icons.work, const Color(0xFFFF5722)),
                        _buildTotalCard('Self Criticism', _monthlyTotals['criticism'] ?? 0, Icons.psychology, const Color(0xFF607D8B)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Daily activities list
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
                            color: const Color(0xFF6B9BD2).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.list,
                            color: Color(0xFF6B9BD2),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Daily Activities',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D6B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Daily activities
                    ..._getDailyActivities().map((activity) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, d MMMM, yyyy').format(activity['date']),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E7D6B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _buildActivityChip('Quran', activity['quran']),
                              _buildActivityChip('Hadith', activity['hadith']),
                              _buildActivityChip('Literature', activity['literature']),
                              _buildActivityChip('Salat', activity['salat']),
                              _buildActivityChip('Study', activity['study']),
                              _buildActivityChip('Friends', activity['friends']),
                              _buildActivityChip('Work', activity['workings']),
                              _buildActivityChip('Criticism', activity['criticism']),
                            ],
                          ),
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
      ),
    );
  }

  Widget _buildTotalCard(String title, double total, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2E7D6B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            total.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChip(String label, dynamic value) {
    final numValue = value is int ? value.toDouble() : (value is double ? value : 0.0);
    final color = numValue > 0 ? const Color(0xFF4CAF50) : Colors.grey;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Text(
        '$label: ${numValue.toStringAsFixed(0)}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getDailyActivities() {
    final monthKey = DateFormat('yyyy-MM').format(_selectedMonth);
    final activities = <Map<String, dynamic>>[];
    
    _activities.forEach((date, activity) {
      if (DateFormat('yyyy-MM').format(date) == monthKey) {
        activities.add({
          'date': date,
          'quran': activity['quran'] ?? 0,
          'hadith': activity['hadith'] ?? 0,
          'literature': activity['literature'] ?? 0,
          'salat': activity['salat'] ?? 0,
          'study': activity['study'] ?? 0,
          'friends': activity['friends'] ?? 0,
          'workings': activity['workings'] ?? 0,
          'criticism': activity['criticism'] ?? 0,
        });
      }
    });
    
    activities.sort((a, b) => b['date'].compareTo(a['date']));
    return activities;
  }
}
