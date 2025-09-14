import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class MonthlyPlanningScreen extends StatefulWidget {
  const MonthlyPlanningScreen({super.key});

  @override
  State<MonthlyPlanningScreen> createState() => _MonthlyPlanningScreenState();
}

class _MonthlyPlanningScreenState extends State<MonthlyPlanningScreen> {
  final Map<String, TextEditingController> _controllers = {
    'quran': TextEditingController(),
    'hadith': TextEditingController(),
    'literature': TextEditingController(),
    'salat': TextEditingController(),
    'study': TextEditingController(),
    'friends': TextEditingController(),
    'workings': TextEditingController(),
    'criticism': TextEditingController(),
  };

  DateTime _selectedMonth = DateTime.now();
  Map<String, Map<String, dynamic>> _monthlyPlans = {};

  @override
  void initState() {
    super.initState();
    _loadMonthlyPlans();
  }

  Future<void> _loadMonthlyPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final plansJson = prefs.getString('monthly_plans');
    if (plansJson != null) {
      setState(() {
        _monthlyPlans = Map<String, Map<String, dynamic>>.from(
          json.decode(plansJson).map(
            (key, value) => MapEntry(key, Map<String, dynamic>.from(value)),
          ),
        );
      });
      _loadCurrentMonthPlan();
    }
  }

  Future<void> _saveMonthlyPlans() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('monthly_plans', json.encode(_monthlyPlans));
  }

  void _loadCurrentMonthPlan() {
    final monthKey = DateFormat('yyyy-MM').format(_selectedMonth);
    final plan = _monthlyPlans[monthKey];
    
    if (plan != null) {
      for (String key in _controllers.keys) {
        _controllers[key]!.text = plan[key]?.toString() ?? '';
      }
    } else {
      for (var controller in _controllers.values) {
        controller.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: AppBar(
        title: const Text('Monthly Planning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _savePlan,
          ),
        ],
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
                          Icons.calendar_today,
                          color: Color(0xFF2E7D6B),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Monthly Planning',
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
                            _loadCurrentMonthPlan();
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
                            _loadCurrentMonthPlan();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Planning form
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
                            Icons.edit_note,
                            color: Color(0xFF4A90A4),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Set Monthly Goals',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D6B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Activity fields
                    _buildNumberField('Quran Reading (pages)', 'quran', Icons.menu_book, const Color(0xFF2E7D6B)),
                    _buildNumberField('Hadith Study (hours)', 'hadith', Icons.auto_stories, const Color(0xFF4A90A4)),
                    _buildNumberField('Islamic Literature (books)', 'literature', Icons.library_books, const Color(0xFF6B9BD2)),
                    _buildNumberField('Salat (prayers)', 'salat', Icons.mosque, const Color(0xFF8B7ED8)),
                    _buildNumberField('Academic Study (hours)', 'study', Icons.school, const Color(0xFF9C27B0)),
                    _buildNumberField('Friends & Social (meetings)', 'friends', Icons.people, const Color(0xFFE91E63)),
                    _buildNumberField('Work Activities (hours)', 'workings', Icons.work, const Color(0xFFFF5722)),
                    _buildNumberField('Self Criticism (sessions)', 'criticism', Icons.psychology, const Color(0xFF607D8B)),
                    
                    const SizedBox(height: 30),
                    
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _savePlan,
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'Save Monthly Plan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D6B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
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

  Widget _buildNumberField(String label, String key, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D6B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controllers[key],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter target number...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: color, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: Icon(Icons.numbers, color: color.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  void _savePlan() {
    final monthKey = DateFormat('yyyy-MM').format(_selectedMonth);
    final plan = <String, dynamic>{};
    
    for (String key in _controllers.keys) {
      final value = _controllers[key]!.text.trim();
      plan[key] = value.isEmpty ? 0 : int.tryParse(value) ?? 0;
    }
    
    setState(() {
      _monthlyPlans[monthKey] = plan;
    });
    
    _saveMonthlyPlans();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Monthly plan saved successfully!'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
