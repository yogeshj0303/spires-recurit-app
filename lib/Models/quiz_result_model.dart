class QuizResultResponse {
  final bool status;
  final String message;
  final UserInfo user;
  final List<QuizResultDetail> quizzes;

  QuizResultResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.quizzes,
  });

  factory QuizResultResponse.fromJson(Map<String, dynamic> json) {
    var quizzesList = json['quizzes'] as List? ?? [];
    return QuizResultResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      user: UserInfo.fromJson(json['user'] ?? {}),
      quizzes:
          quizzesList.map((quiz) => QuizResultDetail.fromJson(quiz)).toList(),
    );
  }
}

class UserInfo {
  final int id;
  final String name;
  final String email;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class QuizResultDetail {
  final int quizId;
  final String title;
  final DateTime participatedOn;
  final int totalQuestions;
  final int attemptedQuestions;
  final List<QuestionResult> result;
  final String? certificateUrl;

  QuizResultDetail({
    required this.quizId,
    required this.title,
    required this.participatedOn,
    required this.totalQuestions,
    required this.attemptedQuestions,
    required this.result,
    this.certificateUrl,
  });

  factory QuizResultDetail.fromJson(Map<String, dynamic> json) {
    var resultList = json['result'] as List? ?? [];
    return QuizResultDetail(
      quizId: json['quiz_id'] ?? 0,
      title: json['title'] ?? '',
      participatedOn: DateTime.parse(
          json['participated_on'] ?? DateTime.now().toIso8601String()),
      totalQuestions: json['total_questions'] ?? 0,
      attemptedQuestions: json['attempted_questions'] ?? 0,
      result: resultList.map((r) => QuestionResult.fromJson(r)).toList(),
      certificateUrl: json['certificate_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'title': title,
      'participated_on': participatedOn.toIso8601String(),
      'total_questions': totalQuestions,
      'attempted_questions': attemptedQuestions,
      'result': result.map((r) => r.toJson()).toList(),
      'certificate_url': certificateUrl,
    };
  }

  int calculateScore() {
    if (totalQuestions == 0) return 0;
    final correctAnswers =
        result.where((q) => q.answerStatus == 'Correct').length;
    return (correctAnswers / totalQuestions * 100).round();
  }
}

class QuestionResult {
  final String question;
  final Map<String, String> options;
  final String correctAnswer;
  final String? userAnswer;
  final String answerStatus;
  final String answerClass;

  QuestionResult({
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.userAnswer,
    required this.answerStatus,
    required this.answerClass,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      question: json['question'] ?? '',
      options: Map<String, String>.from(json['options'] ?? {}),
      correctAnswer: json['correct_answer'] ?? '',
      userAnswer: json['user_answer'],
      answerStatus: json['answer_status'] ?? '',
      answerClass: json['answer_class'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correct_answer': correctAnswer,
      'user_answer': userAnswer,
      'answer_status': answerStatus,
      'answer_class': answerClass,
    };
  }
}
