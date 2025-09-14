import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityFormScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, dynamic>? existingData;
  final Function(Map<String, dynamic>) onSave;

  const ActivityFormScreen({
    super.key,
    required this.selectedDate,
    this.existingData,
    required this.onSave,
  });

  @override
  State<ActivityFormScreen> createState() => _ActivityFormScreenState();
}

class _ActivityFormScreenState extends State<ActivityFormScreen> {
  final Map<String, TextEditingController> _controllers = {
    'quran': TextEditingController(),
    'hadith': TextEditingController(),
    'literature': TextEditingController(),
    'salat': TextEditingController(),
    'study': TextEditingController(),
    'friends': TextEditingController(),
    'workings': TextEditingController(),
    'criticism': TextEditingController(),
    'note': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      widget.existingData!.forEach((key, value) {
        if (_controllers.containsKey(key)) {
          _controllers[key]!.text = value.toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      appBar: AppBar(
        title: Text(
          DateFormat('EEEE, d MMMM, yyyy', 'bn').format(widget.selectedDate),
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
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
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2E7D6B).withOpacity(0.1),
                            const Color(0xFF4A90A4).withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.edit_note,
                        color: Color(0xFF2E7D6B),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Daily Activity Entry',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D6B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Activity fields
                _buildNumberField('Quran Reading', 'quran', Icons.menu_book, const Color(0xFF2E7D6B)),
                _buildNumberField('Hadith Study', 'hadith', Icons.auto_stories, const Color(0xFF4A90A4)),
                _buildNumberField('Islamic Literature', 'literature', Icons.library_books, const Color(0xFF6B9BD2)),
                _buildNumberField('Salat (Prayers)', 'salat', Icons.mosque, const Color(0xFF8B7ED8)),
                _buildNumberField('Academic Study', 'study', Icons.school, const Color(0xFF9C27B0)),
                _buildNumberField('Friends & Social', 'friends', Icons.people, const Color(0xFFE91E63)),
                _buildNumberField('Work Activities', 'workings', Icons.work, const Color(0xFFFF5722)),
                _buildNumberField('Self Criticism', 'criticism', Icons.psychology, const Color(0xFF607D8B)),
                
                const SizedBox(height: 20),
                
                // Note field
                _buildTextField('Notes', 'note', Icons.note_alt, const Color(0xFF795548)),
                
                const SizedBox(height: 30),
                
                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveData,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Save Entry',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controllers[key],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter number (0-100)',
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

  Widget _buildTextField(String label, String key, IconData icon, Color color) {
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controllers[key],
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your notes here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: color, width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  void _saveData() {
    final data = <String, dynamic>{};
    
    // Save number fields
    for (String key in ['quran', 'hadith', 'literature', 'salat', 'study', 'friends', 'workings', 'criticism']) {
      final value = _controllers[key]!.text.trim();
      data[key] = value.isEmpty ? 0 : int.tryParse(value) ?? 0;
    }
    
    // Save note field
    data['note'] = _controllers['note']!.text.trim();
    
    widget.onSave(data);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Activity saved successfully!'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
