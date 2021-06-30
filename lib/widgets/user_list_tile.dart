import 'package:flutter/material.dart';

import './circular_profile_item.dart';
import './slim_button.dart';

class UserListTile extends StatefulWidget {
  String userName;
  String subText;
  String imageUrl;
  bool hasIcon;
  bool hasButton;
  bool dualButton;
  bool hasTrailingText;
  String singleButtonText;
  String dualButtonText1;
  String dualButtonText2;
  String trailingText;
  String singleButtonToggleText;
  Color singleButtonColor;
  Color singleButtonToggleColor;
  Color dualButtonColor1;
  Color dualButtonColor2;
  Icon icon;
  Function singleButtonFn;
  Function dualButtonFn1;
  Function dualButtonFn2;
  Function iconButtonFn;
  Function singleButtonToggleFn;
  bool buttonIsLoading;
  bool toggleEnabled;

  UserListTile({
    this.userName = '',
    this.subText = '',
    this.imageUrl,
    this.hasIcon = false,
    this.hasButton = true,
    this.dualButton = false,
    this.hasTrailingText = false,
    this.singleButtonText = '',
    this.dualButtonText1 = '',
    this.dualButtonText2 = '',
    this.trailingText = '',
    this.singleButtonToggleText = '',
    this.singleButtonColor = Colors.blue,
    this.dualButtonColor1 = Colors.blue,
    this.dualButtonColor2 = Colors.blue,
    this.singleButtonToggleColor = Colors.blue,
    this.icon,
    this.singleButtonFn,
    this.dualButtonFn1,
    this.dualButtonFn2,
    this.iconButtonFn,
    this.singleButtonToggleFn,
    this.buttonIsLoading,
    this.toggleEnabled = false,
  });

  @override
  _UserListTileState createState() => _UserListTileState();
}

class _UserListTileState extends State<UserListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: CircularProfileItem(
              imageUrl: this.widget.imageUrl,
              haveBorder: false,
              profileRadius: 30,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.widget.userName),
              ],
            ),
          ),
          Flexible(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  if (!this.widget.hasTrailingText &&
                      this.widget.hasButton &&
                      this.widget.dualButton)
                    SlimButton(
                      onClick: this.widget.dualButtonFn1,
                      buttonText: this.widget.dualButtonText1,
                      buttonColor: this.widget.dualButtonColor1,
                      toggleEnabled: this.widget.toggleEnabled,
                    ),
                  if (!this.widget.hasTrailingText &&
                      this.widget.hasButton &&
                      this.widget.dualButton)
                    SizedBox(
                      width: 5,
                    ),
                  if (!this.widget.hasTrailingText &&
                      this.widget.hasButton &&
                      this.widget.dualButton)
                    SlimButton(
                      onClick: this.widget.dualButtonFn2,
                      buttonText: this.widget.dualButtonText2,
                      buttonColor: this.widget.dualButtonColor2,
                      toggleEnabled: this.widget.toggleEnabled,
                    ),
                  if (!this.widget.hasTrailingText &&
                      !this.widget.dualButton &&
                      this.widget.hasButton)
                    SlimButton(
                      onClick: this.widget.singleButtonFn,
                      onClickToggle: this.widget.singleButtonToggleFn,
                      buttonText: this.widget.singleButtonText,
                      buttonToggleText: this.widget.singleButtonToggleText,
                      buttonColor: this.widget.singleButtonColor,
                      buttonToggleColor: this.widget.singleButtonToggleColor,
                      isLoading: this.widget.buttonIsLoading,
                      toggleEnabled: this.widget.toggleEnabled,
                    ),
                  if (!this.widget.hasTrailingText && this.widget.hasIcon)
                    IconButton(
                      onPressed: this.widget.iconButtonFn,
                      icon: this.widget.icon,
                      iconSize: 40,
                      color: Colors.black,
                    ),
                  if (this.widget.hasTrailingText)
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        this.widget.trailingText,
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                ],
              ))
        ],
      ),
    );
  }
}
