import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class MonthlyProgressScreen extends StatefulWidget {
  const MonthlyProgressScreen({super.key});

  @override
  State<MonthlyProgressScreen> createState() => _MonthlyProgressScreenState();
}

class _MonthlyProgressScreenState extends State<MonthlyProgressScreen> {
  DateTime _selectedMonth = DateTime.now();
  Map<DateTime, Map<String, dynamic>> _activities = {};
  Map<String, Map<String, dynamic>> _monthlyPlans = {};
  Map<String, double> _currentMonthTotals = {};
  Map<String, double> _previousMonthTotals = {};
  Map<String, double> _monthlyGoals = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load activities
    final activitiesJson = prefs.getString('activities');
    if (activitiesJson != null) {
      final Map<String, dynamic> activitiesMap = json.decode(activitiesJson);
      setState(() {
        _activities = activitiesMap.map(
          (key, value) => MapEntry(DateTime.parse(key), Map<String, dynamic>.from(value)),
        );
      });
    }
    
    // Load monthly plans
    final plansJson = prefs.getString('monthly_plans');
    if (plansJson != null) {
      setState(() {
        _monthlyPlans = Map<String, Map<String, dynamic>>.from(
          json.decode(plansJson).map(
            (key, value) => MapEntry(key, Map<String, dynamic>.from(value)),
          ),
        );
      });
    }
    
    _calculateProgress();
  }

  void _calculateProgress() {
    final currentMonthKey = DateFormat('yyyy-MM').format(_selectedMonth);
    final previousMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    final previousMonthKey = DateFormat('yyyy-MM').format(previousMonth);
    
    _currentMonthTotals.clear();
    _previousMonthTotals.clear();
    _monthlyGoals.clear();
    
    final activityKeys = ['quran', 'hadith', 'literature', 'salat', 'study', 'friends', 'workings', 'criticism'];
    
    // Initialize totals
    for (String key in activityKeys) {
      _currentMonthTotals[key] = 0.0;
      _previousMonthTotals[key] = 0.0;
      _monthlyGoals[key] = 0.0;
    }
    
    // Calculate current month totals
    _activities.forEach((date, activity) {
      if (DateFormat('yyyy-MM').format(date) == currentMonthKey) {
        for (String key in activityKeys) {
          final value = activity[key];
          if (value is int) {
            _currentMonthTotals[key] = _currentMonthTotals[key]! + value;
          } else if (value is double) {
            _currentMonthTotals[key] = _currentMonthTotals[key]! + value;
          }
        }
      }
    });
    
    // Calculate previous month totals
    _activities.forEach((date, activity) {
      if (DateFormat('yyyy-MM').format(date) == previousMonthKey) {
        for (String key in activityKeys) {
          final value = activity[key];
          if (value is int) {
            _previousMonthTotals[key] = _previousMonthTotals[key]! + value;
          } else if (value is double) {
            _previousMonthTotals[key] = _previousMonthTotals[key]! + value;
          }
        }
      }
    });
    
    // Load monthly goals
    if (_monthlyPlans.containsKey(currentMonthKey)) {
      final plan = _monthlyPlans[currentMonthKey]!;
      for (String key in activityKeys) {
        final value = plan[key];
        if (value is int) {
          _monthlyGoals[key] = value.toDouble();
        } else if (value is double) {
          _monthlyGoals[key] = value;
        }
      }
    }
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: AppBar(
        title: const Text('Monthly Progress'),
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
                          Icons.trending_up,
                          color: Color(0xFF2E7D6B),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Monthly Progress',
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
                            _calculateProgress();
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
                            _calculateProgress();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Progress overview
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
                          'Progress Overview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D6B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Progress cards
                    ..._buildProgressCards(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Comparison with previous month
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
                            Icons.compare_arrows,
                            color: Color(0xFF6B9BD2),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Previous Month Comparison',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D6B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Comparison cards
                    ..._buildComparisonCards(),
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

  List<Widget> _buildProgressCards() {
    final activityKeys = ['quran', 'hadith', 'literature', 'salat', 'study', 'friends', 'workings', 'criticism'];
    final activityNames = ['Quran Reading', 'Hadith Study', 'Islamic Literature', 'Salat (Prayers)', 'Academic Study', 'Friends & Social', 'Work Activities', 'Self Criticism'];
    final activityIcons = [Icons.menu_book, Icons.auto_stories, Icons.library_books, Icons.mosque, Icons.school, Icons.people, Icons.work, Icons.psychology];
    final activityColors = [const Color(0xFF2E7D6B), const Color(0xFF4A90A4), const Color(0xFF6B9BD2), const Color(0xFF8B7ED8), const Color(0xFF9C27B0), const Color(0xFFE91E63), const Color(0xFFFF5722), const Color(0xFF607D8B)];
    
    return activityKeys.asMap().entries.map((entry) {
      final index = entry.key;
      final key = entry.value;
      final current = _currentMonthTotals[key] ?? 0.0;
      final goal = _monthlyGoals[key] ?? 0.0;
      final progress = goal > 0 ? (current / goal * 100).clamp(0.0, 100.0) : 0.0;
      
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              activityColors[index].withOpacity(0.1),
              activityColors[index].withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: activityColors[index].withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(activityIcons[index], color: activityColors[index], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    activityNames[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D6B),
                    ),
                  ),
                ),
                Text(
                  '${current.toStringAsFixed(0)}/${goal.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: activityColors[index],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(activityColors[index]),
              minHeight: 8,
            ),
            const SizedBox(height: 4),
            Text(
              '${progress.toStringAsFixed(1)}% completed',
              style: TextStyle(
                fontSize: 12,
                color: activityColors[index],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildComparisonCards() {
    final activityKeys = ['quran', 'hadith', 'literature', 'salat', 'study', 'friends', 'workings', 'criticism'];
    final activityNames = ['Quran Reading', 'Hadith Study', 'Islamic Literature', 'Salat (Prayers)', 'Academic Study', 'Friends & Social', 'Work Activities', 'Self Criticism'];
    final activityIcons = [Icons.menu_book, Icons.auto_stories, Icons.library_books, Icons.mosque, Icons.school, Icons.people, Icons.work, Icons.psychology];
    final activityColors = [const Color(0xFF2E7D6B), const Color(0xFF4A90A4), const Color(0xFF6B9BD2), const Color(0xFF8B7ED8), const Color(0xFF9C27B0), const Color(0xFFE91E63), const Color(0xFFFF5722), const Color(0xFF607D8B)];
    
    return activityKeys.asMap().entries.map((entry) {
      final index = entry.key;
      final key = entry.value;
      final current = _currentMonthTotals[key] ?? 0.0;
      final previous = _previousMonthTotals[key] ?? 0.0;
      final difference = current - previous;
      final percentageChange = previous > 0 ? (difference / previous * 100) : 0.0;
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(activityIcons[index], color: activityColors[index], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                activityNames[index],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E7D6B),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${current.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: activityColors[index],
                  ),
                ),
                Text(
                  '${difference >= 0 ? '+' : ''}${difference.toStringAsFixed(0)} (${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 12,
                    color: difference >= 0 ? const Color(0xFF4CAF50) : const Color(0xFFE57373),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }
}
