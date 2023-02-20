import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';

class DarkButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const DarkButton({
    Key? key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.only(
              top: context.pWidth * 0.01,
              bottom: context.pWidth * 0.01,
              left: context.pWidth * 0.02,
              right: context.pWidth * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.pWidth * 0.01),
              color: AppColors.darkGrey,
            ),
            child: Text(text,
                style: TextStyle(
                    fontSize: context.pWidth * 0.03,
                    fontFamily: 'SUIT',
                    fontWeight: context.boldWeight,
                    color: Colors.white))));
  }
}
