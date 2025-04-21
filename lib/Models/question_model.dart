class QuestionResponse {
  final bool status;
  final List<Question> questionAnswer;

  QuestionResponse({
    required this.status,
    required this.questionAnswer,
  });

  factory QuestionResponse.fromJson(Map<String, dynamic> json) {
    var questionsList = json['question_answer'] as List? ?? [];
    return QuestionResponse(
      status: json['status'] ?? false,
      questionAnswer: questionsList.map((q) => Question.fromJson(q)).toList(),
    );
  }
}

class Question {
  final int id;
  final int quizId;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption;
  final DateTime createdAt;
  final DateTime updatedAt;

  Question({
    required this.id,
    required this.quizId,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      quizId: json['quiz_id'] ?? 0,
      question: json['question'] ?? '',
      optionA: json['A'] ?? '',
      optionB: json['B'] ?? '',
      optionC: json['C'] ?? '',
      optionD: json['D'] ?? '',
      correctOption: json['correct_option'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
    );
  }
}
