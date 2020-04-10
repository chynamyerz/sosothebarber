/*
*  signin_screen_widget.dart
*  SignInScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:email_validator/email_validator.dart';

import './home_screen_widget.dart';
import './signup_screen_widget.dart';
import './request_reset_password_screen_widget.dart';


import '../widgets/text_form_field_widget.dart';
import '../widgets/app_drawer.dart';
import '../widgets/loading_widget.dart';
import '../widgets/top_bar_shape_widget.dart';

import '../values/values.dart';

import '../graphql/mutations.dart';

import '../utils/auth_util.dart';
import '../utils/general_util.dart';

class SignInScreenWidget extends StatefulWidget {
  static final String routeName = '/signin';

  @override
  _SignInScreenWidgetState createState() => _SignInScreenWidgetState();
}

class _SignInScreenWidgetState extends State<SignInScreenWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _password;

  Future<void> _submit(Function signInMutation) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    await signInMutation({
      'email': _email,
      'password': _password,
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Sign in'),
      ),
      drawer: AppDrawer(),
      body: Mutation(
        options: MutationOptions(
          documentNode: gql(Mutations().signIn),
          update: (Cache cache, QueryResult result) {
            return cache;
          },
          onCompleted: (dynamic signInResultData) async {
            if (signInResultData != null) {
              String token = signInResultData['signin']['token'];
              Map user = signInResultData['signin']['user'];
              if (token.isNotEmpty && user != null) {
                await AuthUtil().setToken(token);

                await AuthUtil().setUser(jsonEncode(user));

                Navigator.of(context)
                    .pushReplacementNamed(HomeScreenWidget.routeName);
              }
            }
          },
        ),
        builder: (
          RunMutation signInMutation,
          QueryResult signInResult,
        ) {
          String errorResponseMessage;
          if (signInResult.hasException) {
            errorResponseMessage =
                GeneralUtil().graphQLError(signInResult.exception.toString());
          }

          if (signInResult.loading) {
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
                    "Sign in",
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
                            Icons.email,
                            color: Colors.black26,
                            size: 24,
                          ),
                          label: "Email",
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
                                'Sign in',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: "Arial",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () async {
                                _submit(signInMutation);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.025),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 28),
                            child: GestureDetector(
                              child: Text(
                                "Forgot password?",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: "Arial",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(RequestResetPasswordWidget.routeName);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.025),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 28, bottom: 20),
                            child: GestureDetector(
                              child: Text(
                                "Don’t have an account? Join now.",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: "Arial",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(SignUpScreenWidget.routeName);
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
