import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/sizes.dart';

class HorizontalDivier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: context.pHeight * 0.03,
      thickness: context.pHeight * 0.0015,
    );
  }
}
