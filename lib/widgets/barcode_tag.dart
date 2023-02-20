import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:prosoft_proj/consts/sizes.dart';
import 'package:prosoft_proj/consts/colors.dart';

class BarcodeTag extends StatelessWidget {
  final String url;
  BarcodeTag({Key? key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: context.pWidth * 0.7,
        height: context.pWidth * 0.3,
        decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.mediumGrey, width: context.pWidth * 0.01),
            borderRadius: BorderRadius.circular(context.pWidth * 0.03)),
      ),
      Container(
        width: context.pWidth * 0.71,
        height: context.pWidth * 0.18,
        color: Colors.white,
      ),
      Container(
        width: context.pWidth * 0.57,
        height: context.pWidth * 0.32,
        alignment: Alignment.center,
        color: Colors.white,
        padding: url.isNotEmpty
            ? EdgeInsets.only(
                top: context.pWidth * 0.05,
                left: context.pWidth * 0.02,
                right: context.pWidth * 0.02,
              )
            : null,
        child: url.isNotEmpty
            ? BarcodeWidget(
                barcode: Barcode.code128(),
                data: url,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SUIT',
                    fontWeight: context.normalWeight,
                    fontSize: context.pWidth * 0.05))
            : Text('EMPTY',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: context.pWidth * 0.1,
                    fontFamily: 'SUIT',
                    fontWeight: context.maxWeight)),
      ),
    ]);
  }
}
