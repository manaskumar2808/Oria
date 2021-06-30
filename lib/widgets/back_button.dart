import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  final bool makeWhite;
  final bool crossIcon;

  BackButton({this.crossIcon = false,this.makeWhite = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        this.crossIcon ? Icons.close : Icons.arrow_back_ios,
        color: this.makeWhite ? Colors.white : Colors.black,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
