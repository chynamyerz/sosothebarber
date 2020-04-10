/*
*  bookings_management_screen_widget.dart
*  BookingsManagementScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sosothebarber/graphql/queries.dart';
import 'package:sosothebarber/screens/admin_bookings_screen_widget.dart';
import 'package:sosothebarber/screens/client_bookings_screen_widget.dart';
import 'package:sosothebarber/widgets/loading_widget.dart';

import '../widgets/app_drawer.dart';
import '../widgets/top_bar_shape_widget.dart';

import '../values/values.dart';

class BookingsManagementScreenWidget extends StatelessWidget {
  static final String routeName = '/bookings-management';

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
          Expanded(
            child: SingleChildScrollView(
              child: Query(
                options: QueryOptions(documentNode: gql(Queries().user)),
                builder: (
                  QueryResult userQueryResult, {
                  VoidCallback refetch,
                  FetchMore fetchMore,
                }) {
                  if (userQueryResult.loading) {
                    return LoadingWidget();
                  }
                  Map user;
                  if (userQueryResult.data != null) {
                    if (userQueryResult.data['user'] != null) {
                      user = userQueryResult.data['user'];
                    }
                  }

                  return user != null && user['role'] == 'ADMIN'
                      ? AdminBookingsScreenWidget()
                      : ClientBookingsScreenWidget();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
