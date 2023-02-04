import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/models/models.dart';

class WaitingOrderView extends StatefulWidget {
  final MainContent content;
  const WaitingOrderView({required this.content});
  @override
  State<StatefulWidget> createState() => _WaitingOrderView();
}

class _WaitingOrderView extends State<WaitingOrderView> {
  // Service
  ApiService _apiService = ApiService();

  // State
  late Future<WaitingOrder> _waitingOrderDataFuture;
  late UserInfo _userInfo;

  @override
  void initState() {
    _initData();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<Platform>(context, listen: false).isLoading = true;
    });
  }

  void _initData() {
    _userInfo = Provider.of<Session>(context, listen: false).userInfo;
    _waitingOrderDataFuture = _getWaitingOrderData();
  }

  Future<WaitingOrder> _getWaitingOrderData() async {
    return await _apiService
        .getWaitingOrder(
            //_userInfo.phoneNumber!,
            //widget.content.barcodeId.toString(),
            //widget.content.rfidNumber.toString());
            "010-3576-9365",
            "2302010001",
            "21076427")
        .whenComplete(() =>
            Provider.of<Platform>(context, listen: false).isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.pWidth,
        height: context.pHeight,
        color: Colors.white,
        alignment: Alignment.center,
        child: Text('Waiting Order'));
  }
}
