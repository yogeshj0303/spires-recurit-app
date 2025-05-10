import 'package:flutter/material.dart';
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Screens/quiz/quizzes_and_olympiad.dart';
import 'package:spires_app/Services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OlympiadRegistrationForm extends StatefulWidget {
  final int olympiadId;
  final int duration;
  final Function? onRegistrationComplete;
  
  const OlympiadRegistrationForm({
    Key? key, 
    required this.olympiadId, 
    required this.duration,
    this.onRegistrationComplete,
  }) : super(key: key);

  @override
  State<OlympiadRegistrationForm> createState() => _OlympiadRegistrationFormState();
}

class _OlympiadRegistrationFormState extends State<OlympiadRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _parentNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  
  String? _selectedStandard;
  bool _isAgreedToTerms = false;
  bool _isLoading = false;
  
  final List<String> _standardOptions = [
    '1st', '2nd', '3rd', '4th', '5th', '6th', '7th', '8th', '9th', '10th', '11th', '12th'
  ];

  @override
  void dispose() {
    _studentNameController.dispose();
    _parentEmailController.dispose();
    _parentNameController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Olympiad Registration', 
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.orange.shade500,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.orange.shade500,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Processing registration...',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Student Information'),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _studentNameController,
                      label: 'Student Name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter student name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Parent Information'),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _parentNameController,
                      label: 'Parent\'s Name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter parent\'s name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _parentEmailController,
                      label: 'Parent\'s Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter parent\'s email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _mobileNumberController,
                      label: 'Mobile Number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    _buildTermsCheckbox(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.emoji_events_rounded, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Olympiad Registration',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Register for the Olympiad competition and showcase your academic excellence!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.orange.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 3,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.orange.shade500,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
          ),
          prefixIcon: Icon(prefixIcon, color: Colors.orange.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange.shade500, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedStandard,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Standard',
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
          ),
          prefixIcon: Icon(Icons.grade_outlined, color: Colors.orange.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange.shade500, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        items: _standardOptions.map((String standard) {
          return DropdownMenuItem<String>(
            value: standard,
            child: Text(standard),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedStandard = newValue;
          });
        },
        icon: Icon(Icons.arrow_drop_down_circle, color: Colors.orange.shade500),
        dropdownColor: Colors.white,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select your standard';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _isAgreedToTerms,
          onChanged: (value) {
            setState(() {
              _isAgreedToTerms = value ?? false;
            });
          },
          activeColor: Colors.orange.shade500,
        ),
        Expanded(
          child: Text(
            'I agree to the terms and conditions of the Olympiad competition',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade400.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade500,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Register & Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _handleRegistration() {
    if (_formKey.currentState!.validate() && _isAgreedToTerms) {
      setState(() {
        _isLoading = true;
      });

      // Call the API service to register for Olympiad
      ApiService.registerForOlympiad(
        studentName: _studentNameController.text,
        parentName: _parentNameController.text,
        mobile: _mobileNumberController.text,
        standard: _selectedStandard!.replaceAll(RegExp(r'[a-zA-Z]'), '').trim(), // Extract just the number
        password: '', // No password needed for direct registration
        parentEmail: _parentEmailController.text,
      ).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response['status'] == true) {
          // Registration successful
          // Store user data in shared preferences
          _saveUserData(response);
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Call completion callback if provided
          if (widget.onRegistrationComplete != null) {
            widget.onRegistrationComplete!();
            // Navigate back to previous screen
            Navigator.of(context).pop();
          } else {
            // Navigate to quiz list screen
            Get.to(() => QuizzesAndOlympiadScreen());
          }
        } else {
          // Registration failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Registration failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } else if (!_isAgreedToTerms) {
      // Show error message for terms not agreed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please agree to the terms and conditions"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Save user data to shared preferences
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save olympiad user ID from the nested data structure
      if (userData['data'] != null && userData['data']['id'] != null) {
        final olympiadUserId = userData['data']['id'];
        await prefs.setInt('olympiad_user_id', olympiadUserId);
        await prefs.setInt('user_id', olympiadUserId); // Also set as current user_id
        
        // IMPORTANT: Set user ID in MyController
        MyController.id = olympiadUserId;
        print("Setting MyController.id to olympiad user ID: $olympiadUserId");
      }
      
      // Save complete user data
      await prefs.setString('olympiad_user_data', jsonEncode(userData));
      
      // Set olympiad specific login status
      await prefs.setBool('is_olympiad_logged_in', true);
      await prefs.setBool('is_logged_in', true);

      // Set guest mode to true for olympiad users
      final c = Get.find<MyController>();
      c.isGuestMode.value = true;
      await prefs.setBool('is_guest_mode', true);

      // Set user type for olympiad login
      await prefs.setString('user_type', 'olympiad_user');
    } catch (e) {
      print("Error saving user data: $e");
    }
  }
} 