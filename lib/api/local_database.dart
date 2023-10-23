import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class DB{
  //static late SharedPreferences prefs;



  static Future<void> setColor(int color) async {
    var prefs = await SharedPreferences.getInstance();
    log('In the db: ${color.toString()}');
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(systemNavigationBarColor: Colors.white, statusBarColor: Color(color)));
    prefs.setInt('selectedColor', color);
  }

  static Future<int> getColor() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt('selectedColor') ?? Colors.indigo.shade900.value;
  }

  static Future<String> getTheme() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme') ?? 'light';
  }

  static Future<void> setTheme(String theme) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', theme);
  }

}