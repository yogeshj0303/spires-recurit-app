import 'package:flutter/material.dart';
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Screens/quiz/quiz_listing.dart';

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
    // For now, both cards navigate to the same QuizListScreen
    // You can later modify this to filter quizzes based on isOlympiad parameter
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizListScreen(),
      ),
    );
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
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Opacity(
                opacity: 0.2,
                child: Icon(
                  title == 'Quizzes' ? Icons.quiz_outlined : Icons.school_outlined,
                  size: 120,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          title == 'Quizzes' ? Icons.quiz_outlined : Icons.school_outlined,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Get Started',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: color,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 