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
        final json = jsonDecode(utf8.decode(res.bodyBytes));
        if (json['data']['updateCnt'] > 0) {
          return 'SUCCESS';
        } else {
          return 'FAILED';
        }
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

  Future<dynamic> getBarcodeIssueList(String phoneNumber, String date) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/getWarehousePlan'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MOBILE_ID": phoneNumber,
            "IN_STORE_DATE": date,
          }));
      if (res.statusCode == 200) {
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        return body['data']['list']
            .map<IssueBarcode>(
                (dynamic element) => IssueBarcode.fromJson(element))
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
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        return body['data']['list'];
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
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        return body['data']['list']
            .map<WaitingStatus>(
                (dynamic element) => WaitingStatus.fromJson(element))
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
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        if (body['data']['list'] != null) {
          return ContentDetails.fromJson(body['data']['list'][0]);
        } else {
          return 'FAILED';
        }
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
        final json = jsonDecode(utf8.decode(res.bodyBytes));
        if (json['data']['list'] != null) {
          return FcmMessage.fromJson(json['data']['list']);
        } else {
          return 'FAILED';
        }
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

  Future<dynamic> getUserInfo(String phoneNumber, String name) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/getUserInfo'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MOBILE_ID": phoneNumber,
            "MOBILE_NAME": name,
          }));
      if (res.statusCode == 200) {
        final json = jsonDecode(utf8.decode(res.bodyBytes));
        if (json['data']['list'] != null) {
          return 'SUCCESS';
        } else {
          return 'FAILED';
        }
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

  Future<dynamic> updatePwd(String phoneNumber, String password) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/setRstPwd'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "MOBILE_ID": phoneNumber,
            "MOBILE_PWD": password,
          }));
      if (res.statusCode == 200) {
        final json = jsonDecode(utf8.decode(res.bodyBytes));
        if (json['data']['updateCnt'] > 0) {
          return 'SUCCESS';
        } else {
          return 'FAILED';
        }
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

  Future<dynamic> issueBarcode(String compCd, String reservNo, String mobileId,
      String mobileName, String token) async {
    try {
      final res = await http.post(
          Uri(
              scheme: 'http',
              host: _hostAddress,
              port: 9999,
              path: '/callSpBarcodeSave'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=utf-8',
          },
          body: jsonEncode(<String, String>{
            "COMP_CD": compCd,
            "RESERV_NO": reservNo,
            "TOKEN": token,
            "MOBILE_ID": mobileId,
            "MOBILE_NAME": mobileName,
          }));
      if (res.statusCode == 200) {
        final json = jsonDecode(utf8.decode(res.bodyBytes));
        if (json['code'] == 200 && json['data']['CODE'] == 'S') {
          return 'SUCCESS';
        } else {
          return json['data']['MSG'];
        }
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
