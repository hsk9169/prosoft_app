import 'package:flutter/material.dart';

class LicensePlate extends StatelessWidget {
  final double width;
  final double height;
  final String licenseNum;

  const LicensePlate({
    Key? key,
    required this.width,
    required this.height,
    required this.licenseNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(width * 0.02),
        alignment: Alignment.centerRight,
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/license_plate.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: Container(
            width: width * 0.87,
            alignment: Alignment.center,
            child: Text(licenseNum,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.12,
                    fontWeight: FontWeight.bold))));
  }
}
