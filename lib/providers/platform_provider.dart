import 'package:flutter/foundation.dart';
import 'package:prosoft_proj/models/models.dart';

// Global variables for App Platform management
class Platform extends ChangeNotifier {
  String _platformType = '';
  bool _isAutoLoginChecked = false;
  String _phoneNumber = '';
  String _password = '';
  String _fcmToken = '';
  bool _isMessageRecieved = false;
  bool _isLoading = false;
  bool _isErrorMessagePoppedUp = false;
  int _screenNumber = 0;
  MainContent _selectedBarcode = MainContent();

  String get platformType => _platformType;
  bool get isAutoLoginChecked => _isAutoLoginChecked;
  String get phoneNumber => _phoneNumber;
  String get password => _password;
  String get fcmToken => _fcmToken;
  bool get isMessageRecieved => _isMessageRecieved;
  bool get isLoading => _isLoading;
  bool get isErrorMessagePoppedUp => _isErrorMessagePoppedUp;
  int get screenNumber => _screenNumber;
  MainContent get selectedBarcode => _selectedBarcode;

  set platformType(String value) {
    _platformType = value;
    notifyListeners();
  }

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

  set screenNumber(int value) {
    _screenNumber = value;
    notifyListeners();
  }

  set selectedBarcode(MainContent value) {
    _selectedBarcode = value;
    notifyListeners();
  }
}
