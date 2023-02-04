import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prosoft_proj/models/measr_image.dart';
import 'package:prosoft_proj/models/models.dart';

class ApiService {
  final _hostAddress = '222.237.78.6';

  Future<dynamic> login(String phoneNumber, String password, String fcmToken,
      String platform) async {
    try {
      final res = await http.post(
          Uri(scheme: 'http', host: _hostAddress, port: 9999, path: '/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MOBILE_ID": phoneNumber,
            "MOBILE_PWD": password,
            "TOKEN": fcmToken,
            "DEVICE_OS": platform,
          }));
      if (res.statusCode == 200) {
        return UserInfo.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
      } else if (res.statusCode == 400 ||
          res.statusCode == 401 ||
          res.statusCode == 402) {
        return 'BAD_REQUEST';
      } else {
        return 'SERVER_ERROR';
      }
    } catch (err) {
      if (err is SocketException) {
        return 'SOCKET_EXCEPTION';
      } else if (err is TimeoutException) {
        return 'SERVER_TIMEOUT';
      } else {
        return 'UNKNOWN_ERROR';
      }
    }
  }

  Future<dynamic> updateUserInfo(
      String phoneNumber, String password, String name) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: 'updateUserInfo'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            'MOBILE_ID': phoneNumber,
            'MOBILE_PWD': password,
            'MOBILE_NAME': name,
          }));
      if (res.statusCode == 200) {
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        return body['data']['updateCnt'];
      }
    } catch (err) {
      if (err is SocketException) {
        return 'SOCKET_EXCEPTION';
      } else if (err is TimeoutException) {
        return 'SERVER_TIMEOUT';
      } else {
        return 'UNKNOWN_ERROR';
      }
    }
  }

  Future<dynamic> getMainList(String phoneNumber) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/getMainList'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MOBILE_ID": phoneNumber,
          }));
      if (res.statusCode == 200) {
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        return body['data']['list']
            .map<MainContent>(
                (dynamic element) => MainContent.fromJson(element))
            .toList();
      } else if (res.statusCode == 400 ||
          res.statusCode == 401 ||
          res.statusCode == 402) {
        return 'BAD_REQUEST';
      } else {
        return 'SERVER_ERROR';
      }
    } catch (err) {
      if (err is SocketException) {
        return 'SOCKET_EXCEPTION';
      } else if (err is TimeoutException) {
        return 'SERVER_TIMEOUT';
      } else {
        return 'UNKNOWN_ERROR';
      }
    }
  }

  Future<dynamic> getWaitingOrder(
      String phoneNumber, String barcodeId, String rfidNumber) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/getWatingOrder'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MOBILE_ID": phoneNumber,
            "BARCODE_ID": barcodeId,
            "RFID_NO": rfidNumber,
          }));
      if (res.statusCode == 200) {
        return WaitingOrder.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
      } else if (res.statusCode == 400 ||
          res.statusCode == 401 ||
          res.statusCode == 402) {
        return 'BAD_REQUEST';
      } else {
        return 'SERVER_ERROR';
      }
    } catch (err) {
      if (err is SocketException) {
        return 'SOCKET_EXCEPTION';
      } else if (err is TimeoutException) {
        return 'SERVER_TIMEOUT';
      } else {
        return 'UNKNOWN_ERROR';
      }
    }
  }

  Future<dynamic> getWaitingStatus(
      String phoneNumber, String measrGbnCode, String scrapYardCode) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/getWatingOrderStatus'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MOBILE_ID": phoneNumber,
            "MEASR_GBN_CODE": measrGbnCode,
            "SCRAP_YARD_CODE": scrapYardCode,
          }));
      if (res.statusCode == 200) {
        return WaitingStatus.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
      } else if (res.statusCode == 400 ||
          res.statusCode == 401 ||
          res.statusCode == 402) {
        return 'BAD_REQUEST';
      } else {
        return 'SERVER_ERROR';
      }
    } catch (err) {
      if (err is SocketException) {
        return 'SOCKET_EXCEPTION';
      } else if (err is TimeoutException) {
        return 'SERVER_TIMEOUT';
      } else {
        return 'UNKNOWN_ERROR';
      }
    }
  }

  Future<dynamic> getMainDetails(
      String phoneNumber, String barcodeId, String rfidNo) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/getMainDetail'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MOBILE_ID": phoneNumber,
            "BARCODE_ID": barcodeId,
            "RFID_NO": rfidNo,
          }));
      if (res.statusCode == 200) {
        return ContentDetails.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
      } else if (res.statusCode == 400 ||
          res.statusCode == 401 ||
          res.statusCode == 402) {
        return 'BAD_REQUEST';
      } else {
        return 'SERVER_ERROR';
      }
    } catch (err) {
      if (err is SocketException) {
        return 'SOCKET_EXCEPTION';
      } else if (err is TimeoutException) {
        return 'SERVER_TIMEOUT';
      } else {
        return 'UNKNOWN_ERROR';
      }
    }
  }

  Future<dynamic> getMeasrImage(String phoneNumber, String measrInNo) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/getMeasrImage'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MEASR_IN_NO": measrInNo,
            "MOBILE_ID": phoneNumber
          }));
      if (res.statusCode == 200) {
        return MeasrImage.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
      } else if (res.statusCode == 400 ||
          res.statusCode == 401 ||
          res.statusCode == 402) {
        return 'BAD_REQUEST';
      } else {
        return 'SERVER_ERROR';
      }
    } catch (err) {
      if (err is SocketException) {
        return 'SOCKET_EXCEPTION';
      } else if (err is TimeoutException) {
        return 'SERVER_TIMEOUT';
      } else {
        return 'UNKNOWN_ERROR';
      }
    }
  }

  Future<dynamic> getLatestMsg(String phoneNumber) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/getMsgSendHis'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MOBILE_ID": phoneNumber,
          }));
      if (res.statusCode == 200) {
        return FcmMessage.fromJson(jsonDecode(utf8.decode(res.bodyBytes)));
      } else if (res.statusCode == 400 ||
          res.statusCode == 401 ||
          res.statusCode == 402) {
        return 'BAD_REQUEST';
      } else {
        return 'SERVER_ERROR';
      }
    } catch (err) {
      if (err is SocketException) {
        return 'SOCKET_EXCEPTION';
      } else if (err is TimeoutException) {
        return 'SERVER_TIMEOUT';
      } else {
        return 'UNKNOWN_ERROR';
      }
    }
  }

  Future<dynamic> checkMsgRead(
      String phoneNumber, String msgDate, String msgSeq) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/callSpMsgSRcvSave'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MSG_DATE": msgDate,
            "MSG_SEQ": msgSeq,
            "MOBILE_ID": phoneNumber
          }));
      if (res.statusCode == 200) {
        return 'SUCCESS';
      } else if (res.statusCode == 400 ||
          res.statusCode == 401 ||
          res.statusCode == 402) {
        return 'BAD_REQUEST';
      } else {
        return 'SERVER_ERROR';
      }
    } catch (err) {
      if (err is SocketException) {
        return 'SOCKET_EXCEPTION';
      } else if (err is TimeoutException) {
        return 'SERVER_TIMEOUT';
      } else {
        return 'UNKNOWN_ERROR';
      }
    }
  }
}
