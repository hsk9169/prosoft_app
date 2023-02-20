import 'package:flutter/foundation.dart';
import 'package:prosoft_proj/models/user_info.dart';
import 'package:prosoft_proj/models/main_content.dart';
import 'package:prosoft_proj/models/waiting_order.dart';

// Global variables for App Session management
class Session extends ChangeNotifier {
  UserInfo _userInfo = UserInfo();
  List<MainContent> _contentList = [];
  List<WaitingOrder> _waitingOrder = [];

  UserInfo get userInfo => _userInfo;
  List<MainContent> get contentList => _contentList;
  List<WaitingOrder> get waitingOrder => _waitingOrder;

  set userInfo(UserInfo value) {
    _userInfo = value;
    notifyListeners();
  }

  set contentList(List<MainContent> value) {
    _contentList = value;
    notifyListeners();
  }

  set waitingOrder(List<WaitingOrder> value) {
    _waitingOrder = value;
    notifyListeners();
  }
}
