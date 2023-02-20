import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/widgets/barcode_badge.dart';
import 'package:prosoft_proj/widgets/barcode_tag.dart';
import 'package:prosoft_proj/utils/number_handler.dart';

class BarcodeDetails extends StatelessWidget {
  final String? carFullNo;
  final String? type;
  final String? custName;
  final String? inStoreTime;

  const BarcodeDetails({
    Key? key,
    this.carFullNo,
    this.type,
    this.custName,
    this.inStoreTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            top: context.pHeight * 0.02,
            left: context.pWidth * 0.04,
            right: context.pWidth * 0.04),
        padding: EdgeInsets.all(
          context.pWidth * 0.04,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.pWidth * 0.06),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 4,
              blurRadius: 6,
              offset: const Offset(5, 8),
            ),
          ],
        ),
        child: Column(children: [
          _renderCarFullNo(context),
          Padding(
            padding: EdgeInsets.all(context.pHeight * 0.01),
          ),
          _renderType(context),
          Padding(
            padding: EdgeInsets.all(context.pHeight * 0.01),
          ),
          _renderCustName(context),
          Padding(
            padding: EdgeInsets.all(context.pHeight * 0.01),
          ),
          _renderGateInTime(context),
        ]));
  }

  Widget _renderCarFullNo(BuildContext context) {
    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          width: context.pWidth,
          child: Text('차량번호',
              style: TextStyle(
                  fontSize: context.pWidth * 0.05,
                  fontFamily: 'SUIT',
                  fontWeight: context.normalWeight,
                  color: Colors.black))),
      Padding(
        padding: EdgeInsets.all(context.pHeight * 0.01),
      ),
      Container(
          width: context.pWidth,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: context.pWidth * 0.06),
          child: Text(carFullNo!,
              style: TextStyle(
                  fontSize: context.pWidth * 0.1,
                  fontFamily: 'SUIT',
                  fontWeight: context.boldWeight,
                  color: Colors.black)))
    ]);
  }

  Widget _renderType(BuildContext context) {
    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          width: context.pWidth,
          child: Text('품명',
              style: TextStyle(
                  fontSize: context.pWidth * 0.05,
                  fontFamily: 'SUIT',
                  fontWeight: context.normalWeight,
                  color: Colors.black))),
      Padding(
        padding: EdgeInsets.all(context.pHeight * 0.01),
      ),
      Container(
          width: context.pWidth,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: context.pWidth * 0.06),
          child: Text(type!,
              style: TextStyle(
                  fontSize: context.pWidth * 0.1,
                  fontFamily: 'SUIT',
                  fontWeight: context.boldWeight,
                  color: Colors.black)))
    ]);
  }

  Widget _renderCustName(BuildContext context) {
    return Column(children: [
      Container(
          alignment: Alignment.centerLeft,
          width: context.pWidth,
          child: Text('거래선',
              style: TextStyle(
                  fontSize: context.pWidth * 0.05,
                  fontFamily: 'SUIT',
                  fontWeight: context.normalWeight,
                  color: Colors.black))),
      Padding(
        padding: EdgeInsets.all(context.pHeight * 0.01),
      ),
      Container(
          width: context.pWidth,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: context.pWidth * 0.06),
          child: Text(custName!,
              style: TextStyle(
                  fontSize: context.pWidth * 0.1,
                  fontFamily: 'SUIT',
                  fontWeight: context.boldWeight,
                  color: Colors.black)))
    ]);
  }

  Widget _renderGateInTime(BuildContext context) {
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            width: context.pWidth,
            child: Text('입고시간',
                style: TextStyle(
                    fontSize: context.pWidth * 0.05,
                    fontFamily: 'SUIT',
                    fontWeight: context.normalWeight,
                    color: Colors.black))),
        Padding(
          padding: EdgeInsets.all(context.pHeight * 0.01),
        ),
        Container(
            width: context.pWidth,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: context.pWidth * 0.06),
            child: Text(inStoreTime!,
                style: TextStyle(
                    fontSize: context.pWidth * 0.1,
                    fontFamily: 'SUIT',
                    fontWeight: context.boldWeight,
                    color: Colors.black)))
      ],
    );
  }
}
