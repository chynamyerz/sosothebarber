/*
*  top_bar_shape_widget.dart
*  TopBarShape
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';

class TopBarShapeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.20,
      child: Image.asset(
        "assets/images/rectangle.png",
        fit: BoxFit.cover,
      ),
    );
  }
}
