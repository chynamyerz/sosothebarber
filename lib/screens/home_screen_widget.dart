/*
*  home_screen_widget.dart
*  HomeScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sosothebarber/graphql/queries.dart';
import 'package:sosothebarber/screens/book_screen_widget.dart';
import 'package:sosothebarber/widgets/loading_widget.dart';

import '../widgets/app_drawer.dart';
import '../widgets/top_bar_shape_widget.dart';

import '../graphql/mutations.dart';

import '../utils/general_util.dart';

import '../values/values.dart';

class HomeScreenWidget extends StatefulWidget {
  static final String routeName = '/home';

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _selectedDateTime;
  String _cutId;
  String _userId;
  String _itemName;
  String _itemDescription;
  String _error;
  double _itemPrice;

  Future<void> _submit(Function bookMutation) async {
    if (_userId == null) {
      print('H');
      setState(() {
        _error = 'You must be logged in to book';
      });
      return;
    }
    if (_selectedDateTime == null) {
      setState(() {
        _error = 'Please select the date and the time';
      });
      return;
    }
    if (_cutId == null) {
      setState(() {
        _error = 'Something went wrong, please try again later';
      });
      return;
    }

    String year = GeneralUtil().twoDigitWholeNumber(_selectedDateTime.year);
    String month = GeneralUtil().twoDigitWholeNumber(_selectedDateTime.month);
    String day = GeneralUtil().twoDigitWholeNumber(_selectedDateTime.day);
    String hour = GeneralUtil().twoDigitWholeNumber(_selectedDateTime.hour);
    String minute = GeneralUtil().twoDigitWholeNumber(_selectedDateTime.minute);
    String second = GeneralUtil().twoDigitWholeNumber(_selectedDateTime.second);

    try {
      final response = await bookMutation({
        'userId': _userId,
        'cutId': _cutId,
        'dayTime': '$year-$month-$day\T$hour:$minute:$second\Z',
      });
      setState(() {
        _error = null;
        _selectedDateTime = null;
        _cutId = null;
      });
    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Home'),
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
                bottom: mediaQuery.size.height * 0.01,
              ),
              child: Text(
                "Make a booking",
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
                  Map user;
                  if (userQueryResult.data != null) {
                    if (userQueryResult.data['user'] != null) {
                      user = userQueryResult.data['user'];
                    }
                  }

                  return RefreshIndicator(
                    onRefresh: refetch,
                    child: Mutation(
                      options: MutationOptions(
                        documentNode: gql(Mutations().bookPending),
                        update: (Cache cache, QueryResult result) {
                          return cache;
                        },
                        onCompleted: (dynamic bookPendingResultData) async {
                          if (bookPendingResultData != null) {
                            String message =
                                bookPendingResultData['bookPending']['message'];
                            if (message.isNotEmpty) {
                              Navigator.of(context).pushNamed(
                                BookScreenWidget.routeName,
                                arguments: {
                                  'bookingId': message,
                                  'itemName': _itemName,
                                  'itemDescription': _itemDescription,
                                  'itemPrice': _itemPrice,
                                },
                              );
                            }
                          }
                        },
                      ),
                      builder: (
                        RunMutation bookPendingMutation,
                        QueryResult bookPendingResult,
                      ) {
                        String errorResponseMessage;
                        if (bookPendingResult.hasException) {
                          errorResponseMessage = GeneralUtil().graphQLError(
                              bookPendingResult.exception.toString());
                        }

                        if (bookPendingResult.loading) {
                          return LoadingWidget();
                        }

                        return Query(
                          options:
                              QueryOptions(documentNode: gql(Queries().cuts)),
                          builder: (
                            QueryResult cutsQueryResult, {
                            VoidCallback refetch,
                            FetchMore fetchMore,
                          }) {
                            if (cutsQueryResult.loading) {
                              return LoadingWidget();
                            }

                            List<dynamic> cuts = cutsQueryResult.data != null
                                ? cutsQueryResult.data['cuts']
                                : [];
                            return Column(
                              children: <Widget>[
                                if (cuts.length <= 0)
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: mediaQuery.size.width * 0.085,
                                        right: mediaQuery.size.width * 0.085,
                                        top: mediaQuery.size.height * 0.15,
                                      ),
                                      child: Text(
                                        "Sorry!\nYour barber is currently not online.\nPlease try again later.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.primaryText,
                                          fontFamily: "Arial Black",
                                          fontWeight: FontWeight.w900,
                                          fontSize:
                                              mediaQuery.size.height * 0.025,
                                        ),
                                      ),
                                    ),
                                  ),
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
                                if (_error != null)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: mediaQuery.size.width * 0.085,
                                        right: mediaQuery.size.width * 0.05,
                                      ),
                                      child: Text(
                                        _error,
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
                                if (cuts.length > 0)
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Card(
                                      elevation: 8,
                                      child: DateTimeField(
                                        format: DateFormat("yyyy-MM-dd HH:mm"),
                                        readOnly: true,
                                        style: TextStyle(
                                          color: AppColors.primaryText,
                                          fontFamily: "Arial",
                                          fontWeight: FontWeight.w400,
                                        ),
                                        decoration: InputDecoration(
                                            labelText: 'Select date & time',
                                            filled: true,
                                            fillColor:
                                                Theme.of(context).primaryColor,
                                            prefixIcon: Icon(
                                              Icons.calendar_today,
                                              size: 24,
                                              color: Colors.black26,
                                            ),
                                            contentPadding: EdgeInsets.only(
                                                left: mediaQuery.size.width *
                                                    0.02),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(5.0))),
                                        ),
                                        onShowPicker:
                                            (context, currentValue) async {
                                          final date = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime.now(),
                                              initialDate: currentValue ??
                                                  DateTime.now(),
                                              lastDate: DateTime.parse(
                                                  '${DateTime.now().year + 1}-01-01'));
                                          if (date != null) {
                                            final time = await showTimePicker(
                                              context: context,
                                              initialTime:
                                                  TimeOfDay.fromDateTime(
                                                      currentValue ??
                                                          DateTime.now()),
                                            );
                                            return DateTimeField.combine(
                                                date, time);
                                          } else {
                                            return currentValue;
                                          }
                                        },
                                        onChanged: (input) {
                                          setState(() {
                                            _selectedDateTime = input;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                SizedBox(height: mediaQuery.size.height * 0.02),
                                if (cuts.length > 0)
                                  Container(
                                    height: mediaQuery.size.height * 0.4,
                                    margin: EdgeInsets.all(10),
                                    child: ListView.builder(
                                      itemCount: cuts.length,
                                      itemBuilder: (ctx, index) {
                                        return Card(
                                          elevation: 5,
                                          color: Theme.of(context).primaryColor,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "Title",
                                                          style: TextStyle(
                                                            fontFamily: "Arial",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Description",
                                                          style: TextStyle(
                                                            fontFamily: "Arial",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Price",
                                                          style: TextStyle(
                                                            fontFamily: "Arial",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          ":",
                                                          style: TextStyle(
                                                            fontFamily: "Arial",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          ":",
                                                          style: TextStyle(
                                                            fontFamily: "Arial",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          ":",
                                                          style: TextStyle(
                                                            fontFamily: "Arial",
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          cuts[index]['title'],
                                                          style: TextStyle(
                                                            fontFamily: "Arial",
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          cuts[index]
                                                              ['description'],
                                                          style: TextStyle(
                                                            fontFamily: "Arial",
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          'R${cuts[index]['price']}',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontFamily: "Arial",
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 25,
                                                  margin: EdgeInsets.only(
                                                      top: 10),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.lightGreenAccent,
                                                    border:
                                                        Border.fromBorderSide(
                                                            Borders
                                                                .primaryBorder),
                                                    boxShadow: [
                                                      Shadows.primaryShadow,
                                                    ],
                                                    borderRadius:
                                                        Radii.k10pxRadius,
                                                  ),
                                                  child: FlatButton(
                                                    child: Text(
                                                      'Book',
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .primaryText,
                                                        fontFamily: "Arial",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      setState(() {
                                                        _cutId =
                                                            cuts[index]['id'];
                                                        _userId = user != null
                                                            ? user['id']
                                                            : null;
                                                        _itemName = cuts[index]
                                                            ['title'];
                                                        _itemDescription =
                                                            cuts[index]
                                                                ['description'];
                                                        _itemPrice = double
                                                            .parse(cuts[index]
                                                                    ['price']
                                                                .toString());
                                                      });

                                                      _submit(
                                                          bookPendingMutation);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
