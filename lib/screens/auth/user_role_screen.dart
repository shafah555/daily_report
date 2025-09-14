import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main_screen.dart';

class UserRoleScreen extends StatefulWidget {
  const UserRoleScreen({super.key});

  @override
  State<UserRoleScreen> createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends State<UserRoleScreen> {
  final List<Map<String, dynamic>> _roles = [
    {
      'title': 'General',
      'description': 'Basic user with standard features',
      'icon': Icons.person,
      'color': const Color(0xFF2E7D6B),
    },
    {
      'title': 'Primary Member',
      'description': 'Full access to all features',
      'icon': Icons.star,
      'color': const Color(0xFF4A90A4),
    },
    {
      'title': 'Kormi',
      'description': 'Working on process...',
      'icon': Icons.work,
      'color': const Color(0xFF6B9BD2),
    },
    {
      'title': 'Ogrosor Kormi',
      'description': 'Working on process...',
      'icon': Icons.supervisor_account,
      'color': const Color(0xFF8B7ED8),
    },
    {
      'title': 'Dayittoshila',
      'description': 'Working on process...',
      'icon': Icons.admin_panel_settings,
      'color': const Color(0xFF9C27B0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FFFE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Header
                Container(
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D6B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.group,
                          size: 48,
                          color: Color(0xFF2E7D6B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Your Role',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D6B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Choose your membership level',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A90A4),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Role Selection
                ..._roles.map((role) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _selectRole(role['title']),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: role['color'].withOpacity(0.2),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: role['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                role['icon'],
                                color: role['color'],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: role['color'],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    role['description'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4A90A4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: role['color'],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectRole(String role) async {
    // Save selected role
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
    
    if (role == 'Primary Member') {
      // Navigate to main screen for primary member
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
      }
    } else {
      // Show working on process message for other roles
      _showWorkingOnProcessDialog(role);
    }
  }

  void _showWorkingOnProcessDialog(String role) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D6B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.construction,
                  color: Color(0xFF2E7D6B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Working on Process',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D6B),
                ),
              ),
            ],
          ),
          content: Text(
            'The $role role is currently under development. Please select "Primary Member" to access the full features.',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4A90A4),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF2E7D6B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
