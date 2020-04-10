/*
*  alert_dialog_widget.dart
*  AlertDialog
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';
import 'package:sosothebarber/utils/general_util.dart';

class AlertDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final bool replacePreviousNavigation;
  final String navigateTo;

  AlertDialogWidget({this.title, this.message, this.navigateTo, this.replacePreviousNavigation = false});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            if (replacePreviousNavigation) {
              Navigator.of(context).pushReplacementNamed(navigateTo);
            } else {
              Navigator.of(context).pushNamed(navigateTo);
            }
          },
        )
      ],
    );
  }
}
