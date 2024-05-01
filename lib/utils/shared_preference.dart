
import 'package:dream_sauna/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {

  // Future<bool> saveUser(UserModel user) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   prefs.setInt('id',user.id);
  //   prefs.setString('name',user.name);
  //   prefs.setString('phone',user.phone);
  //   prefs.setString('email',user.email);
  //   prefs.setString('business_name',user.business_name);
  //   prefs.setString('business_address',user.business_address);
  //   prefs.setString('business_detail',user.business_detail);
  //   prefs.setString('profile_image',user.profile_image);
  //   prefs.setString('govt_photo',user.govt_photo);
  //   prefs.setString('qrcode_url',user.qrcode_url);
  //   prefs.setString('api_token',user.api_token);
  //   prefs.setString('type',user.type);
  //
  //   return prefs.commit();
  //
  // }

  Future<UserModel> getUser ()  async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt("id");
    String? name = prefs.getString("name");
    String? phone = prefs.getString("phone");
    String? email = prefs.getString("email");
    String? business_name = prefs.getString("business_name");
    String? business_address = prefs.getString("business_address");
    String? business_detail = prefs.getString("business_detail");
    String? profile_image = prefs.getString("profile_image");
    String? govt_photo = prefs.getString("govt_photo");
    String? qrcode_url = prefs.getString("qrcode_url");
    String? api_token = prefs.getString("api_token");
    String? type = prefs.getString("type");


    return UserModel(
        id: id,
        name: name,
        phone: phone,
        email: email,
        business_name: business_name,
        business_address: business_address,
        business_detail: business_detail,
        profile_image: profile_image,
        govt_photo: govt_photo,
        qrcode_url: qrcode_url,
        api_token: api_token,
        type: type,

    );

  }

  void removeUser() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('id');
    prefs.remove('name');
    prefs.remove('phone');
    prefs.remove('email');
    prefs.remove('email');
    prefs.remove('business_name');
    prefs.remove('business_address');
    prefs.remove('business_detail');
    prefs.remove('profile_image');
    prefs.remove('govt_photo');
    prefs.remove('qrcode_url');
    prefs.remove('api_token');
    prefs.remove('type');

  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("api_token");
    return token;
  }

}