import 'package:flutter/material.dart';

import 'circular_loader.dart';

class SlimButton extends StatefulWidget {
  String buttonText;
  String buttonToggleText;
  Color buttonColor;
  Color buttonToggleColor;
  Color textColor;
  Color textToggleColor;
  double buttonBorderRadius;
  Function onClick;
  Function onClickToggle;
  bool isLoading;
  bool toggleEnabled;

  SlimButton({
    this.buttonText = '',
    this.buttonToggleText = '',
    this.buttonColor = Colors.blue,
    this.buttonToggleColor = Colors.blue,
    this.textColor = Colors.white,
    this.textToggleColor = Colors.white,
    this.buttonBorderRadius = 5.0,
    this.onClick,
    this.onClickToggle,
    this.isLoading = false,
    this.toggleEnabled = false,
  });

  @override
  _SlimButtonState createState() => _SlimButtonState();
}

class _SlimButtonState extends State<SlimButton> {
  bool toggled = false;

  void _toggleFn() {
    if (!this.toggled) {
      this.widget.onClick();
    } else {
      if (this.widget.onClickToggle != null) {
        this.widget.onClickToggle();
      }
    }
    setState(() {
      this.toggled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this.widget.toggleEnabled ? this._toggleFn : this.widget.onClick,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.widget.buttonBorderRadius)),
      child: this.widget.isLoading
          ? CircularLoader(
              diameter: 15,
              color: Colors.white,
            )
          : this.widget.toggleEnabled ? Text(
              this.toggled
                  ? this.widget.buttonToggleText
                  : this.widget.buttonText,
              style: TextStyle(
                  color: this.toggled
                      ? this.widget.textToggleColor
                      : this.widget.textColor),
            ) : Text(
              this.widget.buttonText,
              style: TextStyle(
                  color: this.widget.textColor),
            ),
      color: this.widget.toggleEnabled ? (this.toggled
          ? this.widget.buttonToggleColor
          : this.widget.buttonColor) : this.widget.buttonColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
