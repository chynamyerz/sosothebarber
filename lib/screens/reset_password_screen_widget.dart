/*
*  reset_password_screen_widget.dart
*  ResetPasswordScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import './signin_screen_widget.dart';

import '../widgets/alert_dialog_widget.dart';
import '../widgets/text_form_field_widget.dart';
import '../widgets/app_drawer.dart';
import '../widgets/loading_widget.dart';
import '../widgets/top_bar_shape_widget.dart';

import '../values/values.dart';

import '../graphql/mutations.dart';

import '../utils/general_util.dart';

class ResetPasswordWidget extends StatefulWidget {
  static final String routeName = '/reset-password';

  @override
  _ResetPasswordWidgetState createState() => _ResetPasswordWidgetState();
}

class _ResetPasswordWidgetState extends State<ResetPasswordWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _oneTimePin;
  String _password;

  Future<void> _submit(Function resetPasswordMutation) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    await resetPasswordMutation({
      'oneTimePin': _oneTimePin,
      'password': _password,
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Reset password'),
      ),
      drawer: AppDrawer(),
      body: Mutation(
        options: MutationOptions(
          documentNode: gql(Mutations().resetPassword),
          update: (Cache cache, QueryResult result) {
            return cache;
          },
          onCompleted: (dynamic resetPasswordResultData) async {
            if (resetPasswordResultData != null) {
              String message =
              resetPasswordResultData['resetPassword']
              ['message'];
              if (message.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialogWidget(
                      title: 'Completed',
                      message: message,
                      navigateTo: SignInScreenWidget.routeName,
                    );
                  },
                );
              }
            }
          },
        ),
        builder: (
            RunMutation resetPasswordMutation,
            QueryResult resetPasswordResult,
            ) {
          String errorResponseMessage;
          if (resetPasswordResult.hasException) {
            errorResponseMessage =
                GeneralUtil().graphQLError(resetPasswordResult.exception.toString());
          }

          if (resetPasswordResult.loading) {
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
                    "Reset password",
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
              SizedBox(height: mediaQuery.size.height * 0.022),
              if (errorResponseMessage != null) Align(
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
                            Icons.security,
                            size: 24,
                            color: Colors.black26,
                          ),
                          label: "One time pin",
                          inputChange: (input) {
                            setState(() {
                              _oneTimePin = input;
                            });
                          },
                          validator: (String input) {
                            if (input.isEmpty) {
                              return 'One time pin is required';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        TextFormFieldWidget(
                          icon: Icon(
                            Icons.lock,
                            size: 22,
                            color: Colors.black26,
                          ),
                          label: "Password",
                          inputChange: (String input) {
                            setState(() {
                              _password = input;
                            });
                          },
                          secret: true,
                          validator: (String input) {
                            if (input.isEmpty) {
                              return 'Password is required';
                            }
                            if (input.length < 5) {
                              return 'Should be least 5 characters.';
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
                              border:
                              Border.fromBorderSide(Borders.primaryBorder),
                              boxShadow: [
                                Shadows.primaryShadow,
                              ],
                              borderRadius: Radii.k10pxRadius,
                            ),
                            child: FlatButton(
                              child: Text(
                                'Reset',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: "Arial",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () async {
                                _submit(resetPasswordMutation);
                              },
                            ),
                          ),
                        ),
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
  }
}
