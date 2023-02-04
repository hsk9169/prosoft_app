import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/models/models.dart';

class ContentDetailsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentDetailsView();
}

class _ContentDetailsView extends State<ContentDetailsView> {
  // Service
  final _apiService = ApiService();

  // State
  late UserInfo _userInfo;

  // Future
  late Future<ContentDetails> _contentDetailsFuture;

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
    _contentDetailsFuture = _getMeasrImage();
  }

  Future<ContentDetails> _getMeasrImage() async {
    return await _apiService
        .getMeasrImage('010-3576-9365', '2023-02-01-1055-0017')
        //.getMeasrImage(_userInfo.phoneNumber!, '2023-02-01-1055-0017')
        .whenComplete(() =>
            Provider.of<Platform>(context, listen: false).isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
            future: _contentDetailsFuture,
            builder:
                (BuildContext context, AsyncSnapshot<ContentDetails> snapshot) {
              if (snapshot.data != null) {
                return Container(
                    width: context.pWidth, child: Text('content details view'));
              } else {
                return const SizedBox();
              }
            }));
  }
}
