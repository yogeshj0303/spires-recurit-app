import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Models/question_model.dart';
import 'package:spires_app/Models/quiz_model.dart';
import 'package:spires_app/Models/quiz_result_model.dart';
import 'package:spires_app/Models/quiz_submission_model.dart';

class ApiService {
  static const int maxRetries = 3;
  static const Duration initialDelay = Duration(seconds: 1);

  static Future<http.Response> makeRequest(
    String url, {
    String method = 'POST',
    Map<String, String>? headers,
    Object? body,
  }) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (attempts < maxRetries) {
      try {
        http.Response response;

        switch (method.toUpperCase()) {
          case 'POST':
            response = await http.post(
              Uri.parse(url),
              headers: headers,
              body: body,
            );
            break;
          case 'GET':
            response = await http.get(
              Uri.parse(url),
              headers: headers,
            );
            break;
          default:
            throw Exception('Unsupported HTTP method: $method');
        }

        if (response.statusCode == 429) {
          // Get retry-after header or use exponential backoff
          final retryAfter = response.headers['retry-after'];
          if (retryAfter != null) {
            delay = Duration(seconds: int.parse(retryAfter));
          } else {
            delay *= 2; // Exponential backoff
          }

          attempts++;
          if (attempts < maxRetries) {
            await Future.delayed(delay);
            continue;
          }
        }

        return response;
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        await Future.delayed(delay);
        delay *= 2; // Exponential backoff
      }
    }

    throw Exception('Max retries exceeded');
  }

  static Future<QuizResponse> fetchQuizzes() async {
    try {
      final response = await makeRequest(
        'https://www.spiresrecruit.com/api/quizzes',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return QuizResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load quizzes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch quizzes: $e');
    }
  }

  static Future<QuestionResponse> fetchQuestions(int quizId) async {
    try {
      final response = await makeRequest(
        'https://www.spiresrecruit.com/api/quetions_by_id/$quizId',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return QuestionResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch questions: $e');
    }
  }

  static Future<QuizResultResponse> fetchUserQuizResults(int userId) async {
    try {
      final response = await makeRequest(
        'https://www.spiresrecruit.com/api/quiz-by-user/$userId',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return QuizResultResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load quiz results: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch quiz results: $e');
    }
  }

  static Future<QuizResultDetail> submitQuiz(QuizSubmission submission) async {
    try {
      final queryParameters = {
        'user_id': submission.userId.toString(), // Use the actual user ID
        'quiz_id': submission.quizId.toString(),
      };

      // Add answers to query parameters
      for (var i = 0; i < submission.answers.length; i++) {
        queryParameters['answers[$i][question_id]'] =
            submission.answers[i].questionId.toString();
        queryParameters['answers[$i][answer]'] = submission.answers[i].answer;
      }

      final uri = Uri.https(
        'www.spiresrecruit.com',
        '/api/quiz-outcomes',
        queryParameters,
      );

      final response = await makeRequest(
        uri.toString(),
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final quizData = responseData['quiz'];

        final quizResult = QuizResultDetail.fromJson({
          'quiz_id': submission.quizId,
          'title': quizData['title'],
          'participated_on': DateTime.now().toIso8601String(),
          'total_questions': quizData['result'].length,
          'attempted_questions':
              quizData['result'].where((r) => r['user_answer'] != null).length,
          'result': quizData['result'],
          'certificate_url': responseData['certificate_url']
        });

        // Important: Force refresh of quiz results in memory
        await fetchUserQuizResults(submission.userId); // Add this line

        // Store the result locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'quiz_${submission.quizId}',
          jsonEncode(quizResult.toJson()),
        );

        return quizResult;
      } else {
        throw Exception('Failed to submit quiz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to submit quiz: $e');
    }
  }
}
