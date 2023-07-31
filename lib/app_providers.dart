import 'package:flutter/cupertino.dart';

class ArticlesProvider extends ChangeNotifier {
  List _data = [];

  List get data => _data;

  set data(List value) {
    _data = value;
  }
  List _tests = [];

  List get tests => _tests;

  set tests(List value) {
    _tests = value;
    notifyListeners();
  }
  void addItem({required String id,required Map<String,dynamic> data}){
    _tests.add(id);
    _data.add(data);
    notifyListeners();
  }
  void removeItem({required String id,required Map<String,dynamic> data}){
    _tests.remove(id);
    _data.remove(data);

    notifyListeners();
  }

}
class DrawerProvider extends ChangeNotifier {
  String _selcted = "00";

  String get selcted => _selcted;

  set selcted(String value) {
    _selcted = value;
    notifyListeners();
  }


}