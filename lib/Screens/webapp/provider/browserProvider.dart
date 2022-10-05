import 'package:flutter/material.dart';

class BrowserProvider extends ChangeNotifier {
  String url = 'https://www.google.com/';
  double progressWeb = 0;

  void changeurl(String link) {
    url = link;
    notifyListeners();
  }

  void changeProgress(double ps) {
    progressWeb = ps;
    notifyListeners();
  }
}
