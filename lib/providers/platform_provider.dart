import 'package:flutter/foundation.dart';

// Global variables for App Platform management
class Platform extends ChangeNotifier {
  bool _isAutoLoginChecked = false;
  String _phoneNumber = '';
  String _password = '';
  String _fcmToken = '';
  bool _isMessageRecieved = false;
  bool _isLoading = false;
  bool _isErrorMessagePoppedUp = false;

  bool get isAutoLoginChecked => _isAutoLoginChecked;
  String get phoneNumber => _phoneNumber;
  String get password => _password;
  String get fcmToken => _fcmToken;
  bool get isMessageRecieved => _isMessageRecieved;
  bool get isLoading => _isLoading;
  bool get isErrorMessagePoppedUp => _isErrorMessagePoppedUp;

  set isAutoLoginChecked(bool value) {
    _isAutoLoginChecked = value;
    notifyListeners();
  }

  set phoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  set password(String value) {
    _password = value;
    notifyListeners();
  }

  set fcmToken(String value) {
    _fcmToken = value;
    notifyListeners();
  }

  set isMessageRecieved(bool value) {
    _isMessageRecieved = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set isErrorMessagePoppedUp(bool value) {
    _isErrorMessagePoppedUp = value;
    notifyListeners();
  }
}
