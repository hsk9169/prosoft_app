import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/consts/sizes.dart';

class PopupButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  PopupButton({required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.pWidth * 0.03)),
        ),
        child: Ink(
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(context.pWidth * 0.03),
            ),
            child: Container(
              color: Colors.transparent,
              width: context.pWidth * 0.5,
              height: context.pHeight * 0.045,
              alignment: Alignment.center,
              child: Text(
                buttonText,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SUIT',
                    fontSize: context.pWidth * 0.045,
                    fontWeight: context.boldWeight),
              ),
            )));
  }
}
