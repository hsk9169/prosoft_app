import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';

class ElevatedPopup extends StatelessWidget {
  final Widget children;
  final double height;
  final VoidCallback onTapClose;
  ElevatedPopup(
      {required this.children, required this.height, required this.onTapClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(
        left: context.pWidth * 0.05,
        right: context.pWidth * 0.05,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.pWidth * 0.06)),
      elevation: 20,
      child: SingleChildScrollView(
          child: Container(
              width: context.pWidth,
              height: height,
              padding: EdgeInsets.only(
                top: context.pHeight * 0.035,
                bottom: context.pHeight * 0.03,
                left: context.pWidth * 0.05,
                right: context.pWidth * 0.05,
              ),
              child: Stack(children: [
                children,
                Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                        onTap: onTapClose,
                        child: Icon(Icons.close,
                            color: Colors.black, size: context.pWidth * 0.06)))
              ]))),
    );
  }
}
