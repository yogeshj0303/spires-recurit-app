import 'dart:convert';

CertificateModel certificateModelFromJson(String str) =>
    CertificateModel.fromJson(json.decode(str));

String certificateModelToJson(CertificateModel data) =>
    json.encode(data.toJson());

class CertificateModel {
  CertificateModel({
    this.status,
    this.data,
  });

  CertificateModel.fromJson(dynamic json) {
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CertificateData.fromJson(v));
      });
    }
  }

  String? status;
  List<CertificateData>? data;

  CertificateModel copyWith({
    String? status,
    List<CertificateData>? data,
  }) =>
      CertificateModel(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class CertificateData {
  CertificateData({
    this.id,
    this.userId,
    this.certificateName,
    this.filePath,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.lastName,
    this.userEmail,
    this.fileUrl,
  });

  CertificateData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    certificateName = json['certificate_name'];
    filePath = json['file_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    lastName = json['last_name'];
    userEmail = json['user_email'];
    fileUrl = json['file_url'];
  }

  int? id;
  int? userId;
  String? certificateName;
  String? filePath;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? lastName;
  String? userEmail;
  String? fileUrl;

  CertificateData copyWith({
    int? id,
    int? userId,
    String? certificateName,
    String? filePath,
    String? createdAt,
    String? updatedAt,
    String? name,
    String? lastName,
    String? userEmail,
    String? fileUrl,
  }) =>
      CertificateData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        certificateName: certificateName ?? this.certificateName,
        filePath: filePath ?? this.filePath,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        userEmail: userEmail ?? this.userEmail,
        fileUrl: fileUrl ?? this.fileUrl,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['certificate_name'] = certificateName;
    map['file_path'] = filePath;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['name'] = name;
    map['last_name'] = lastName;
    map['user_email'] = userEmail;
    map['file_url'] = fileUrl;
    return map;
  }
} 