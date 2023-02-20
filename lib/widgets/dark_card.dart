import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';

class DarkCard extends StatelessWidget {
  Widget child;
  DarkCard({required this.child});

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
          color: AppColors.mediumGrey,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 4,
              blurRadius: 6,
              offset: const Offset(5, 8),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: context.pWidth * 0.03,
            bottom: context.pWidth * 0.03,
          ),
          alignment: Alignment.center,
          child: child,
        ));
  }
}
