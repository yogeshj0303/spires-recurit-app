class CounsellorsResponse {
  final bool success;
  final List<Counsellor> data;

  CounsellorsResponse({
    required this.success,
    required this.data,
  });

  factory CounsellorsResponse.fromJson(Map<String, dynamic> json) {
    return CounsellorsResponse(
      success: json['success'],
      data: List<Counsellor>.from(json['data'].map((x) => Counsellor.fromJson(x))),
    );
  }
}

class Counsellor {
  final int id;
  final String name;
  final String address;
  final String experience;
  final String contactNumber;
  final String image;
  final String speciality;
  final String createdAt;
  final String updatedAt;
  final List<Timing> timings;
  final List<Service> services;

  Counsellor({
    required this.id,
    required this.name,
    required this.address,
    required this.experience,
    required this.contactNumber,
    required this.image,
    required this.speciality,
    required this.createdAt,
    required this.updatedAt,
    required this.timings,
    required this.services,
  });

  factory Counsellor.fromJson(Map<String, dynamic> json) {
    return Counsellor(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      experience: json['experience'],
      contactNumber: json['contact_number'],
      image: json['image'],
      speciality: json['speciality'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      timings: List<Timing>.from(json['timings'].map((x) => Timing.fromJson(x))),
      services: List<Service>.from(json['services'].map((x) => Service.fromJson(x))),
    );
  }
}

class Timing {
  final int id;
  final int counsellorId;
  final String day;
  final String startTime;
  final String endTime;
  final String updatedAt;
  final String createdAt;

  Timing({
    required this.id,
    required this.counsellorId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Timing.fromJson(Map<String, dynamic> json) {
    return Timing(
      id: json['id'],
      counsellorId: json['counsellor_id'],
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
    );
  }
}

class Service {
  final int id;
  final int counsellorId;
  final String title;
  final String description;
  final String updatedAt;
  final String createdAt;

  Service({
    required this.id,
    required this.counsellorId,
    required this.title,
    required this.description,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      counsellorId: json['counsellor_id'],
      title: json['title'],
      description: json['description'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
    );
  }
} 