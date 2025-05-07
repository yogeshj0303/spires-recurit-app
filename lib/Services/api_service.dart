import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spires_app/Constants/exports.dart';
import 'package:spires_app/Models/counsellor_model.dart';
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

  static Future<QuizResultResponse> fetchUserQuizResults(int userId, {String userType = 'user'}) async {
    try {
      // Get the correct user type and ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final isOlympiadLoggedIn = prefs.getBool('is_olympiad_logged_in') ?? false;
      
      // If olympiad user is logged in, use olympiad user ID and type
      if (isOlympiadLoggedIn) {
        final olympiadUserData = prefs.getString('olympiad_user_data');
        if (olympiadUserData != null) {
          try {
            final userData = jsonDecode(olympiadUserData);
            userId = userData['data']['id'] ?? 0;
            userType = 'olympiad_user';
          } catch (e) {
            print('Error parsing olympiad user data: $e');
            throw Exception('Failed to parse olympiad user data: $e');
          }
        }
      }

      print('Fetching quiz results for:');
      print('User ID: $userId');
      print('User Type: $userType');

      final response = await makeRequest(
        'https://www.spiresrecruit.com/api/quiz-by-user/$userId/$userType',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Quiz results response status: ${response.statusCode}');
      print('Quiz results response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = QuizResultResponse.fromJson(jsonDecode(response.body));
        
        // Store the results in SharedPreferences for quick access
        await prefs.setString('quiz_results_${userType}_$userId', response.body);
        
        return result;
      } else {
        throw Exception('Failed to load quiz results: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quiz results: $e');
      throw Exception('Failed to fetch quiz results: $e');
    }
  }

  static Future<QuizResultDetail> submitQuiz(QuizSubmission submission) async {
    try {
      // Get user type and appropriate user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userType = prefs.getString('user_type') ?? 'user';
      
      // Get the appropriate user ID based on user type
      int userId;
      if (userType == 'olympiad_user') {
        userId = prefs.getInt('olympiad_user_id') ?? submission.userId;
      } else {
        userId = submission.userId;
      }

      // Validate user ID
      if (userId <= 0) {
        throw Exception('Invalid user ID. Please login or register first.');
      }

      print('Submitting quiz with:');
      print('User ID: $userId');
      print('User Type: $userType');
      print('Quiz ID: ${submission.quizId}');
      print('Number of answers: ${submission.answers.length}');
      
      final queryParameters = {
        'user_id': userId.toString(),
        'quiz_id': submission.quizId.toString(),
        'user_type': userType,
      };

      // Add answers to query parameters
      for (var i = 0; i < submission.answers.length; i++) {
        queryParameters['answers[$i][question_id]'] =
            submission.answers[i].questionId.toString();
        queryParameters['answers[$i][answer]'] = submission.answers[i].answer;
      }

      print('Query Parameters: $queryParameters');

      final uri = Uri.https(
        'www.spiresrecruit.com',
        '/api/quiz-outcomes',
        queryParameters,
      );

      print('Request URL: ${uri.toString()}');

      final response = await makeRequest(
        uri.toString(),
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

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
        await fetchUserQuizResults(userId, userType: userType);

        // Store the result locally
        await prefs.setString(
          'quiz_${submission.quizId}',
          jsonEncode(quizResult.toJson()),
        );

        return quizResult;
      } else {
        final errorMessage = response.body.isNotEmpty 
            ? jsonDecode(response.body)['message'] ?? 'Unknown error'
            : 'Server error ${response.statusCode}';
        throw Exception('Failed to submit quiz: $errorMessage');
      }
    } catch (e) {
      print('Error in submitQuiz: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to submit quiz: $e');
    }
  }

  static Future<CounsellorsResponse> fetchCounsellors() async {
    try {
      final response = await makeRequest(
        'https://spiresrecruit.com/api/career-counsellors',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return CounsellorsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load counsellors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch counsellors: $e');
    }
  }

  // static Future<Map<String, dynamic>> registerForQuiz(Map<String, dynamic> registrationData) async {
  //   try {
  //     final response = await makeRequest(
  //       'https://www.spiresrecruit.com/api/register-quiz-user',
  //       method: 'POST',
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: jsonEncode(registrationData),
  //     );

  //     final responseData = jsonDecode(response.body);
      
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return responseData;
  //     } else {
  //       return {
  //         'status': false,
  //         'message': responseData['message'] ?? 'Registration failed. Please try again.',
  //       };
  //     }
  //   } catch (e) {
  //     return {
  //       'status': false,
  //       'message': 'An error occurred during registration: $e',
  //     };
  //   }
  // }

  static Future<Map<String, dynamic>> registerForOlympiad({
    required String studentName,
    required String parentName,
    required String mobile,
    required String standard,
    required String password,
    required String parentEmail,
  }) async {
    try {
      final queryParameters = {
        'student_name': studentName,
        'parent_name': parentName,
        'mobile': mobile,
        'standard': standard,
        'password': password,
        'parent_email': parentEmail,
      };

      final uri = Uri.https(
        'spiresrecruit.com',
        '/api/olympaid-registration',
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

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'Registration failed. Please try again.',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'An error occurred during registration: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> olympiadLogin({
    required String parentEmail,
    required String password,
  }) async {
    try {
      final queryParameters = {
        'parent_email': parentEmail,
        'password': password,
      };

      final uri = Uri.https(
        'spiresrecruit.com',
        '/api/olympaid-login',
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

      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Ensure the response has the correct structure
        if (responseData['data'] != null && responseData['data']['id'] != null) {
          return {
            'status': true,
            'message': 'Login successful',
            'data': responseData['data'],
          };
        } else {
          return {
            'status': false,
            'message': 'Invalid response format from server',
          };
        }
      } else {
        return {
          'status': false,
          'message': responseData['message'] ?? 'Login failed. Please check your credentials.',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'An error occurred during login: $e',
      };
    }
  }

  static Future<void> clearOlympiadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear olympiad specific data
      await prefs.remove('olympiad_user_id');
      await prefs.remove('olympiad_user_data');
      await prefs.setBool('is_olympiad_logged_in', false);
      
      // Clear user type if it was olympiad
      final userType = prefs.getString('user_type');
      if (userType == 'olympiad_user') {
        await prefs.remove('user_type');
        await prefs.remove('user_id');
        await prefs.setBool('is_logged_in', false);
      }
      
      // Clear quiz results
      await prefs.remove('quiz_results_olympiad_user_${MyController.id}');
      
      // Reset MyController
      MyController.id = 0;
      
      print('Olympiad session cleared successfully');
    } catch (e) {
      print('Error clearing olympiad session: $e');
    }
  }
}