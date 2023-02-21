import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/widgets/dark_button.dart';
import 'package:prosoft_proj/widgets/barcode_tag.dart';

class BarcodeBadge extends StatelessWidget {
  final String? carFullNo;
  final String? type;
  final bool? isEnd;
  final String? url;
  final VoidCallback onTapOrder;
  final VoidCallback onTapStatus;

  const BarcodeBadge({
    Key? key,
    this.carFullNo,
    this.type,
    this.isEnd,
    this.url,
    required this.onTapOrder,
    required this.onTapStatus,
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
            padding: EdgeInsets.all(context.pHeight * 0.006),
          ),
          _renderType(context),
          Padding(
            padding: EdgeInsets.all(context.pHeight * 0.006),
          ),
          _renderBarcode(context)
        ]));
  }

  Widget _renderCarFullNo(BuildContext context) {
    return Column(children: [
      Row(children: [
        SvgPicture.asset('assets/icons/truck.svg',
            width: context.pWidth * 0.08, color: AppColors.darkGrey),
        Padding(padding: EdgeInsets.all(context.pWidth * 0.01)),
        Text('차량번호',
            style: TextStyle(
                fontSize: context.pWidth * 0.05,
                fontFamily: 'SUIT',
                fontWeight: context.normalWeight,
                color: Colors.black))
      ]),
      Padding(
        padding: EdgeInsets.all(context.pHeight * 0.01),
      ),
      Container(
          width: context.pWidth,
          alignment: Alignment.center,
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
      Row(children: [
        SvgPicture.asset('assets/icons/item.svg',
            width: context.pWidth * 0.07, color: AppColors.darkGrey),
        Padding(padding: EdgeInsets.all(context.pWidth * 0.01)),
        Text('품명',
            style: TextStyle(
                fontSize: context.pWidth * 0.05,
                fontFamily: 'SUIT',
                fontWeight: context.normalWeight,
                color: Colors.black))
      ]),
      Padding(
        padding: EdgeInsets.all(context.pHeight * 0.01),
      ),
      Container(
          width: context.pWidth,
          alignment: Alignment.center,
          child: Text(type!,
              style: TextStyle(
                  fontSize: context.pWidth * 0.14,
                  fontFamily: 'SUIT',
                  fontWeight: context.maxWeight,
                  color: isEnd! ? Colors.black : AppColors.lightOrange)))
    ]);
  }

  Widget _renderBarcode(BuildContext context) {
    return Column(children: [
      Row(children: [
        SvgPicture.asset('assets/icons/barcode.svg',
            width: context.pWidth * 0.06, color: AppColors.darkGrey),
        Padding(padding: EdgeInsets.all(context.pWidth * 0.01)),
        Text('바코드',
            style: TextStyle(
                fontSize: context.pWidth * 0.05,
                fontFamily: 'SUIT',
                fontWeight: context.normalWeight,
                color: Colors.black))
      ]),
      Padding(
          padding: EdgeInsets.all(context.pWidth * 0.04),
          child: BarcodeTag(url: url ?? '')),
      Padding(padding: EdgeInsets.all(context.pHeight * 0.005)),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DarkButton(text: '진행화면', onTap: onTapOrder),
          Padding(padding: EdgeInsets.all(context.pWidth * 0.01)),
          DarkButton(text: '대기순서', onTap: onTapStatus),
        ],
      )
    ]);
  }
}
