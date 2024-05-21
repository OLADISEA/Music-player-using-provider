import 'package:flutter/material.dart';
import 'package:music_player/themes/dark_mode.dart';


import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier{

  //set it initially to light mode
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }


  //toggle theme
  void toggleTheme(){
    if(_themeData == lightMode){
      themeData = darkMode;
    }else{
      themeData = lightMode;
    }
  }
}
