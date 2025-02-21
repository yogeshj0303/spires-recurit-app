import 'dart:convert';
import 'package:spires_app/Constants/exports.dart';
import 'package:http/http.dart' as http;
import 'package:spires_app/Model/job_model.dart';
import 'package:spires_app/Services/api_service.dart';

class CityModel {
  final String cityName;
  CityModel({required this.cityName});
}

class JobsModel {
  final int jobId;
  final String jobTitle;
  final String jobType;
  final String postDate;
  final String experience;
  final String aboutJob;
  final String location;
  final String salary;
  final String skill;
  final String openings;
  final String probSalary;
  final String probDuration;
  final String lastDate;
  final bool isApplied;
  final bool isSaved;
  final String companyName;
  final String cEmail;
  final String website;
  final String logo;
  final String industry;
  final String cDescription;
  final String jobPosted;
  final String hired;
  final String hiringSince;
  final String lat;
  final String long;

  JobsModel(
      {required this.lat,
      required this.long,
      required this.jobId,
      required this.jobTitle,
      required this.jobType,
      required this.postDate,
      required this.experience,
      required this.aboutJob,
      required this.location,
      required this.salary,
      required this.skill,
      required this.openings,
      required this.probSalary,
      required this.probDuration,
      required this.lastDate,
      required this.isApplied,
      required this.isSaved,
      required this.companyName,
      required this.cEmail,
      required this.website,
      required this.logo,
      required this.industry,
      required this.cDescription,
      required this.jobPosted,
      required this.hired,
      required this.hiringSince});
}

class NearbyJobController extends GetxController {
  RxBool isDataLoading = false.obs;
  RxBool isNLoading = false.obs;
  RxInt count = 0.obs;
  RxList<CityModel> cities = <CityModel>[].obs;
  RxList<CityModel> filteredCities = <CityModel>[].obs;
  RxList<JobsModel> jobs = <JobsModel>[].obs;

  // Set fixed radius of 50km
  final double radius = 50.0;

  @override
  void onInit() {
    super.onInit();
    getCities();
    getJobs();
  }

  Future<void> getCities() async {
    isDataLoading.value = true;
    const url = '${apiUrl}showLocation';
    
    try {
      final response = await ApiService.makeRequest(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          List<CityModel> allCity = (data['data'] as List)
              .map((e) => CityModel(cityName: e['location']))
              .toList();
          cities.value = allCity;
        } else {
          Fluttertoast.showToast(msg: 'Something went wrong');
        }
      } else {
        Fluttertoast.showToast(
            msg: '${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      isDataLoading.value = false;
    }
  }

  getFilteredCities(String query) {
    filteredCities.value = cities.where((e) {
      final inputText = query.toLowerCase();
      final cit = e.cityName.toLowerCase();
      return cit.contains(inputText);
    }).toList();
  }

  Future<JobModel> showNearbyJobs(String cityName) async {
    final url = '${apiUrl}getMatchingJobs?location=$cityName&user_id=${MyController.id}';
      try {
      final response = await ApiService.makeRequest(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          return JobModel.fromJson(data);
        } else {
          throw Exception('Something went wrong');
        }
      } else {
        throw Exception('Internal server error ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      throw Exception('Unable to load data');
    }
  }

  Future<void> getJobs() async {
    isNLoading.value = true;
    final url = '${apiUrl}job?user_id=${MyController.id}&latitude=${LocationServices.latitude}&longitude=${LocationServices.longitude}&radius=$radius';
    
    try {
      final response = await ApiService.makeRequest(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          List<JobsModel> allJobs = (data['data'] as List)
              .map((e) => JobsModel(
                  lat: e['admin']?['latitude'] ?? '0.0',
                  long: e['admin']?['longitude'] ?? '0.0',
                  jobId: e['id'] ?? 0,
                  jobTitle: e['job_title'] ?? '',
                  jobType: e['job_type'] ?? '',
                  postDate: e['post_date'] ?? '',
                  experience: e['experience'] ?? '',
                  aboutJob: e['about_job'] ?? '',
                  location: e['location'] ?? '',
                  salary: e['salary'] ?? '',
                  skill: e['skills'] ?? '',
                  openings: e['openings'] ?? '',
                  probSalary: e['probation_salary'] ?? '',
                  probDuration: e['probation_duration'] ?? '',
                  lastDate: e['last_date'] ?? '',
                  isApplied: e['is_applied'] ?? false,
                  isSaved: e['is_saved'] ?? false,
                  companyName: e['admin']?['username'] ?? 'Unknown Company',
                  cEmail: e['admin']?['email'] ?? '',
                  website: e['admin']?['website'] ?? '',
                  logo: e['admin']?['logo'] ?? '',
                  industry: e['admin']?['industry'] ?? '',
                  cDescription: e['admin']?['description'] ?? '',
                  jobPosted: e['job_posted'] ?? '0',
                  hired: e['candidate_hired'] ?? '0',
                  hiringSince: e['date'] ?? ''))
              .toList();
          jobs.value = allJobs;
        } else {
          Fluttertoast.showToast(msg: data['message'] ?? 'Something went wrong');
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error fetching jobs: $e');
    } finally {
      isNLoading.value = false;
    }
  }
}
