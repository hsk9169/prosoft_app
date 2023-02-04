import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prosoft_proj/consts/colors.dart';
import 'package:prosoft_proj/widgets/barcode_badge.dart';
import 'package:prosoft_proj/widgets/barcode_tag.dart';

class BarcodeBadge extends StatelessWidget {
  final double width;
  final String? level;
  final String? type;
  final String? url;
  final VoidCallback onTap;

  const BarcodeBadge({
    Key? key,
    required this.width,
    this.level,
    this.type,
    this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String _level = level ?? '';
    return Padding(
        padding: EdgeInsets.only(
          top: width * 0.02,
          bottom: width * 0.02,
        ),
        child: GestureDetector(
            onTap: onTap,
            child: Container(
                width: width,
                padding: EdgeInsets.all(width * 0.05),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: Colors.black, width: width * 0.002),
                    borderRadius: BorderRadius.circular(width * 0.05)),
                child: Column(children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('품명: $_level',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: width * 0.08,
                              fontWeight: FontWeight.bold))),
                  Padding(
                    padding: EdgeInsets.all(width * 0.05),
                  ),
                  type != null
                      ? Text(type!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: width * 0.15,
                              fontWeight: FontWeight.bold))
                      : Text('NONE',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: width * 0.13,
                              fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.all(width * 0.07),
                  ),
                  BarcodeTag(width: width, url: url ?? '')
                ]))));
  }
}
