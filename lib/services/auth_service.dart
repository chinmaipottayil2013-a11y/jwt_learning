import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://dadishaapi.kodhatch.com/api/admin/learning/login';


  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(Uri.parse(baseUrl),
          headers: {
            'Content-Type': 'application/json'
          },
          body: jsonEncode({'username':email, 'password': password})
      );
      if(response.statusCode==200){
        final data=jsonDecode(response.body);
        await _saveToken(data['accessToken']);
        return null;
      }
      final data=jsonDecode(response.body);
      return data['message']?? 'Login failed';
    }catch(e){
      return 'Network error';
    }


  }
  Future<void>_saveToken(String token)async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString('tokenKey', token);
  }
  Future<String?>getToken()async{
    final prefs=await SharedPreferences.getInstance();
    return prefs.getString('tokenKey');
  }
  Future<bool>loggedIn()async{
    final token=await getToken();
    return token!=null;
  }
  Future<void>logout()async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.remove('tokenKey');
  }
}