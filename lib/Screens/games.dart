import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int totalQuestions = 10;
  int timeRemaining = 300; // 5 minutes in seconds
  late Timer _timer;
  List<int?> selectedAnswers = List.filled(10, null);
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        setState(() {
          timeRemaining--;
        });
      } else {
        timer.cancel();
        // Handle quiz timeout
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < totalQuestions - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Submit quiz logic
      print('Quiz submitted!');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('True or False Quiz',
            style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${currentQuestionIndex + 1} / $totalQuestions',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 18, color: Colors.blueGrey),
                        const SizedBox(width: 5),
                        Text(
                          formatTime(timeRemaining),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    clipBehavior: Clip.none,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: totalQuestions,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          clipBehavior: Clip.none,
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getQuestionDotColor(index),
                            border: Border.all(
                              color: currentQuestionIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300]!,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 14,
                              color: currentQuestionIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: totalQuestions,
              onPageChanged: (index) {
                setState(() {
                  currentQuestionIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question ${index + 1}:',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'What is one responsibility of athletes regarding their whereabouts?',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            buildOptionCard(
                              0,
                              'They only need to update their location during competitions.',
                              isSelected: selectedAnswers[index] == 0,
                              onTap: () => _answerQuestion(0),
                            ),
                            buildOptionCard(
                              1,
                              'They must always provide accurate and up-to-date location details.',
                              isSelected: selectedAnswers[index] == 1,
                              onTap: () => _answerQuestion(1),
                            ),
                            buildOptionCard(
                              2,
                              'They should only tell their teammates.',
                              isSelected: selectedAnswers[index] == 2,
                              onTap: () => _answerQuestion(2),
                            ),
                            buildOptionCard(
                              3,
                              'They only need to submit their location once a year.',
                              isSelected: selectedAnswers[index] == 3,
                              onTap: () => _answerQuestion(3),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 120,
                  child: OutlinedButton(
                    onPressed:
                        currentQuestionIndex > 0 ? _previousQuestion : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: currentQuestionIndex > 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300]!),
                      foregroundColor: currentQuestionIndex > 0
                          ? Theme.of(context).primaryColor
                          : Colors.grey[500],
                    ),
                    child: const Text('Previous'),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text(currentQuestionIndex < totalQuestions - 1
                        ? 'Next'
                        : 'Submit Quiz'),
                  ),
                ),
              ],
            ),
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
