import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';

class AppBarContents extends StatelessWidget {
  final String id;

  const AppBarContents({
    Key? key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.pWidth,
        padding: EdgeInsets.only(
          top: context.pWidth * 0.04,
          right: context.pWidth * 0.04,
          left: context.pWidth * 0.04,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(children: [
            Icon(Icons.person,
                color: AppColors.lightGrey, size: context.pWidth * 0.08),
            Padding(padding: EdgeInsets.all(context.pWidth * 0.01)),
            Text('$id 님 환영합니다.',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SUIT',
                    fontSize: context.pWidth * 0.05,
                    fontWeight: context.normalWeight))
          ])
        ]));
  }
}
