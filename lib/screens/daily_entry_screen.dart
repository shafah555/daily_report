import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyEntryScreen extends StatefulWidget {
  const DailyEntryScreen({super.key});

  @override
  State<DailyEntryScreen> createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends State<DailyEntryScreen> {
  final Map<String, TextEditingController> _controllers = {
    'namaz': TextEditingController(),
    'hadith': TextEditingController(),
    'quran': TextEditingController(),
    'communication': TextEditingController(),
    'study': TextEditingController(),
    'organizational': TextEditingController(),
    'literature': TextEditingController(),
    'criticism': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEEE, d MMMM, yyyy', 'bn').format(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content area
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'দৈনিক এন্ট্রি',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Form fields
                    _buildFormField('নামাজ', 'namaz', 'নামাজ সম্পর্কে লিখুন...'),
                    _buildFormField('হাদিস', 'hadith', 'হাদিস সম্পর্কে লিখুন...'),
                    _buildFormField('কুরআন', 'quran', 'কুরআন সম্পর্কে লিখুন...'),
                    _buildFormField('যোগাযোগ', 'communication', 'যোগাযোগ সম্পর্কে লিখুন...'),
                    _buildFormField('পড়াশোনা', 'study', 'পড়াশোনা সম্পর্কে লিখুন...'),
                    _buildFormField('সাংগঠনিক কাজ', 'organizational', 'সাংগঠনিক কাজ সম্পর্কে লিখুন...'),
                    _buildFormField('ইসলামী সাহিত্য', 'literature', 'ইসলামী সাহিত্য সম্পর্কে লিখুন...'),
                    _buildFormField('আত্মসমালোচনা', 'criticism', 'আত্মসমালোচনা সম্পর্কে লিখুন...'),
                    
                    const SizedBox(height: 30),
                    
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveEntry,
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'সংরক্ষণ করুন',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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

  Widget _buildFormField(String label, String key, String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controllers[key],
            maxLines: 3,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  void _saveEntry() {
    // Here you would typically save the data to a database or local storage
    // For now, we'll just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('এন্ট্রি সফলভাবে সংরক্ষিত হয়েছে'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Clear all fields after saving
    for (var controller in _controllers.values) {
      controller.clear();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
