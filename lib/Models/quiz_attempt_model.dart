// class QuizAttempt {
//   final int quizId;
//   final int score;
//   final DateTime attemptDate;

//   QuizAttempt({
//     required this.quizId,
//     required this.score,
//     required this.attemptDate,
//   });

//   factory QuizAttempt.fromJson(Map<String, dynamic> json) {
//     return QuizAttempt(
//       quizId: json['quizId'],
//       score: json['score'],
//       attemptDate: DateTime.parse(json['attemptDate']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'quizId': quizId,
//       'score': score,
//       'attemptDate': attemptDate.toIso8601String(),
//     };
//   }
// }
