/*
*  app_drawer_widget.dart
*  AppDrawer
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sosothebarber/screens/contact_screen_widget.dart';

import '../screens/home_screen_widget.dart';
import '../screens/signin_screen_widget.dart';
import '../screens/signup_screen_widget.dart';
import '../screens/update_user_screen_widget.dart';
import '../screens/bookings_management_screen_widget.dart';

import '../utils/auth_util.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Map _user;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });

    AuthUtil().getUser().then((res) {
      print(res);
      if (res != null) {
        setState(() {
          _user = jsonDecode(res);
        });
      }
    }).catchError((error) {
      setState(() {
        _user = null;
      });
    });
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            accountName: _isLoading
                ? Text('Loading')
                : Text(
                    _user != null
                        ? '${_user['displayName'][0].toUpperCase()}${_user['displayName'].substring(1)}'
                        : 'Not logged in.',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
            accountEmail: _isLoading
                ? Text('...')
                : Text(
                    _user != null ? _user['email'] : '',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white70,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      _user != null
                          ? '${_user['displayName'][0].toUpperCase()}'
                          : '',
                      style: TextStyle(
                          fontSize: 40.0, color: Color.fromARGB(255, 0, 0, 0)),
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
                    Navigator.of(context).pushNamed(HomeScreenWidget.routeName);
                  },
                ),
                if (_user != null)
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
                if (_user != null)
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
                    Navigator.of(context).pushNamed(HomeScreenWidget.routeName);
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
                        .pushNamed(ContactScreenWidget.routeName);
                  },
                ),
                Divider(),
                if (_user == null)
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
                if (_user == null)
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
                if (_user != null)
                  ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.signOutAlt,
                      color: Colors.black26,
                    ),
                    title: Text("Sign out"),
                    onTap: () async {
                      await AuthUtil().setToken(null);
                      await AuthUtil().setUser(null);

                      Navigator.of(context)
                          .pushReplacementNamed(SignInScreenWidget.routeName);
                    },
                  ),
                Divider(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
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
    );
  }
}
