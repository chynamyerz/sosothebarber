/*
*  app_drawer_widget.dart
*  AppDrawer
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sosothebarber/screens/bookings_management_screen_widget.dart';

import '../screens/home_screen_widget.dart';
import '../screens/signin_screen_widget.dart';
import '../screens/signup_screen_widget.dart';
import '../screens/update_user_screen_widget.dart';

import '../graphql/queries.dart';

import '../utils/auth_util.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode:
            gql(Queries().user), // this is the query string you just created
      ),
      builder: (
        QueryResult userQueryResult, {
        VoidCallback refetch,
        FetchMore fetchMore,
      }) {
        Map user;
        if (userQueryResult.data != null) {
          if (userQueryResult.data['user'] != null) {
            user = userQueryResult.data['user'];
          }
        }
        return Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountName: userQueryResult.loading
                    ? Text('Loading')
                    : Text(
                        user != null
                            ? '${user['displayName'][0].toUpperCase()}${user['displayName'].substring(1)}'
                            : 'Not logged in.',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                accountEmail: userQueryResult.loading
                    ? Text('...')
                    : Text(
                        user != null ? user['email'] : '',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: userQueryResult.loading
                      ? CircularProgressIndicator()
                      : Text(
                          user != null
                              ? '${user['displayName'][0].toUpperCase()}'
                              : '',
                          style: TextStyle(
                              fontSize: 40.0,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        color: Colors.black26,
                      ),
                      title: Text("Home"),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(HomeScreenWidget.routeName);
                      },
                    ),
                    if (user != null)
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.history,
                          color: Colors.black26,
                        ),
                        title: Text("Manage bookings"),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(BookingsManagementScreenWidget.routeName);
                        },
                      ),
                    if (user != null)
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.userEdit,
                          color: Colors.black26,
                        ),
                        title: Text("Edit profile"),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(UpdateUserScreenWidget.routeName);
                        },
                      ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.black26,
                      ),
                      title: Text("About"),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(HomeScreenWidget.routeName);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.contacts,
                        color: Colors.black26,
                      ),
                      title: Text("Contact"),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(HomeScreenWidget.routeName);
                      },
                    ),
                    Divider(),
                    if (user == null)
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.signInAlt,
                          color: Colors.black26,
                        ),
                        title: Text("Sign in"),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SignInScreenWidget.routeName);
                        },
                      ),
                    if (user == null)
                      ListTile(
                        leading: Icon(
                          Icons.person_add,
                          color: Colors.black26,
                        ),
                        title: Text("Sign up"),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SignUpScreenWidget.routeName);
                        },
                      ),
                    if (user != null)
                      ListTile(
                        leading: FaIcon(
                          FontAwesomeIcons.signOutAlt,
                          color: Colors.black26,
                        ),
                        title: Text("Sign out"),
                        onTap: () async {
                          await AuthUtil().setToken(null);

                          Navigator.of(context)
                              .pushReplacementNamed(SignInScreenWidget.routeName);
                        },
                      ),
                    Divider(),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Copyright © 2020 QOS-Software Solutions (Pty, Ltd)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'v0.0.1',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
