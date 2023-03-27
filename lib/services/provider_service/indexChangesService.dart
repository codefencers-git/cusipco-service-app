import 'package:flutter/cupertino.dart';

class CheckIndexChange with ChangeNotifier {
  int currentIndex = 0;

  setIndex(index) {
    currentIndex = index;
    notifyListeners();
  }
}
