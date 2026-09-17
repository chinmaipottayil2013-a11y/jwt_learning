import 'package:flutter/material.dart';
import 'package:jwt_learning/screens/auth_screen.dart';
import 'package:jwt_learning/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs=await SharedPreferences.getInstance();
  final isLoggedIn=prefs.getString('tokenKey')!=null;
  runApp(MyApp(isLoggedIn:isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn, });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home:isLoggedIn?const HomeScreen():const AuthScreen());
  }
}
