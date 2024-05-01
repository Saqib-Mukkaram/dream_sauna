class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.business_name,
    required this.business_address,
    required this.business_detail,
    required this.profile_image,
    required this.govt_photo,
    required this.qrcode_url,
    required this.api_token,
    required this.type,
  });
  
   int? id;
   String? name;
   String? phone;
   String? email;
   String? business_name;
   String? business_address;
   String? business_detail;
   String? profile_image;
   String? govt_photo;
   String? qrcode_url;
   String? api_token;
   String? type;
  

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id : json['id'],
    name : json['name'],
    phone : json['phone'],
    email : json['email'],
    business_name : json['business_name'],
    business_address : json['business_address'],
    business_detail : json['business_detail'],
    profile_image : json['profile_image'],
    govt_photo : json['govt_photo'],
    qrcode_url : json['qrcode_url'],
    api_token : json['api_token'],
    type : json['type'],

  );


  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'business_name': business_name,
      'business_address': business_address,
      'business_detail': business_detail,
      'profile_image': profile_image,
      'govt_photo': govt_photo,
      'qrcode_url': qrcode_url,
      'api_token': api_token,
      'type': type,

  };
}
