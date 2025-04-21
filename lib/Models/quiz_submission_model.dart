class QuizSubmission {
  final int userId;
  final int quizId;
  final List<QuizAnswer> answers;

  QuizSubmission({
    required this.userId,
    required this.quizId,
    required this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'quiz_id': quizId,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}

class QuizAnswer {
  final int questionId;
  final String answer;

  QuizAnswer({
    required this.questionId,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer': answer,
    };
  }
}
