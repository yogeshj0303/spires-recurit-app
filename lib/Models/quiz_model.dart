class QuizResponse {
  final bool status;
  final String message;
  final QuizData data;

  QuizResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: QuizData.fromJson(json['data'] ?? {}),
    );
  }
}

class QuizData {
  final List<Quiz> quizzes;

  QuizData({required this.quizzes});

  factory QuizData.fromJson(Map<String, dynamic> json) {
    var quizzesList = json['quizzes'] as List? ?? [];
    return QuizData(
      quizzes: quizzesList.map((quiz) => Quiz.fromJson(quiz)).toList(),
    );
  }
}

class Quiz {
  final int id;
  final String title;
  final String? image;
  final DateTime fromDate;
  final DateTime toDate;
  final int duration;
  final String createdBy;
  final String? description;
  final String? quizquetionType;
  final String? termscondition; // Add this field
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? categoryId;
  final int questionsCount;

  Quiz({
    required this.id,
    required this.title,
    this.image,
    required this.fromDate,
    required this.toDate,
    required this.duration,
    required this.createdBy,
    this.description,
    this.quizquetionType,
    this.termscondition, // Add this parameter
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
    required this.questionsCount,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'],
      fromDate: DateTime.parse(json['from_date'] ?? ''),
      toDate: DateTime.parse(json['to_date'] ?? ''),
      duration: json['duration'] ?? 0,
      createdBy: json['created_by'] ?? '',
      description: json['description'],
      quizquetionType: json['quizquetion_type'],
      termscondition: json['termscondition'], // Parse termscondition
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
      categoryId: json['category_id'],
      questionsCount: json['questions_count'] ?? 0,
    );
  }
}
