/*
*  text_form_field_widget.dart
*  TextFormField
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';

import '../values/values.dart';

class TextFormFieldWidget extends StatelessWidget {
  final Icon icon;
  final String label;
  final bool secret;
  final Function validator;
  final Function inputChange;

  TextFormFieldWidget({
    @required this.icon,
    @required this.label,
    @required this.inputChange,
    this.secret = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Container(
      width: mediaQuery.size.width * 0.85,
      child: Card(
          elevation: 10,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: label,
              filled: true,
              fillColor: Theme.of(context).primaryColor,
              prefixIcon: icon,
              contentPadding: EdgeInsets.only(top: 15,
              left: mediaQuery.size.width * 0.02)
            ),
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColors.primaryText,
              fontFamily: "Arial",
              fontWeight: FontWeight.w400,
              fontSize: 18
            ),
            onChanged: (input) => inputChange(input),
            validator: validator,
            obscureText: secret,
          )),
    );
  }
}
