import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/colors.dart';

class AppBarContents extends StatelessWidget {
  final double width;
  final String id;
  final VoidCallback onTapButton;

  const AppBarContents({
    Key? key,
    required this.width,
    required this.id,
    required this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: width,
        padding: EdgeInsets.all(width * 0.02),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
              onTap: onTapButton,
              child: Container(
                  padding: EdgeInsets.only(
                    top: width * 0.02,
                    bottom: width * 0.02,
                    left: width * 0.04,
                    right: width * 0.04,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: AppColors.bold, width: width * 0.003),
                      borderRadius: BorderRadius.circular(width * 0.02)),
                  child: Text('로그아웃',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.bold)))),
          Row(children: [
            Icon(Icons.person, color: AppColors.light, size: width * 0.08),
            Padding(padding: EdgeInsets.all(width * 0.01)),
            Text('$id 님 환영합니다.',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.normal))
          ])
        ]));
  }
}
