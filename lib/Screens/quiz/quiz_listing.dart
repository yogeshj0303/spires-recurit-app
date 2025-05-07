import 'package:flutter/material.dart';
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Models/quiz_result_model.dart';
import 'package:spires_app/Screens/quiz/games.dart';
import 'package:intl/intl.dart';
import 'package:spires_app/Models/quiz_model.dart';
import 'package:spires_app/Screens/quiz/quiz_registration.dart';
import 'package:spires_app/Services/api_service.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({Key? key}) : super(key: key);

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Quiz> _quizList = []; // This now uses Quiz from quiz_model.dart
  List<Quiz> _filteredQuizzes = [];
  final Color _primaryOrange = Colors.orange.shade400;
  final Color _accentOrange = Colors.orange.shade600;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.fetchQuizzes();
      setState(() {
        _quizList = response.data.quizzes;
        _filteredQuizzes = _quizList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      _filteredQuizzes = _quizList.where((quiz) {
        final titleMatch = quiz.title.toLowerCase().contains(query);
        final subtitleMatch =
            false; // Removed subtitle check as it doesn't exist in Quiz
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchQuizzes,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchQuizzes,
                  child: _filteredQuizzes.isEmpty
                      ? const Center(
                          child: Text('No quizzes found.',
                              style: TextStyle(fontSize: 16)),
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
                ),
      backgroundColor: Colors.white,
    );
  }
}

class QuizCard extends StatefulWidget {
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
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  QuizResultDetail? _attempt;

  @override
  void initState() {
    super.initState();
    _loadAttempt();
  }

  Future<void> _loadAttempt() async {
    try {
      final c = Get.find<MyController>();
      
      // If in guest mode, don't try to load attempts
      if (c.isGuestMode.value) {
        setState(() {
          _attempt = null;
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
          _attempt = null;
        });
        return;
      }

      print('Loading quiz attempt for:');
      print('User ID: $userId');
      print('User Type: $userType');

      final results = await ApiService.fetchUserQuizResults(userId, userType: userType);
      
      if (!mounted) return;

      setState(() {
        try {
          _attempt = results.quizzes.firstWhere(
            (quiz) => quiz.quizId == widget.quiz.id,
          );
        } catch (e) {
          _attempt = null;
        }
      });
    } catch (e) {
      print('Error in _loadAttempt: $e');
      if (!mounted) return;
      setState(() {
        _attempt = null;
      });
    }
  }

  void _showResultDialog() {
    if (_attempt == null) return;

    final score = _attempt!.calculateScore();
    final correctAnswers =
        _attempt!.result.where((q) => q.answerStatus == 'Correct').length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle_rounded,
                color: Colors.green.shade400, size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Quiz Result',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.amber.shade400,
                  size: 48,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Score: $score%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$correctAnswers out of ${_attempt!.totalQuestions} correct',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildResultStatRow(
                    'Questions Attempted',
                    '${_attempt!.attemptedQuestions}/${_attempt!.totalQuestions}',
                    Icons.question_answer_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildResultStatRow(
                    'Completion Date',
                    DateFormat('MMM d, yyyy').format(_attempt!.participatedOn),
                    Icons.calendar_today_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildResultStatRow(
                    'Accuracy',
                    '${(correctAnswers / _attempt!.totalQuestions * 100).round()}%',
                    Icons.analytics_outlined,
                  ),
                ],
              ),
            ),
            if (_attempt!.certificateUrl != null) ...[
              const SizedBox(height: 16), // Reduced from 20 to 16
              Center(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      launchUrl(Uri.parse(_attempt!.certificateUrl!)),
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Download Certificate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              left: 0,
              right: 0,
              bottom: 0, // Add bottom padding
              top: 0, // Remove top padding since content has spacing
            ),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.primaryColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.gavel_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Content
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.quiz.termscondition != null)
                      Html(
                        data: widget.quiz.termscondition!,
                        style: {
                          "p": Style(
                            color: Colors.grey.shade800,
                            fontSize: FontSize(14),
                            lineHeight: LineHeight(1.5),
                          ),
                          "strong": Style(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                          "ul": Style(
                            margin: Margins.only(top: 8, bottom: 8),
                          ),
                          "li": Style(
                            color: Colors.grey.shade800,
                            fontSize: FontSize(14),
                            lineHeight: LineHeight(1.5),
                          ),
                        },
                      )
                    else
                      Text(
                        'No terms and conditions available.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedFromDate = DateFormat('MMM d').format(widget.quiz.fromDate);
    final formattedToDate = DateFormat('MMM d').format(widget.quiz.toDate);
    final durationInMinutes = widget.quiz.duration;

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Dates
                Text(
                  widget.quiz.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailChip(
                        Icons.calendar_today_rounded,
                        'Starts: $formattedFromDate',
                        Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildDetailChip(
                        Icons.event_busy_rounded,
                        'Ends: $formattedToDate',
                        Colors.red.shade700,
                      ),
                    ),
                  ],
                ),

                // Quiz Stats
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        Icons.quiz_rounded,
                        '${widget.quiz.questionsCount}',
                        'Questions',
                        widget.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatItem(
                        Icons.timer_rounded,
                        '$durationInMinutes',
                        'Minutes',
                        widget.primaryColor,
                      ),
                    ),
                  ],
                ),

                // Description
                if (widget.quiz.description != null) ...[
                  const SizedBox(height: 12),
                  Html(
                    data: widget.quiz.description!,
                    style: {
                      "p": Style(
                        color: Colors.grey.shade800,
                        fontSize: FontSize(13),
                        lineHeight: LineHeight(1.4),
                        margin: Margins.zero,
                      ),
                      "strong": Style(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    },
                  ),
                ],

                // Buttons
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final c = Get.find<MyController>();
                          if (c.isGuestMode.value) {
                            Get.to(() => QuizRegistrationForm(
                                  quizId: widget.quiz.id,
                                  duration: widget.quiz.duration,
                                ));
                          } else if (_attempt == null) {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  quizId: widget.quiz.id,
                                  duration:
                                      widget.quiz.duration, // Pass the duration
                                  onQuizComplete: (score) async {
                                    await _loadAttempt();
                                  },
                                ),
                              ),
                            );
                            if (result == true) {
                              await _loadAttempt();
                            }
                          } else {
                            _showResultDialog();
                          }
                        },
                        icon: Icon(
                          _attempt == null
                              ? Icons.play_arrow_rounded
                              : Icons.bar_chart_rounded,
                          size: 20,
                        ),
                        label: Text(
                            _attempt == null ? 'Start Quiz' : 'View Result'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _attempt == null
                              ? widget.primaryColor
                              : Colors.green.shade600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showTermsDialog,
                        icon: const Icon(Icons.gavel_rounded, size: 18),
                        label: const Text('T&C'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: widget.accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: widget.accentColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultStatRow(String label, String value, IconData icon) {
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
}