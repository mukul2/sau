import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class DrawerProviderProvider extends ChangeNotifier {
  List<String> drawerItems= ["Category","Article","Company info","Logout"];
  int _selectedMenu = 0 ;

  int get selectedMenu => _selectedMenu;

  set selectedMenu(int value) {
    _selectedMenu = value;
    notifyListeners();
  }




}


class TempProvider extends ChangeNotifier {
  Map<String,dynamic>_allData ={};

  Map<String,dynamic> get allData => _allData;

  set allData(Map<String,dynamic> value) {
    _allData = value;
  }

  String? _shareCode;

  String? get shareCode => _shareCode;

  set shareCode(String? value) {
    _shareCode = value;
  }
  DocumentSnapshot? _companyInfo;

  DocumentSnapshot? get companyInfo => _companyInfo;

  set companyInfo(DocumentSnapshot? value) {
    _companyInfo = value;

  }
  DocumentSnapshot? _userInfo;

  DocumentSnapshot? get userInfo => _userInfo;

  set userInfo(DocumentSnapshot? value) {
    _userInfo = value;
  }
  String? _currentShareCode ;

  String? get currentShareCode => _currentShareCode;

  set currentShareCode(String? value) {
    _currentShareCode = value;
  }

  String? _currentShareCodeCustomer;

  String? get currentShareCodeCustomer => _currentShareCodeCustomer;

  set currentShareCodeCustomer(String? value) {
    _currentShareCodeCustomer = value;
  }




}