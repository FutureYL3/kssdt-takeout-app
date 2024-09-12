import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome/welcome_page.dart';
import 'home/home_page.dart';


void main() async{
  // 确保 Flutter 框架已初始化
  WidgetsFlutterBinding.ensureInitialized();
  final bool isLogin = await getLoginStatus();
  runApp(MyApp(isLogin));
}

Future<bool> getLoginStatus() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("Login_Status") ?? false;
  // return false;
}

class MyApp extends StatelessWidget {
  final bool isLogin;

  const MyApp(this.isLogin, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'App Name',
      theme: ThemeData.light(),
      home: isLogin ? const HomePage() : const WelcomePage(),
    );
  }
}

