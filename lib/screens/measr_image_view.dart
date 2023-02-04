import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prosoft_proj/services/api_service.dart';
import 'package:prosoft_proj/providers/platform_provider.dart';
import 'package:prosoft_proj/providers/session_provider.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/models/models.dart';

class MeasrImageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MeasrImageView();
}

class _MeasrImageView extends State<MeasrImageView> {
  // Service
  final _apiService = ApiService();

  // State
  late UserInfo _userInfo;

  // Future
  late Future<MeasrImage> _measrImageFuture;

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
    _measrImageFuture = _getMeasrImage();
  }

  Future<MeasrImage> _getMeasrImage() async {
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
            future: _measrImageFuture,
            builder:
                (BuildContext context, AsyncSnapshot<MeasrImage> snapshot) {
              if (snapshot.data != null) {
                Uint8List image =
                    const Base64Codec().decode(snapshot.data!.image!);
                return Container(
                    width: context.pWidth, child: Image.memory(image));
              } else {
                return const SizedBox();
              }
            }));
  }
}
