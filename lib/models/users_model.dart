class UserProfile {
  bool? emailVerified;
  bool? phoneVerified;
  List<String> deviceIds = [];
  List<String>? backgroundImages = [];
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? type;
  String? avatar;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserProfile({
    this.emailVerified,
    this.phoneVerified,
    this.backgroundImages,
    this.sId,
    this.name,
    this.email,
    this.phone,
    this.type,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    emailVerified = json['emailVerified'];
    phoneVerified = json['phoneVerified'];
    backgroundImages = [];
    deviceIds = [];
    // if (json['backgroundImages'] != null) {
    // 	backgroundImages = <Null>[];
    // 	json['backgroundImages'].forEach((v) { backgroundImages!.add(new Null.fromJson(v)); });
    // }
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    type = json['type'];
    avatar = json['avatar'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailVerified'] = this.emailVerified;
    data['phoneVerified'] = this.phoneVerified;
    if (this.deviceIds != null) {
      data['deviceIds'] = this.deviceIds.map((v) => v).toList();
    }
    if (this.backgroundImages != null) {
      data['backgroundImages'] = this.backgroundImages!.map((v) => v).toList();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['type'] = this.type;
    data['avatar'] = this.avatar;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
