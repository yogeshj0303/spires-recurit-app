import 'package:flutter/material.dart';
import 'package:spires_app/Screens/games.dart';
import 'package:intl/intl.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({Key? key}) : super(key: key);

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Quiz> _filteredQuizzes = _quizList; // Start with all quizzes
  final Color _primaryOrange = Colors.orange.shade400;
  final Color _accentOrange = Colors.orange.shade600;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredQuizzes = _quizList.where((quiz) {
        final titleMatch = quiz.title.toLowerCase().contains(query);
        final subtitleMatch =
            quiz.subtitle?.toLowerCase().contains(query) ?? false;
        final descriptionMatch =
            quiz.description?.toLowerCase().contains(query) ?? false;
        return titleMatch || subtitleMatch || descriptionMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Quizzes',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: _primaryOrange,
        foregroundColor: Colors.white,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Search Quizzes...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ),
        ),
      ),
      body: _filteredQuizzes.isEmpty
          ? const Center(
              child: Text('No quizzes found.', style: TextStyle(fontSize: 16)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredQuizzes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int index) {
                return QuizCard(
                    quiz: _filteredQuizzes[index],
                    primaryColor: _primaryOrange,
                    accentColor: _accentOrange);
              },
            ),
      backgroundColor: Colors.white,
    );
  }
}

class Quiz {
  final String title;
  final String? subtitle;
  final DateTime fromDate;
  final DateTime toDate;
  final int questions;
  final int duration;
  final String reward;
  final String? description;

  Quiz({
    required this.title,
    this.subtitle,
    required this.fromDate,
    required this.toDate,
    required this.questions,
    required this.duration,
    required this.reward,
    this.description,
  });
}

final List<Quiz> _quizList = [
  Quiz(
    title: 'Eat Right Quiz on Obesity',
    subtitle: 'Obesity Awareness',
    fromDate: DateTime(2025, 4, 5),
    toDate: DateTime(2025, 5, 5),
    questions: 10,
    duration: 300,
    reward: 'E-Certificate',
    description:
        'The Eat Right Quiz on Obesity emerges from the nationwide conversation on obesity sparked by Honourable Prime Minister Shri Narendra Modi 3P\'s Mann Ki Bast address (episode 119), where he highlighted the growing concern and encouraged people to reduce their oil consumption by 10%.',
  ),
  Quiz(
    title: 'Play True Quiz',
    fromDate: DateTime(2025, 4, 1),
    toDate: DateTime(2025, 4, 30),
    questions: 10,
    duration: 300,
    reward: 'Exciting Prize',
  ),
  Quiz(
    title: 'Play Cum (Uamors Celebrating Stress-Free Exams)',
    fromDate: DateTime(2025, 3, 20),
    toDate: DateTime(2025, 4, 30),
    questions: 10,
    duration: 300,
    reward: 'E-Certificate',
  ),
  Quiz(
    title: 'Quiz on Know about Crafts of India through the cottage',
    fromDate: DateTime(2025, 3, 11),
    toDate: DateTime(2025, 4, 30),
    questions: 5,
    duration: 300,
    reward: 'Exciting Prize',
  ),
  Quiz(
    title: 'Another Long Quiz Title to Test Overflow',
    fromDate: DateTime(2025, 5, 1),
    toDate: DateTime(2025, 5, 15),
    questions: 15,
    duration: 450,
    reward: 'Special Badge',
    description:
        'This is a quiz with a longer title and a more detailed description to check how the layout handles longer text content.',
  ),
];

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final Color primaryColor;
  final Color accentColor;

  const QuizCard({
    Key? key,
    required this.quiz,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedFromDate = DateFormat('MMM d, yyyy').format(quiz.fromDate);
    final formattedToDate = DateFormat('MMM d, yyyy').format(quiz.toDate);
    final durationInMinutes = quiz.duration ~/ 60;

    return Card(
      color: Colors.white,
      shadowColor: Colors.grey.shade200,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (quiz.subtitle != null) ...[
              Text(
                quiz.subtitle!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              quiz.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Starts: ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: formattedFromDate,
                        style: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Ends: ',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: formattedToDate,
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )),
                // Text('Starts: $formattedFromDate',
                //     style: TextStyle(color: Colors.green.shade600)),
                // Text('Ends: $formattedToDate',
                //     style: TextStyle(color: Colors.red.shade600)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(quiz.questions.toString(), 'Questions',
                    Icons.question_mark_outlined, primaryColor),
                _buildInfoColumn('$durationInMinutes min', 'Duration',
                    Icons.timer_outlined, primaryColor),
                Expanded(
                  // Make reward text take available space
                  child: Text(
                    quiz.reward,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700),
                    overflow:
                        TextOverflow.ellipsis, // Handle potential overflow
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuizScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Play Now'),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    // Implement view T&C functionality
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accentColor,
                    side: BorderSide(color: accentColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('View T&C'),
                ),
              ],
            ),
            if (quiz.description != null) ...[
              const SizedBox(height: 12),
              Divider(thickness: 1, color: Colors.grey.shade200),
              const SizedBox(height: 12),
              Text(
                quiz.description!,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
      String value, String label, IconData icon, Color color) {
    return Expanded(
      // Distribute space evenly
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
