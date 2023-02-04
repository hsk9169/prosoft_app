import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:prosoft_proj/screens/screens.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/widgets/app_bar_contents.dart';
import '../firebase_options.dart';
import 'package:prosoft_proj/routes.dart';
import 'package:prosoft_proj/screens/screens.dart';

class ServiceView extends StatefulWidget {
  final int? screenNumber;
  const ServiceView({this.screenNumber});
  @override
  State<StatefulWidget> createState() => _ServiceView();
}

class _ServiceView extends State<ServiceView> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final notificationDetails = NotificationDetails(
    // Android details
    android: AndroidNotificationDetails('main_channel', 'Main Channel',
        channelDescription: "ashwin",
        importance: Importance.max,
        priority: Priority.max),
    // iOS details
    iOS: IOSNotificationDetails(),
  );

  // State
  bool isMessage = false;

  @override
  void initState() {
    //_initMessaging();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  void _onTapLogout() {
    Navigator.pushNamedAndRemoveUntil(context, Routes.SIGNIN, (route) => false);
  }

  Widget? _bodyWidget() {
    switch (widget.screenNumber) {
      case 0:
        return const MainView(index: 0);
      case 1:
        return const MainView(index: 1);
      case 2:
        return MeasrImageView();
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<Platform>(context, listen: true).isLoading;
    bool isMessageRecieved =
        Provider.of<Platform>(context, listen: true).isMessageRecieved;
    bool isErrorMessagePoppedUp =
        Provider.of<Platform>(context, listen: true).isErrorMessagePoppedUp;

    _showErrorDialog(isErrorMessagePoppedUp);

    final String userName =
        Provider.of<Session>(context, listen: false).userInfo.name!;

    return AbsorbPointer(
        absorbing: isLoading,
        child: Stack(children: [
          Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size(context.pWidth, context.pHeight * 0.06),
                child: AppBar(
                  titleSpacing: 0,
                  backgroundColor: Colors.white,
                  title: AppBarContents(
                      width: context.pWidth,
                      id: userName,
                      onTapButton: _onTapLogout),
                  elevation: 0,
                ),
              ),
              body: _bodyWidget())
        ]));
  }

  void _initMessaging() async {
    final _platformProvider = Provider.of<Platform>(context, listen: false);
    final _sessionProvider = Provider.of<Session>(context, listen: false);

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.getToken().then((value) =>
        Provider.of<Platform>(context, listen: false).fcmToken = value!);

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) =>
            selectNotification(payload!));

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        //Provider.of<Platform>(context, listen: false).popupErrorMessage = '0';
        setState(() => isMessage = !isMessage);
        showLocalNotification(message.data, true);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      selectNotification(message.data['alarm_type']);
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      setState(() => isMessage = !isMessage);
      showLocalNotification(message.data, false);
    }
  }

  Future<void> showLocalNotification(
      Map<String, dynamic> data, bool isForeground) async {
    var platform = Theme.of(context).platform;
    //final String maxloadTitle = Provider.of<Session>(context, listen: false)
    //    .customerInfo
    //    .fcmMaxloadTitle;
    //final String maxloadBody = Provider.of<Session>(context, listen: false)
    //    .customerInfo
    //    .fcmMaxloadBody;
    //final String mitigationTitle = Provider.of<Session>(context, listen: false)
    //    .customerInfo
    //    .fcmReduceTitle;
    //final String mitigationBody =
    //    Provider.of<Session>(context, listen: false).customerInfo.fcmReduceBody;
    final String alarm_type = data['alarm_type'];
    final String startTime = data['hhmi1'] ?? '';
    final String endTime = data['hhmi2'] ?? '';
    final String time = data['hhmi'] ?? '';
    final DateTime mitigationDate = time == ''
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(int.parse(time)).toUtc();
    //Provider.of<Platform>(context, listen: false).popupErrorMessage = '1';
    _showErrorDialog(true);

    /*
    switch (alarm_type) {
      case 'maxload':
        Provider.of<Platform>(context, listen: false).popupErrorMessage = '2';
        _showErrorDialog(true);
        if (platform == TargetPlatform.android && isForeground) {
          Provider.of<Platform>(context, listen: false).popupErrorMessage = '3';
          _showErrorDialog(true);
          _flutterLocalNotificationsPlugin.show(
              0,
              maxloadTitle,
              '${maxloadBody.substring(0, 2)} $time ${maxloadBody.substring(3)}',
              notificationDetails);
        }
        Provider.of<Platform>(context, listen: false).addPeakBadgeCount();
        FlutterAppBadger.updateBadgeCount(
            Provider.of<Platform>(context, listen: false).totalBadgeCount);
        break;
      case 'reduce':
        _flutterLocalNotificationsPlugin.cancelAll();
        _flutterLocalNotificationsPlugin.show(
            1,
            mitigationTitle,
            '${mitigationBody.substring(0, 2)} $startTime - $endTime시 ${mitigationBody.substring(3)}',
            notificationDetails);
        Provider.of<Platform>(context, listen: false).isMitigating = true;
        Provider.of<Platform>(context, listen: false).mitigationTime =
            mitigationDate;
        Provider.of<Platform>(context, listen: false).addMitigationBadgeCount();
        FlutterAppBadger.updateBadgeCount(
            Provider.of<Platform>(context, listen: false).totalBadgeCount);
        _flutterLocalNotificationsPlugin.zonedSchedule(
            2,
            mitigationTitle,
            '${mitigationBody.substring(0, 2)} $startTime - $endTime시 ${mitigationBody.substring(3)}, 해제까지 30분 남음',
            tz.TZDateTime.now(tz.local).add(const Duration(minutes: 30)),
            notificationDetails,
            payload: 'reduce',
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true);
        _flutterLocalNotificationsPlugin.zonedSchedule(
            3,
            mitigationTitle,
            '${mitigationBody.substring(0, 2)} $startTime - $endTime시 ${mitigationBody.substring(3)}, 해제까지 10분 남음',
            tz.TZDateTime.now(tz.local).add(const Duration(minutes: 50)),
            notificationDetails,
            payload: 'reduce',
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true);
        break;
      default:
        break;
    }
    */
  }

  Future<void> selectNotification(String payload) async {
    switch (payload) {
      case 'maxload':
        //Navigator.pushNamed(context, Routes.SERVICE, arguments: 0);
        break;
      case 'reduce':
        //Navigator.pushNamed(context, Routes.SERVICE, arguments: 1);
        break;
      default:
        break;
    }
  }

  void _showErrorDialog(bool isError) {
    Future.delayed(Duration.zero, () {
      if (isError) {
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //    content: Text(Provider.of<Platform>(context, listen: false)
        //        .popupErrorMessage),
        //    backgroundColor: Colors.black87.withOpacity(0.6),
        //    duration: const Duration(seconds: 3)));
        //Provider.of<Platform>(context, listen: false).isErrorMessagePopup =
        //    false;
      }
    });
  }
}
