import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/models/models.dart';

class WaitingStatusView extends StatefulWidget {
  final WaitingOrder waitingOrder;
  const WaitingStatusView({required this.waitingOrder});
  @override
  State<StatefulWidget> createState() => _WaitingStatusView();
}

class _WaitingStatusView extends State<WaitingStatusView> {
  // Service
  final _apiService = ApiService();

  // State
  late UserInfo _userInfo;

  // Future
  late Future<WaitingStatus> _waitingStatusFuture;

  @override
  void initState() {
    _initData();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Platform>(context, listen: false).isLoading = true;
    });
  }

  void _initData() async {
    _userInfo = Provider.of<Session>(context, listen: false).userInfo;
    _waitingStatusFuture = _getWaitingStatusData();
  }

  Future<WaitingStatus> _getWaitingStatusData() async {
    return await _apiService
        .getWaitingStatus('010-3576-9365', '21', 'C12')
        //.getWaitingStatus(_userInfo.phoneNumber,
        //    widget.waitingOrder.measrGbnCode, widget.waitingOrder.scrapYardCode)
        .whenComplete(() =>
            Provider.of<Platform>(context, listen: false).isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
            future: _waitingStatusFuture,
            builder:
                (BuildContext context, AsyncSnapshot<WaitingStatus> snapshot) {
              if (snapshot.data != null) {
                return Container(
                    width: context.pWidth, child: Text('waiting status view'));
              } else {
                return const SizedBox();
              }
            }));
  }
}
