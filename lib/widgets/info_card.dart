import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';

class InfoCard extends StatelessWidget {
  int number;
  InfoCard({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: context.pWidth * 0.03,
          bottom: context.pWidth * 0.03,
          left: context.pWidth * 0.07,
          right: context.pWidth * 0.07,
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
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Icon(Icons.notification_important_rounded,
                    color: AppColors.mediumGrey, size: context.pWidth * 0.07)),
            Container(
              padding: EdgeInsets.only(
                top: context.pWidth * 0.03,
                bottom: context.pWidth * 0.03,
              ),
              alignment: Alignment.center,
              child: Text('금일 ${number.toString()} 건의 바코드 정보가 있습니다.',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SUIT',
                      fontSize: context.pWidth * 0.04,
                      fontWeight: context.normalWeight)),
            )
          ],
        ));
  }
}
