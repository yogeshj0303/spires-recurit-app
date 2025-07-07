import 'dart:convert';

UserSubscriptionPlansModel userSubscriptionPlansModelFromJson(String str) =>
    UserSubscriptionPlansModel.fromJson(json.decode(str));
String userSubscriptionPlansModelToJson(UserSubscriptionPlansModel data) => json.encode(data.toJson());

class UserSubscriptionPlansModel {
  UserSubscriptionPlansModel({
    List<MembershipPlan>? membershipPlans,
    List<UpgradePlan>? upgradePlans,
    List<CertifiedPlan>? certifiedPlans,
  }) {
    _membershipPlans = membershipPlans;
    _upgradePlans = upgradePlans;
    _certifiedPlans = certifiedPlans;
  }

  UserSubscriptionPlansModel.fromJson(dynamic json) {
    if (json['membershipPlans'] != null) {
      _membershipPlans = [];
      json['membershipPlans'].forEach((v) {
        _membershipPlans?.add(MembershipPlan.fromJson(v));
      });
    }
    if (json['upgradePlans'] != null) {
      _upgradePlans = [];
      json['upgradePlans'].forEach((v) {
        _upgradePlans?.add(UpgradePlan.fromJson(v));
      });
    }
    if (json['certifiedPlans'] != null) {
      _certifiedPlans = [];
      json['certifiedPlans'].forEach((v) {
        _certifiedPlans?.add(CertifiedPlan.fromJson(v));
      });
    }
  }
  
  List<MembershipPlan>? _membershipPlans;
  List<UpgradePlan>? _upgradePlans;
  List<CertifiedPlan>? _certifiedPlans;
  
  UserSubscriptionPlansModel copyWith({
    List<MembershipPlan>? membershipPlans,
    List<UpgradePlan>? upgradePlans,
    List<CertifiedPlan>? certifiedPlans,
  }) =>
      UserSubscriptionPlansModel(
        membershipPlans: membershipPlans ?? _membershipPlans,
        upgradePlans: upgradePlans ?? _upgradePlans,
        certifiedPlans: certifiedPlans ?? _certifiedPlans,
      );
      
  List<MembershipPlan>? get membershipPlans => _membershipPlans;
  List<UpgradePlan>? get upgradePlans => _upgradePlans;
  List<CertifiedPlan>? get certifiedPlans => _certifiedPlans;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_membershipPlans != null) {
      map['membershipPlans'] = _membershipPlans?.map((v) => v.toJson()).toList();
    }
    if (_upgradePlans != null) {
      map['upgradePlans'] = _upgradePlans?.map((v) => v.toJson()).toList();
    }
    if (_certifiedPlans != null) {
      map['certifiedPlans'] = _certifiedPlans?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class MembershipPlan {
  MembershipPlan({
    num? id,
    num? userId,
    String? planPrice,
    String? startDate,
    String? expiredDate,
    String? planType,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _planPrice = planPrice;
    _startDate = startDate;
    _expiredDate = expiredDate;
    _planType = planType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  MembershipPlan.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _planPrice = json['plan_price'];
    _startDate = json['start_date'];
    _expiredDate = json['expired_date'];
    _planType = json['plan_type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  
  num? _id;
  num? _userId;
  String? _planPrice;
  String? _startDate;
  String? _expiredDate;
  String? _planType;
  String? _createdAt;
  String? _updatedAt;
  
  MembershipPlan copyWith({
    num? id,
    num? userId,
    String? planPrice,
    String? startDate,
    String? expiredDate,
    String? planType,
    String? createdAt,
    String? updatedAt,
  }) =>
      MembershipPlan(
        id: id ?? _id,
        userId: userId ?? _userId,
        planPrice: planPrice ?? _planPrice,
        startDate: startDate ?? _startDate,
        expiredDate: expiredDate ?? _expiredDate,
        planType: planType ?? _planType,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
      
  num? get id => _id;
  num? get userId => _userId;
  String? get planPrice => _planPrice;
  String? get startDate => _startDate;
  String? get expiredDate => _expiredDate;
  String? get planType => _planType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['plan_price'] = _planPrice;
    map['start_date'] = _startDate;
    map['expired_date'] = _expiredDate;
    map['plan_type'] = _planType;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

class UpgradePlan {
  UpgradePlan({
    num? id,
    num? userId,
    num? planId,
    String? planPrice,
    String? startDate,
    String? expiredDate,
    String? planType,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _planId = planId;
    _planPrice = planPrice;
    _startDate = startDate;
    _expiredDate = expiredDate;
    _planType = planType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  UpgradePlan.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _planId = json['plan_id'];
    _planPrice = json['plan_price'];
    _startDate = json['start_date'];
    _expiredDate = json['expired_date'];
    _planType = json['plan_type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  
  num? _id;
  num? _userId;
  num? _planId;
  String? _planPrice;
  String? _startDate;
  String? _expiredDate;
  String? _planType;
  String? _createdAt;
  String? _updatedAt;
  
  UpgradePlan copyWith({
    num? id,
    num? userId,
    num? planId,
    String? planPrice,
    String? startDate,
    String? expiredDate,
    String? planType,
    String? createdAt,
    String? updatedAt,
  }) =>
      UpgradePlan(
        id: id ?? _id,
        userId: userId ?? _userId,
        planId: planId ?? _planId,
        planPrice: planPrice ?? _planPrice,
        startDate: startDate ?? _startDate,
        expiredDate: expiredDate ?? _expiredDate,
        planType: planType ?? _planType,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
      
  num? get id => _id;
  num? get userId => _userId;
  num? get planId => _planId;
  String? get planPrice => _planPrice;
  String? get startDate => _startDate;
  String? get expiredDate => _expiredDate;
  String? get planType => _planType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['plan_id'] = _planId;
    map['plan_price'] = _planPrice;
    map['start_date'] = _startDate;
    map['expired_date'] = _expiredDate;
    map['plan_type'] = _planType;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}

class CertifiedPlan {
  CertifiedPlan({
    num? id,
    num? userId,
    String? planPrice,
    String? startDate,
    String? expiredDate,
    String? planType,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _planPrice = planPrice;
    _startDate = startDate;
    _expiredDate = expiredDate;
    _planType = planType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  CertifiedPlan.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _planPrice = json['plan_price'];
    _startDate = json['start_date'];
    _expiredDate = json['expired_date'];
    _planType = json['plan_type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  
  num? _id;
  num? _userId;
  String? _planPrice;
  String? _startDate;
  String? _expiredDate;
  String? _planType;
  String? _createdAt;
  String? _updatedAt;
  
  CertifiedPlan copyWith({
    num? id,
    num? userId,
    String? planPrice,
    String? startDate,
    String? expiredDate,
    String? planType,
    String? createdAt,
    String? updatedAt,
  }) =>
      CertifiedPlan(
        id: id ?? _id,
        userId: userId ?? _userId,
        planPrice: planPrice ?? _planPrice,
        startDate: startDate ?? _startDate,
        expiredDate: expiredDate ?? _expiredDate,
        planType: planType ?? _planType,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );
      
  num? get id => _id;
  num? get userId => _userId;
  String? get planPrice => _planPrice;
  String? get startDate => _startDate;
  String? get expiredDate => _expiredDate;
  String? get planType => _planType;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['plan_price'] = _planPrice;
    map['start_date'] = _startDate;
    map['expired_date'] = _expiredDate;
    map['plan_type'] = _planType;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
} 