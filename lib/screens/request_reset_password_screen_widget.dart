/*
*  request_reset_password_screen_widget.dart
*  RequestResetPasswordScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:email_validator/email_validator.dart';

import './reset_password_screen_widget.dart';

import '../widgets/text_form_field_widget.dart';
import '../widgets/app_drawer.dart';
import '../widgets/loading_widget.dart';
import '../widgets/top_bar_shape_widget.dart';
import '../widgets/alert_dialog_widget.dart';


import '../values/values.dart';

import '../graphql/mutations.dart';

import '../utils/general_util.dart';

class RequestResetPasswordWidget extends StatefulWidget {
  static final String routeName = '/request-password-reset';

  @override
  _RequestResetPasswordWidgetState createState() =>
      _RequestResetPasswordWidgetState();
}

class _RequestResetPasswordWidgetState
    extends State<RequestResetPasswordWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;

  Future<void> _submit(Function requestResetPasswordMutation) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    await requestResetPasswordMutation({
      'email': _email,
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Request password reset'),
      ),
      drawer: AppDrawer(),
      body: Mutation(
        options: MutationOptions(
          documentNode: gql(Mutations().requestPasswordReset),
          update: (Cache cache, QueryResult result) {
            return cache;
          },
          onCompleted: (dynamic requestResetPasswordResultData) async {
            if (requestResetPasswordResultData != null) {
              String message =
                  requestResetPasswordResultData['requestPasswordReset']
                      ['message'];
              if (message.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialogWidget(
                      title: 'Completed',
                      message: message,
                      navigateTo: ResetPasswordWidget.routeName,
                      replacePreviousNavigation: true,
                    );
                  },
                );
              }
            }
          },
        ),
        builder: (
          RunMutation requestResetPasswordMutation,
          QueryResult requestResetPasswordResults,
        ) {
          String errorResponseMessage;
          if (requestResetPasswordResults.hasException) {
            errorResponseMessage = GeneralUtil()
                .graphQLError(requestResetPasswordResults.exception.toString());
          }

          if (requestResetPasswordResults.loading) {
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
                    "Request password reset",
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
                            Icons.email,
                            size: 24,
                            color: Colors.black26,
                          ),
                          label: "Email",
                          initialValue: _email,
                          inputChange: (String input) {
                            setState(() {
                              _email = input.trim();
                            });
                          },
                          validator: (String input) {
                            if (input.isEmpty) {
                              return 'Email is required';
                            }
                            if (!EmailValidator.validate(input.trim())) {
                              return 'Invalid email';
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
                                'Request',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: "Arial",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () async {
                                _submit(requestResetPasswordMutation);
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
