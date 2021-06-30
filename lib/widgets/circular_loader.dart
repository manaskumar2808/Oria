import 'package:flutter/material.dart';

class CircularLoader extends StatelessWidget {
  final double diameter;
  final Color color;
  final double thickness;

  CircularLoader({this.diameter = 80,this.color = Colors.black,this.thickness = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.diameter,
      width: this.diameter,
      decoration: BoxDecoration(
        border: Border.all(width: this.thickness,color: this.color),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}