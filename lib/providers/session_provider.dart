import 'package:flutter/foundation.dart';
import 'package:prosoft_proj/models/user_info.dart';

// Global variables for App Session management
class Session extends ChangeNotifier {
  UserInfo _userInfo = UserInfo();

  UserInfo get userInfo => _userInfo;

  set userInfo(UserInfo value) {
    _userInfo = value;
    notifyListeners();
  }
}
