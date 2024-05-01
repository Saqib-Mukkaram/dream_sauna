
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dream_sauna/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {

  String baseUrl = 'http://calcsoft.saunamaterialkit.com/api';

  static late SharedPreferences _preferences;


  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    var url = Uri.parse('$baseUrl/login');
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data);
      // user.api_token = 'Bearer ' + data['api_token'];

      return user;
    } else {
      throw Exception('Gagal Login');
    }
  }






  static const _keyUserName = 'name';
  static const _keyUserPhone = 'phone';
  static const _keyUserEmail = 'email';
  static const _keyBusinessName = 'business_name';
  static const _keyBusinessAddress = 'business_address';
  static const _keyBusinessDetail = 'business_detail';
  static const _keyProfileImage = 'profile_image';
  static const _keyGovtPhoto = 'govt_photo';
  static const _keyQRCode = 'qrcode_url';
  static const _keyTokken = 'api_token';
  static const _keyType = 'type';


  Future<dynamic> init(dynamic user) async {
    _preferences = await SharedPreferences.getInstance();
    await _preferences.setString(_keyUserName, jsonEncode(user.data.name));
    await _preferences.setString(_keyUserPhone, jsonEncode(user.data.phone));
    await _preferences.setString(_keyUserEmail, jsonEncode(user.data.email));
    await _preferences.setString(_keyBusinessName, jsonEncode(user.data.business_name));
    await _preferences.setString(_keyBusinessAddress, jsonEncode(user.data.business_address));
    await _preferences.setString(_keyBusinessDetail, jsonEncode(user.data.business_detail));
    await _preferences.setString(_keyProfileImage, jsonEncode(user.data.profile_image));
    await _preferences.setString(_keyGovtPhoto, jsonEncode(user.data.govt_photo));
    await _preferences.setString(_keyQRCode, jsonEncode(user.data.qrcode_url));
    await _preferences.setString(_keyTokken, jsonEncode(user.data.api_token));
    await _preferences.setString(_keyType, jsonEncode(user.data.type));
  }

  static String? getUserName() =>  _preferences.getString(_keyUserName);
  static String? getUserPhone() =>  _preferences.getString(_keyUserPhone);
  static String? getUserEmail() =>  _preferences.getString(_keyUserEmail);
  static String? getBusinessName() =>  _preferences.getString(_keyBusinessName);
  static String? getBusinessAddress() =>  _preferences.getString(_keyBusinessAddress);
  static String? getBusinessDetail() =>  _preferences.getString(_keyBusinessDetail);
  static String? getProfileImage() =>  _preferences.getString(_keyProfileImage);
  static String? getGovtPhoto() =>  _preferences.getString(_keyGovtPhoto);
  static String? getQRCode() =>  _preferences.getString(_keyQRCode);
  static String? getTokken() =>  _preferences.getString(_keyTokken);
  static String? getUserType() =>  _preferences.getString(_keyType);


  Future getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var d = prefs.getString('userData');
    if (d != null) {
      return jsonDecode(d);
    } else {
      return null;
    }
  }

  Future<bool> setUser(user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(user));
    await prefs.setString('name', jsonEncode(user.data));
    await prefs.setString('tokken', user.data.api_token);
    await prefs.setString('profilePhoto', user.data.profile_image);
    await prefs.setBool('loggedIn', true);
    return true;
  }





}