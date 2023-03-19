import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier{

  int screenIndex=1;

  void updateIndex(int index) {
    screenIndex = index;
    notifyListeners();
  }
  int get index=>screenIndex;
}
