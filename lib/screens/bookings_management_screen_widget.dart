/*
*  bookings_management_screen_widget.dart
*  BookingsManagementScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'dart:convert';

import 'package:flutter/material.dart';

import '../screens/admin_bookings_screen_widget.dart';
import '../screens/client_bookings_screen_widget.dart';

import '../widgets/app_drawer.dart';
import '../widgets/top_bar_shape_widget.dart';
import '../widgets/loading_widget.dart';

import '../utils/auth_util.dart';

import '../values/values.dart';

class BookingsManagementScreenWidget extends StatefulWidget {
  static final String routeName = '/bookings-management';

  @override
  _BookingsManagementScreenWidgetState createState() =>
      _BookingsManagementScreenWidgetState();
}

class _BookingsManagementScreenWidgetState
    extends State<BookingsManagementScreenWidget> {
  Map _user;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      AuthUtil().getUser().then((res) {
        if (res != null) {
          setState(() {
            _user = jsonDecode(res);
          });
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Manage bookings'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          TopBarShapeWidget(),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                left: mediaQuery.size.width * 0.085,
                right: mediaQuery.size.width * 0.085,
                top: mediaQuery.size.height * 0.01,
                bottom: mediaQuery.size.height * 0.02,
              ),
              child: Text(
                "Manage bookings",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontFamily: "Arial Black",
                  fontWeight: FontWeight.w900,
                  fontSize: mediaQuery.size.height * 0.035,
                ),
              ),
            ),
          ),
          SizedBox(height: mediaQuery.size.height * 0.025),
          if (_isLoading) LoadingWidget(),
          if (!_isLoading)
            Expanded(
              child: SingleChildScrollView(
                child: _user != null && _user['role'] == 'ADMIN'
                    ? AdminBookingsScreenWidget()
                    : ClientBookingsScreenWidget(),
              ),
            ),
        ],
      ),
    );
  }
}
