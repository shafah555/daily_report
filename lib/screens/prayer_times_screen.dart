import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  Map<String, String> _prayerTimes = {};
  String _location = 'Loading...';
  bool _isLoading = true;
  String _currentPrayer = '';
  String _nextPrayer = '';
  String _timeUntilNext = '';

  @override
  void initState() {
    super.initState();
    _getLocationAndPrayerTimes();
  }

  Future<void> _getLocationAndPrayerTimes() async {
    try {
      // Request location permission
      final permission = await Permission.location.request();
      if (permission != PermissionStatus.granted) {
        setState(() {
          _location = 'Location permission denied';
          _isLoading = false;
        });
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _location = '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
      });

      // Get prayer times
      await _fetchPrayerTimes(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _location = 'Error getting location';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPrayerTimes(double lat, double lng) async {
    try {
      final now = DateTime.now();
      final date = DateFormat('dd-MM-yyyy').format(now);
      
      // Using Aladhan API
      final response = await http.get(
        Uri.parse('http://api.aladhan.com/v1/timings/$date?latitude=$lat&longitude=$lng&method=2'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final timings = data['data']['timings'];
        
        setState(() {
          _prayerTimes = {
            'Fajr': timings['Fajr'],
            'Sunrise': timings['Sunrise'],
            'Dhuhr': timings['Dhuhr'],
            'Asr': timings['Asr'],
            'Maghrib': timings['Maghrib'],
            'Sunset': timings['Sunset'],
            'Isha': timings['Isha'],
          };
          _isLoading = false;
        });
        
        _calculateCurrentAndNextPrayer();
      } else {
        // Fallback to sample data
        _setSamplePrayerTimes();
      }
    } catch (e) {
      // Fallback to sample data
      _setSamplePrayerTimes();
    }
  }

  void _setSamplePrayerTimes() {
    setState(() {
      _prayerTimes = {
        'Fajr': '05:15',
        'Sunrise': '06:30',
        'Dhuhr': '12:30',
        'Asr': '16:45',
        'Maghrib': '18:20',
        'Sunset': '18:20',
        'Isha': '19:45',
      };
      _isLoading = false;
    });
    _calculateCurrentAndNextPrayer();
  }

  void _calculateCurrentAndNextPrayer() {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);
    
    final prayerList = [
      {'name': 'Fajr', 'time': _prayerTimes['Fajr']!},
      {'name': 'Sunrise', 'time': _prayerTimes['Sunrise']!},
      {'name': 'Dhuhr', 'time': _prayerTimes['Dhuhr']!},
      {'name': 'Asr', 'time': _prayerTimes['Asr']!},
      {'name': 'Maghrib', 'time': _prayerTimes['Maghrib']!},
      {'name': 'Sunset', 'time': _prayerTimes['Sunset']!},
      {'name': 'Isha', 'time': _prayerTimes['Isha']!},
    ];

    for (int i = 0; i < prayerList.length; i++) {
      final prayerTime = prayerList[i]['time']!.split(':');
      final prayerHour = int.parse(prayerTime[0]);
      final prayerMinute = int.parse(prayerTime[1]);
      
      if (currentTime.hour < prayerHour || 
          (currentTime.hour == prayerHour && currentTime.minute < prayerMinute)) {
        setState(() {
          _currentPrayer = i > 0 ? prayerList[i - 1]['name']! : 'Isha';
          _nextPrayer = prayerList[i]['name']!;
          
          // Calculate time until next prayer
          final nextPrayerTime = DateTime(now.year, now.month, now.day, prayerHour, prayerMinute);
          final difference = nextPrayerTime.difference(now);
          _timeUntilNext = '${difference.inHours}h ${difference.inMinutes % 60}m';
        });
        return;
      }
    }
    
    // If no prayer found, next prayer is tomorrow's Fajr
    setState(() {
      _currentPrayer = 'Isha';
      _nextPrayer = 'Fajr (Tomorrow)';
      _timeUntilNext = 'Until tomorrow';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with location
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
                        Icons.mosque,
                        color: Color(0xFF2E7D6B),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'নামাজের সময়সূচী',
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
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF4A90A4),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A90A4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Current prayer info
          if (!_isLoading && _currentPrayer.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Color(0xFF4CAF50),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Current Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D6B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Current: $_currentPrayer',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D6B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Next: $_nextPrayer',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4A90A4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time until next: $_timeUntilNext',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B9BD2),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Prayer times grid
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
                          Icons.schedule,
                          color: Color(0xFF2E7D6B),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Prayer Times',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D6B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2E7D6B),
                      ),
                    )
                  else
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      children: [
                        _buildPrayerCard('الفجر', 'ফজর', _prayerTimes['Fajr']!, const Color(0xFF2E7D6B)),
                        _buildPrayerCard('الشروق', 'সূর্যোদয়', _prayerTimes['Sunrise']!, const Color(0xFFFF9800)),
                        _buildPrayerCard('الظهر', 'যোহর', _prayerTimes['Dhuhr']!, const Color(0xFF4A90A4)),
                        _buildPrayerCard('العصر', 'আসর', _prayerTimes['Asr']!, const Color(0xFF6B9BD2)),
                        _buildPrayerCard('المغرب', 'মাগরিব', _prayerTimes['Maghrib']!, const Color(0xFF8B7ED8)),
                        _buildPrayerCard('الغروب', 'সূর্যাস্ত', _prayerTimes['Sunset']!, const Color(0xFFFF5722)),
                        _buildPrayerCard('العشاء', 'এশা', _prayerTimes['Isha']!, const Color(0xFF9C27B0)),
                      ],
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPrayerCard(String arabic, String bengali, String time, Color color) {
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
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            arabic,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D6B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            bengali,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A90A4),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            time,
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
}
