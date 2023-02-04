import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class BarcodeTag extends StatelessWidget {
  final double width;
  final String url;
  BarcodeTag({Key? key, required this.width, required this.url});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text('바코드',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold))),
      Padding(
        padding: EdgeInsets.all(width * 0.02),
      ),
      Stack(alignment: Alignment.center, children: [
        Container(
          width: width * 0.8,
          height: width * 0.35,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: width * 0.008),
              borderRadius: BorderRadius.circular(width * 0.01)),
        ),
        Container(
          width: width * 0.81,
          height: width * 0.26,
          color: Colors.white,
        ),
        Container(
          width: width * 0.7,
          height: width * 0.36,
          alignment: Alignment.center,
          color: Colors.white,
          padding: url.isNotEmpty
              ? EdgeInsets.only(
                  top: width * 0.04,
                )
              : null,
          child: url.isNotEmpty
              ? BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: url,
                  style: TextStyle(color: Colors.black, fontSize: width * 0.05))
              : Text('EMPTY',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: width * 0.1,
                      fontWeight: FontWeight.bold)),
        ),
      ])
    ]);
  }
}
