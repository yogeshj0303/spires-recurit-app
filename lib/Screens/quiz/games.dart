import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Models/question_model.dart';
import 'package:spires_app/Models/quiz_submission_model.dart';
import 'package:spires_app/Services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:spires_app/Screens/quiz/quiz_registration.dart';
import 'package:spires_app/Screens/quiz/olympiad_login_screen.dart';

class QuizScreen extends StatefulWidget {
  final int quizId;
  final int duration; // Add this
  final Function(int score)? onQuizComplete;

  const QuizScreen({
    Key? key,
    required this.quizId,
    required this.duration, // Add this
    this.onQuizComplete,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  List<Question> questions = [];
  bool _isLoading = true;
  String? _error;
  late Timer _timer;
  int timeRemaining = 0;
  bool _hasTimedOut = false;
  late List<int?> selectedAnswers;
  late PageController _pageController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    timeRemaining = widget.duration * 60; // Convert minutes to seconds
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.fetchQuestions(widget.quizId);
      setState(() {
        questions = response.questionAnswer;
        selectedAnswers = List.filled(questions.length, null);
        _isLoading = false;
        startTimer();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          timer.cancel();
          if (!_hasTimedOut) {
            _hasTimedOut = true;
            _handleTimeout();
          }
        }
      });
    });
  }

  void _handleTimeout() {
    if (_isSubmitting) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.timer_off_rounded, color: Colors.red.shade400),
            const SizedBox(width: 12),
            const Text('Time\'s Up!'),
          ],
        ),
        content: const Text(
          'Your time has expired. The quiz will be submitted with your current answers.',
        ),
        actions: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _proceedWithSubmission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Submit Quiz'),
            ),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitQuiz();
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _answerQuestion(int optionIndex) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = optionIndex;
    });
  }

  Future<void> _submitQuiz() async {
    if (_isSubmitting) return;

    // Check if all questions are answered
    final unansweredQuestions =
        selectedAnswers.where((answer) => answer == null).length;
    if (unansweredQuestions > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incomplete Quiz'),
          content: Text(
              'You have $unansweredQuestions unanswered questions. Are you sure you want to submit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Review Answers'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _proceedWithSubmission();
              },
              child: const Text('Submit Anyway'),
            ),
          ],
        ),
      );
      return;
    }

    _proceedWithSubmission();
  }

  Future<void> _proceedWithSubmission() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final answers = <QuizAnswer>[];
      for (var i = 0; i < questions.length; i++) {
        if (selectedAnswers[i] != null) {
          answers.add(
            QuizAnswer(
              questionId: questions[i].id,
              answer: String.fromCharCode(65 + selectedAnswers[i]!),
            ),
          );
        }
      }

      // Check if user is in guest mode
      final c = Get.find<MyController>();
      if (c.isGuestMode.value || MyController.id <= 0) {
        // Guest mode - show a dialog to register/login
        if (!mounted) return;
        
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('Registration Required'),
            content: Text('Please register or log in to save your quiz results.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.to(() => QuizRegistrationForm(
                    quizId: widget.quizId,
                    duration: widget.duration,
                    onRegistrationComplete: () {
                      // After registration, try to take the quiz again
                      // This will be called when returning from registration
                      _proceedWithSubmission();
                    },
                  ));
                },
                child: Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Get.to(() => OlympiadLoginScreen(
                    onLoginComplete: () {
                      // After login, try to take the quiz again
                      _proceedWithSubmission();
                    },
                  ));
                },
                child: Text('Login'),
              ),
            ],
          ),
        );
        return;
      }

      // Create submission object with user ID
      QuizSubmission submission = QuizSubmission(
        userId: MyController.id,
        quizId: widget.quizId,
        answers: answers,
      );

      // Enhanced debugging to check user ID
      print("Submitting quiz with user_id: ${MyController.id}, guest mode: ${c.isGuestMode.value}");
      
      // Load user ID from preferences again as a final verification
      try {
        final prefs = await SharedPreferences.getInstance();
        final storedUserId = prefs.getInt('user_id');
        print("User ID from SharedPreferences: $storedUserId");
        
        // If stored ID is valid but controller ID is invalid, use the stored ID
        if ((storedUserId != null && storedUserId > 0) && MyController.id <= 0) {
          MyController.id = storedUserId;
          print("Updated controller ID from SharedPreferences: $storedUserId");
          
          // Create a new submission with the correct user ID
          submission = QuizSubmission(
            userId: storedUserId,
            quizId: widget.quizId,
            answers: answers,
          );
        }
      } catch (e) {
        print("Error accessing SharedPreferences: $e");
      }

      final result = await ApiService.submitQuiz(submission);

      if (!mounted) return;

      // Calculate score
      final correctAnswers =
          result.result.where((q) => q.answerStatus == 'Correct').length;
      final score = (correctAnswers / result.totalQuestions * 100).round();

      // Important: Call the callback before showing dialog
      widget.onQuizComplete?.call(score);

      // Replace the existing showDialog code in _proceedWithSubmission method
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with gradient
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  // padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      Icon(
                        score >= 70
                            ? Icons.emoji_events_rounded
                            : Icons.check_circle_outline_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Quiz Completed',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Score Display
                      Text(
                        '$score%',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        '$correctAnswers out of ${result.totalQuestions} correct',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Stats Container
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            _buildStatItem(
                              'Questions Attempted',
                              '${result.attemptedQuestions}/${result.totalQuestions}',
                              Icons.quiz_outlined,
                            ),
                            Divider(color: Colors.grey.shade200),
                            _buildStatItem(
                              'Accuracy',
                              '${(correctAnswers / result.totalQuestions * 100).round()}%',
                              Icons.analytics_outlined,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Certificate Button
                      if (result.certificateUrl != null) ...[
                        OutlinedButton.icon(
                          onPressed: () =>
                              launchUrl(Uri.parse(result.certificateUrl!)),
                          icon: const Icon(Icons.download_rounded),
                          label: const Text('Download Certificate'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      // Back Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: timeRemaining <= 60
                    ? Colors.red.shade50
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: timeRemaining <= 60
                      ? Colors.red.shade200
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: timeRemaining <= 60
                        ? Colors.red.shade700
                        : Colors.grey.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatTime(timeRemaining),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: timeRemaining <= 60
                          ? Colors.red.shade700
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : Column(
                  children: [
                    _buildProgressHeader(),
                    Expanded(
                      child: _buildQuestionContent(),
                    ),
                    _buildNavigationButtons(),
                  ],
                ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1} of ${questions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${((currentQuestionIndex + 1) / questions.length * 100).round()}%',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: (currentQuestionIndex + 1) / questions.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent() {
    return PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      itemCount: questions.length,
      onPageChanged: (index) {
        setState(() {
          currentQuestionIndex = index;
        });
      },
      itemBuilder: (context, index) {
        final question = questions[index];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              _buildOptionsList(question),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionsList(Question question) {
    return Column(
      children: [
        _buildOptionCard(0, 'A', question.optionA),
        _buildOptionCard(1, 'B', question.optionB),
        _buildOptionCard(2, 'C', question.optionC),
        _buildOptionCard(3, 'D', question.optionD),
      ],
    );
  }

  Widget _buildOptionCard(int index, String label, String text) {
    final isSelected = selectedAnswers[currentQuestionIndex] == index;
    return GestureDetector(
      onTap: () => _answerQuestion(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousQuestion,
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          if (currentQuestionIndex > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _nextQuestion,
              icon: Icon(
                currentQuestionIndex < questions.length - 1
                    ? Icons.arrow_forward_rounded
                    : Icons.check_rounded,
                size: 18,
              ),
              label: Text(
                currentQuestionIndex < questions.length - 1
                    ? 'Next Question'
                    : 'Submit Quiz',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            _error!,
            style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _fetchQuestions,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Color getQuestionDotColor(int index) {
    if (selectedAnswers[index] != null) {
      return Colors.green.shade200; // Answered
    }
    return Colors.white; // Not attempted
  }

  Widget buildOptionCard(int index, String text,
      {bool isSelected = false, VoidCallback? onTap}) {
    return Card(
      clipBehavior: Clip.none,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: isSelected
          ? Theme.of(context).primaryColor.withOpacity(0.05)
          : Colors.white,
      elevation: 0.5,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[400]!,
                  ),
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile',
            style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, size: 30, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tarun Dwivedi',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text('User ID: 8179324',
                        style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProfileCard(
                  context,
                  'MY BADGES',
                  '8000',
                  'ENTHUSIAST LEVEL 3',
                  icon: Icons.shield_outlined,
                  color: Colors.amber.shade300,
                ),
                _buildProfileCard(
                  context,
                  'QUIZ POINTS',
                  '8000',
                  '',
                  icon: Icons.star_border,
                  color: Colors.lightGreen.shade300,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ListTile(
                  leading:
                      Icon(Icons.assignment_outlined, color: Colors.blueGrey),
                  title: Text(
                      'Quiz on Dokho Apna Desh Webinar : BABA SAHEB DB. AMBEDKAR CIRCUIT TRAIN: AN INITIATIVE BY IRCTC'),
                  dense: true,
                ),
                ListTile(
                  leading:
                      Icon(Icons.assignment_outlined, color: Colors.blueGrey),
                  title: Text('Y-Break App Quiz'),
                  dense: true,
                ),
                ListTile(
                  leading:
                      Icon(Icons.assignment_outlined, color: Colors.blueGrey),
                  title: Text('International Day of Yoga 2023 Quiz 2.0'),
                  dense: true,
                ),
                ListTile(
                  leading:
                      Icon(Icons.assignment_outlined, color: Colors.blueGrey),
                  title: Text('Know your G20 Quiz'),
                  dense: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '* Quiz activity points will be updated after the quiz concludes.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context, String title, String value, String subtitle,
      {IconData? icon, Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null && color != null) Icon(icon, size: 32, color: color),
          if (icon != null) const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          if (subtitle.isNotEmpty) const SizedBox(height: 4),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}