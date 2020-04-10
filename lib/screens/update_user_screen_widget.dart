/*
*  update_user_screen_widget.dart
*  UpdateUserScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:email_validator/email_validator.dart';

import './signin_screen_widget.dart';

import '../widgets/text_form_field_widget.dart';
import '../widgets/app_drawer.dart';
import '../widgets/loading_widget.dart';
import '../widgets/top_bar_shape_widget.dart';
import '../widgets/alert_dialog_widget.dart';

import '../values/values.dart';

import '../graphql/mutations.dart';
import '../graphql/queries.dart';


import '../utils/general_util.dart';

class UpdateUserScreenWidget extends StatefulWidget {
  static final String routeName = '/update-user';

  @override
  _UpdateUserScreenWidgetState createState() => _UpdateUserScreenWidgetState();
}

class _UpdateUserScreenWidgetState extends State<UpdateUserScreenWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _displayName;
  String _newPassword;
  String _password;
  String _phoneNumber;

  Future<void> _submit(Function updateUserMutation) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    await updateUserMutation({
      'email': _email,
      'displayName': _displayName,
      'newPassword': _newPassword,
      'password': _password,
      'phoneNumber': _phoneNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Edit profile'),
      ),
      drawer: AppDrawer(),
      body: Query(
        options: QueryOptions(
          documentNode:
              gql(Queries().user), // this is the query string you just created
        ),
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
          if (user == null) {
            Navigator.of(context).pushReplacementNamed(SignInScreenWidget.routeName);
          }
          return RefreshIndicator(
            onRefresh: refetch,
            child: Mutation(
              options: MutationOptions(
                documentNode: gql(Mutations().updateUser),
                update: (Cache cache, QueryResult result) {
                  return cache;
                },
                onCompleted: (dynamic updateUserResultData) async {
                  if (updateUserResultData != null) {
                    String message =
                        updateUserResultData['updateUser']['message'];
                    if (message.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialogWidget(
                            title: 'Completed',
                            message: message,
                            navigateTo: UpdateUserScreenWidget.routeName,
                          );
                        },
                      );
                      refetch();
                    }
                  }
                },
              ),
              builder: (
                RunMutation updateUserMutation,
                QueryResult updateUserResult,
              ) {
                String errorResponseMessage;
                if (updateUserResult.hasException) {
                  errorResponseMessage = GeneralUtil()
                      .graphQLError(updateUserResult.exception.toString());
                }

                if (updateUserResult.loading) {
                  return LoadingWidget();
                }
                return Column(
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
                          "Edit profile",
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
                    SizedBox(height: mediaQuery.size.height * 0.02),
                    if (errorResponseMessage != null)
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                            left: mediaQuery.size.width * 0.085,
                            right: mediaQuery.size.width * 0.05,
                          ),
                          child: Text(
                            errorResponseMessage,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontFamily: "Arial",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: mediaQuery.size.height * 0.01),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormFieldWidget(
                                icon: Icon(
                                  Icons.person,
                                  size: 24,
                                  color: Colors.black26,
                                ),
                                label: '${user['displayName'][0].toUpperCase()}${user['displayName'].substring(1)}',
                                inputChange: (String input) {
                                  setState(() {
                                    _displayName = input.trim();
                                  });
                                },
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.02),
                              TextFormFieldWidget(
                                icon: Icon(
                                  Icons.email,
                                  size: 24,
                                  color: Colors.black26,
                                ),
                                label: user['email'],
                                inputChange: (String input) {
                                  setState(() {
                                    _email = input.trim();
                                  });
                                },
                                validator: (String input) {
                                  if (input.isNotEmpty &&
                                      !EmailValidator.validate(input.trim())) {
                                    return 'Invalid email';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.02),
                              TextFormFieldWidget(
                                icon: Icon(
                                  Icons.phone,
                                  size: 24,
                                  color: Colors.black26,
                                ),
                                label: user['phoneNumber'],
                                inputChange: (String input) {
                                  setState(() {
                                    _phoneNumber = input.trim();
                                  });
                                },
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.02),
                              TextFormFieldWidget(
                                icon: Icon(
                                  Icons.lock,
                                  size: 22,
                                  color: Colors.black26,
                                ),
                                label: "New password",
                                inputChange: (String input) {
                                  setState(() {
                                    _newPassword = input;
                                  });
                                },
                                secret: true,
                                validator: (String input) {
                                  if (input.isNotEmpty && input.length < 5) {
                                    return 'Should be least 5 characters.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.02),
                              TextFormFieldWidget(
                                icon: Icon(
                                  Icons.lock,
                                  size: 24,
                                  color: Colors.black26,
                                ),
                                label: "Current password",
                                inputChange: (String input) {
                                  setState(() {
                                    _password = input;
                                  });
                                },
                                secret: true,
                                validator: (String input) {
                                  if (input.isEmpty) {
                                    return 'Current assword is required.';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.02),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: mediaQuery.size.width * 0.85,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    gradient: Gradients.primaryGradient,
                                    border: Border.fromBorderSide(
                                        Borders.primaryBorder),
                                    boxShadow: [
                                      Shadows.primaryShadow,
                                    ],
                                    borderRadius: Radii.k10pxRadius,
                                  ),
                                  child: FlatButton(
                                    child: Text(
                                      'Edit profile',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: AppColors.primaryText,
                                        fontFamily: "Arial",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () async {
                                      _submit(updateUserMutation);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: mediaQuery.size.height * 0.03),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
