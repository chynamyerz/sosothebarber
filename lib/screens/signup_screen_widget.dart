/*
*  signup_screen_widget.dart
*  SignUpScreen
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

import '../utils/general_util.dart';


class SignUpScreenWidget extends StatefulWidget {
  static final String routeName = '/signup';

  @override
  _SignUpScreenWidgetState createState() => _SignUpScreenWidgetState();
}

class _SignUpScreenWidgetState extends State<SignUpScreenWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _displayName;
  String _password;
  String _phoneNumber;

  Future<void> _submit(Function signInMutation) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    await signInMutation({
      'email': _email,
      'displayName': _displayName,
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
        title: Text('Sign up'),
      ),
      drawer: AppDrawer(),
      body: Mutation(
        options: MutationOptions(
          documentNode: gql(Mutations().signUp),
          update: (Cache cache, QueryResult result) {
            return cache;
          },
          onCompleted: (dynamic signUpResultData) async {
            if (signUpResultData != null) {
              String message = signUpResultData['signup']['message'];
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
          RunMutation signUpMutation,
          QueryResult signUpResult,
        ) {
          String errorResponseMessage;
          if (signUpResult.hasException) {
            errorResponseMessage =
                GeneralUtil().graphQLError(signUpResult.exception.toString());
          }

          if (signUpResult.loading) {
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
                    "Sign up",
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
                            Icons.person,
                            size: 24,
                            color: Colors.black26,
                          ),
                          label: "Display name",
                          inputChange: (String input) {
                            setState(() {
                              _displayName = input.trim();
                            });
                          },
                          validator: (String input) {
                            if (input.isEmpty) {
                              return 'Display name is required';
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        TextFormFieldWidget(
                          icon: Icon(
                            Icons.email,
                            size: 24,
                            color: Colors.black26,
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
                            Icons.phone,
                            size: 24,
                            color: Colors.black26,
                          ),
                          label: "Phone number",
                          inputChange: (String input) {
                            setState(() {
                              _phoneNumber = input.trim();
                            });
                          },
                          validator: (String input) {
                            if (input.isEmpty) {
                              return 'Phone number is required';
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
                            height: mediaQuery.size.height * 0.05,
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
                                'Sign up',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontFamily: "Arial",
                                  fontWeight: FontWeight.w400,
                                  fontSize: mediaQuery.size.height * 0.03,
                                ),
                              ),
                              onPressed: () async {
                                _submit(signUpMutation);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 28, bottom: 20),
                            child: GestureDetector(
                              child: Text(
                                "Already have an account? Sign in.",
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
                                    .pushNamed(SignInScreenWidget.routeName);
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
