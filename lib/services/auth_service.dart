import 'dart:convert';

import 'package:dream_sauna/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/utils/apis.dart';

class AuthService {
  String baseUrl = 'http://calcsoft.saunamaterialkit.com/api';


  Future<String?> loginUser(String email, String password) async {
    final url = Uri.parse(Apis.loginApi);
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw Exception('User Login');
    }
  }

//dell this

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    var url = Uri.parse(Apis.loginApi);
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
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.api_token = 'Bearer ' + data['access_token'];

      return user;
    } else {
      throw Exception('User Login');
    }
  }
}
