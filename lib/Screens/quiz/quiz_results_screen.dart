import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Models/quiz_result_model.dart';
import 'package:spires_app/Services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizResultsScreen extends StatefulWidget {
  const QuizResultsScreen({Key? key}) : super(key: key);

  @override
  _QuizResultsScreenState createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  bool _isLoading = true;
  String? _error;
  QuizResultResponse? _results;
  final c = Get.put(MyController());

  @override
  void initState() {
    super.initState();
    _fetchResults();
  }

  Future<void> _fetchResults() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Check if in guest mode
      if (c.isGuestMode.value) {
        setState(() {
          _results = null;
          _isLoading = false;
        });
        return;
      }

      // Get user type and ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final isOlympiadLoggedIn = prefs.getBool('is_olympiad_logged_in') ?? false;
      
      int userId;
      String userType;
      
      if (isOlympiadLoggedIn) {
        // Use olympiad user ID and type
        userId = prefs.getInt('olympiad_user_id') ?? 0;
        userType = 'olympiad_user';
      } else {
        // Use regular user ID and type
        userId = MyController.id;
        userType = 'user';
      }

      // Check if user is properly logged in
      if (userId <= 0) {
        print('User not logged in - userId: $userId');
        setState(() {
          _results = null;
          _isLoading = false;
        });
        return;
      }

      print('Fetching quiz results for:');
      print('User ID: $userId');
      print('User Type: $userType');

      final results = await ApiService.fetchUserQuizResults(userId, userType: userType);

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      print('Error in _fetchResults: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Quiz Results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchResults,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading results',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchResults,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : _buildResultsList(),
    );
  }

  Widget _buildResultsList() {
    if (_results == null || _results!.quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No quiz attempts yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a quiz to see your results here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchResults,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _results!.quizzes.length,
        itemBuilder: (context, index) {
          final quiz = _results!.quizzes[index];
          final score = quiz.calculateScore();
          final scoreColor = score >= 70
              ? Colors.green.shade700
              : score >= 40
                  ? Colors.orange.shade700
                  : Colors.red.shade700;

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          scoreColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Quiz Icon
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: scoreColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.quiz_rounded,
                                      color: scoreColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Quiz Title and Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          quiz.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_outlined,
                                              size: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat('MMM d, yyyy')
                                                  .format(quiz.participatedOn),
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Stats Row
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        child: _buildStatItem(
                                          '${quiz.attemptedQuestions}/${quiz.totalQuestions}',
                                          'Questions',
                                          Icons.question_answer_outlined,
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: Colors.grey.shade300,
                                        thickness: 1,
                                      ),
                                      Flexible(
                                        child: _buildStatItem(
                                          '$score%',
                                          'Score',
                                          Icons.analytics_outlined,
                                          color: scoreColor,
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: Colors.grey.shade300,
                                        thickness: 1,
                                      ),
                                      Flexible(
                                        child: _buildStatItem(
                                          DateFormat('h:mm a')
                                              .format(quiz.participatedOn),
                                          'Time',
                                          Icons.access_time_rounded,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Action Buttons
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(16),
                            ),
                            border: Border(
                              top: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () => _showQuizDetails(quiz),
                                  icon:
                                      const Icon(Icons.remove_red_eye_outlined),
                                  label: const Text('View Details'),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    foregroundColor: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                              if (quiz.certificateUrl != null) ...[
                                VerticalDivider(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () => launchUrl(
                                        Uri.parse(quiz.certificateUrl!)),
                                    icon: Icon(
                                      Icons.download_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    label: Text(
                                      'Certificate',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Score Badge
                Positioned(
                  top: -10,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: scoreColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: scoreColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          score >= 70
                              ? Icons.emoji_events_rounded
                              : Icons.stars_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$score%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Add this helper method
  Widget _buildStatItem(String value, String label, IconData icon,
      {Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: color ?? Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color ?? Colors.grey.shade800,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _showQuizDetails(QuizResultDetail quiz) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.quiz_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      quiz.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: quiz.result.length,
                itemBuilder: (context, index) {
                  final question = quiz.result[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Q${index + 1}. ${question.question}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Icon(
                                question.answerStatus == 'Correct'
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: question.answerStatus == 'Correct'
                                    ? Colors.green.shade600
                                    : Colors.red.shade600,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...question.options.entries.map(
                            (option) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _getOptionColor(
                                  option.key,
                                  question.correctAnswer,
                                  question.userAnswer,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    option.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(option.value)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getOptionColor(
      String option, String correctAnswer, String? userAnswer) {
    if (option == correctAnswer) {
      return Colors.green.shade50;
    }
    if (option == userAnswer && userAnswer != correctAnswer) {
      return Colors.red.shade50;
    }
    return Colors.grey.shade50;
  }
}