import 'package:flutter/material.dart';
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Screens/quiz/quiz_listing.dart';
import 'package:spires_app/Screens/quiz/olympiad_registration.dart';

class QuizzesAndOlympiadScreen extends StatelessWidget {
  const QuizzesAndOlympiadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: const Text('Quizzes & Olympiad',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.orange.shade400,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Your Challenge',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Test your knowledge or compete with others',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 30),
              _buildLargeCard(
                context,
                'Quizzes',
                'Challenge yourself with our fun and interactive quizzes on various topics. Perfect for testing your knowledge and learning new things!',
                Colors.blue.shade700,
                size,
                () => navigateToQuizList(context, isOlympiad: false),
              ),
              const SizedBox(height: 20),
              _buildLargeCard(
                context,
                'Olympiad',
                'Participate in our academic competitions designed to identify and nurture talent. Compete with peers and earn certificates!',
                Colors.amber.shade700,
                size,
                () => navigateToQuizList(context, isOlympiad: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToQuizList(BuildContext context, {required bool isOlympiad}) {
    if (isOlympiad) {
      // Navigate to Olympiad registration
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OlympiadRegistrationForm(
            olympiadId: 0, // This will be set by the API
            duration: 60, // Default duration in minutes
          ),
        ),
      );
    } else {
      // Navigate to Quiz list
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const QuizListScreen(),
        ),
      );
    }
  }

  Widget _buildLargeCard(
    BuildContext context,
    String title,
    String description,
    Color color,
    Size size,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: size.height * 0.28,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.8),
              color,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Start Now',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white.withOpacity(0.9),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 