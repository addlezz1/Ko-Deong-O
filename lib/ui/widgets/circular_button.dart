import 'dart:io';
import 'package:flutter/material.dart';
import 'package:talkwho/models/unit.dart';
import 'package:talkwho/models/question.dart';
import 'package:talkwho/resources/api_provider.dart';

class CircularButton extends StatelessWidget {

  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton({this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(icon: icon, enableFeedback: true, onPressed: onClick),
    );
  }}