import 'dart:convert';

import '../modules/home/bindings/user_data.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<UserDataModel> fetchUser(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserDataModel.fromJson(data);
    } else {
      throw Exception('Failed to load users');
    }
  }
}
