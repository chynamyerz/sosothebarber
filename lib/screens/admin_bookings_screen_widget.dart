/*
*  admin_bookings_screen_widget.dart
*  AdminBookingsScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sosothebarber/graphql/queries.dart';
import 'package:sosothebarber/screens/book_screen_widget.dart';
import 'package:sosothebarber/widgets/loading_widget.dart';

import '../widgets/app_drawer.dart';
import '../widgets/top_bar_shape_widget.dart';

import '../graphql/mutations.dart';

import '../utils/general_util.dart';

import '../values/values.dart';

class AdminBookingsScreenWidget extends StatelessWidget {
  Future<void> _submit(
      Function manageBookingsMutation, String bookingId, String action) async {
    try {
      final response = await manageBookingsMutation({
        'bookingId': bookingId,
        'action': action,
      });
    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Query(
        options:
        QueryOptions(documentNode: gql(Queries().bookingsWithUser)),
        builder: (
            QueryResult bookingsQueryResult, {
              VoidCallback refetch,
              FetchMore fetchMore,
            }){
          if (bookingsQueryResult.loading) {
            return LoadingWidget();
          }

          List<dynamic> bookings = bookingsQueryResult.data != null ? bookingsQueryResult.data['bookings'] : [];

          return Mutation(
            options: MutationOptions(
              documentNode: gql(Mutations().manageBooking),
              update: (Cache cache, QueryResult result) {
                return cache;
              },
              onCompleted:
                  (dynamic manageBookingsResultData) async {
                if (manageBookingsResultData != null) {
                  String message =
                  manageBookingsResultData['manageBooking']
                  ['message'];
                  if (message.isNotEmpty) {
                    Navigator.of(context).pushNamed(
                        BookScreenWidget.routeName);
                  }
                  refetch();
                }
              },
            ),
            builder: (
                RunMutation manageBookingsMutation,
                QueryResult manageBookingsResult,
                ) {
              String errorResponseMessage;
              if (manageBookingsResult.hasException) {
                errorResponseMessage = GeneralUtil()
                    .graphQLError(manageBookingsResult.exception
                    .toString());
              }

              if (manageBookingsResult.loading) {
                return LoadingWidget();
              }

              return Column(
                children: <Widget>[
                  if (bookings.length <= 0)
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          left:
                          mediaQuery.size.width * 0.085,
                          right:
                          mediaQuery.size.width * 0.085,
                          top:
                          mediaQuery.size.height * 0.15,
                        ),
                        child: Text(
                          "Sorry!\nThere are no bookings made.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontFamily: "Arial Black",
                            fontWeight: FontWeight.w900,
                            fontSize:
                            mediaQuery.size.height *
                                0.025,
                          ),
                        ),
                      ),
                    ),
                  if (errorResponseMessage != null)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                          left:
                          mediaQuery.size.width * 0.085,
                          right:
                          mediaQuery.size.width * 0.05,
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
                  SizedBox(
                      height:
                      mediaQuery.size.height * 0.01),
                  if (bookings.length > 0)
                    Container(
                      height: mediaQuery.size.height * 0.4,
                      child: ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (ctx, index) {
                          return Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: mediaQuery.size.width *
                                      0.85,
                                  height:
                                  mediaQuery.size.height *
                                      0.14,
                                  margin: EdgeInsets.only(
                                      bottom: mediaQuery
                                          .size.height *
                                          0.02),
                                  decoration: BoxDecoration(
                                    gradient: Gradients
                                        .primaryGradient,
                                    border:
                                    Border.fromBorderSide(
                                        Borders
                                            .primaryBorder),
                                    boxShadow: [
                                      Shadows.primaryShadow,
                                    ],
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            10)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Container(
                                        width: mediaQuery
                                            .size.width *
                                            0.85,
                                        height: mediaQuery
                                            .size.height *
                                            0.045,
                                        margin: EdgeInsets.only(
                                          left: mediaQuery
                                              .size.width *
                                              0.05,
                                          top: mediaQuery
                                              .size.height *
                                              0.02,
                                          right: mediaQuery
                                              .size.width *
                                              0.015,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: <
                                                  Widget>[
                                                Text(
                                                  "Booked by",
                                                  style:
                                                  TextStyle(
                                                    color: Color
                                                        .fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0),
                                                    fontFamily:
                                                    "Arial",
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: mediaQuery
                                                        .size
                                                        .height *
                                                        0.02,
                                                  ),
                                                ),
                                                Text(
                                                  "Title",
                                                  style:
                                                  TextStyle(
                                                    color: Color
                                                        .fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0),
                                                    fontFamily:
                                                    "Arial",
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: mediaQuery
                                                        .size
                                                        .height *
                                                        0.02,
                                                  ),
                                                ),
                                                Text(
                                                  "Price",
                                                  style:
                                                  TextStyle(
                                                    color: Color
                                                        .fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0),
                                                    fontFamily:
                                                    "Arial",
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: mediaQuery
                                                        .size
                                                        .height *
                                                        0.02,
                                                  ),
                                                ),
                                                if (bookings[index]['status'] == 'ACTIVE')
                                                  Text(
                                                    "Status",
                                                    style:
                                                    TextStyle(
                                                      color: Color
                                                          .fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0),
                                                      fontFamily:
                                                      "Arial",
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: mediaQuery
                                                          .size
                                                          .height *
                                                          0.02,
                                                    ),
                                                  ),
                                                if (bookings[index]['status'] == 'PENDING')
                                                  Text(
                                                    "Status",
                                                    style:
                                                    TextStyle(
                                                      color: Color
                                                          .fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0),
                                                      fontFamily:
                                                      "Arial",
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: mediaQuery
                                                          .size
                                                          .height *
                                                          0.02,
                                                    ),
                                                  ),
                                                if (bookings[index]['status'] == 'CANCELLED')
                                                  Text(
                                                    "Status",
                                                    style:
                                                    TextStyle(
                                                      color: Color
                                                          .fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0),
                                                      fontFamily:
                                                      "Arial",
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: mediaQuery
                                                          .size
                                                          .height *
                                                          0.02,
                                                    ),
                                                  ),
                                                if (bookings[index]['status'] == 'DONE')
                                                  Text(
                                                    "Status",
                                                    style:
                                                    TextStyle(
                                                      color: Color
                                                          .fromARGB(
                                                          255,
                                                          0,
                                                          0,
                                                          0),
                                                      fontFamily:
                                                      "Arial",
                                                      fontWeight:
                                                      FontWeight
                                                          .bold,
                                                      fontSize: mediaQuery
                                                          .size
                                                          .height *
                                                          0.02,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: <
                                                  Widget>[
                                                Text(
                                                  ":",
                                                  style:
                                                  TextStyle(
                                                    color: Color
                                                        .fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0),
                                                    fontFamily:
                                                    "Arial",
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: mediaQuery
                                                        .size
                                                        .height *
                                                        0.02,
                                                  ),
                                                ),
                                                Text(
                                                  ":",
                                                  style:
                                                  TextStyle(
                                                    color: Color
                                                        .fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0),
                                                    fontFamily:
                                                    "Arial",
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: mediaQuery
                                                        .size
                                                        .height *
                                                        0.02,
                                                  ),
                                                ),
                                                Text(
                                                  ":",
                                                  style:
                                                  TextStyle(
                                                    color: Color
                                                        .fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0),
                                                    fontFamily:
                                                    "Arial",
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: mediaQuery
                                                        .size
                                                        .height *
                                                        0.02,
                                                  ),
                                                ),
                                                Text(
                                                  ":",
                                                  style:
                                                  TextStyle(
                                                    color: Color
                                                        .fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0),
                                                    fontFamily:
                                                    "Arial",
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: mediaQuery
                                                        .size
                                                        .height *
                                                        0.02,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: <
                                                  Widget>[
                                                Text(
                                                  '${bookings[index]['user']
                                                  ['displayName'][0].toString().toUpperCase()}${bookings[index]['user']
                                                  ['displayName'][1]}',
                                                  style:
                                                  TextStyle(
                                                    color: Color
                                                        .fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0),
                                                    fontFamily:
                                                    "Arial",
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    fontSize: mediaQuery
                                                        .size
                                                        .height *
                                                        0.02,
                                                  ),
                                                ),
                                                Text(
                                                  bookings[index]['cut']
                                                  ['title'],
                                                  style:
                                                  TextStyle(
                                                    color: Color
                                                        .fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0),
                                                    fontFamily:
                                                    "Arial",
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    fontSize: mediaQuery
                                                        .size
                                                        .height *
                                                        0.02,
                                                  ),
                                                ),
                                                Text(
                                                  'R${bookings[index]['cut']['price']}',
                                                  textAlign:
                                                  TextAlign
                                                      .left,
                                                  style:
                                                  TextStyle(
                                                    color: Color
                                                        .fromARGB(
                                                        255,
                                                        0,
                                                        0,
                                                        0),
                                                    fontFamily:
                                                    "Arial",
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    fontSize: mediaQuery
                                                        .size
                                                        .height *
                                                        0.02,
                                                  ),
                                                ),
                                                if (bookings[index]['status'] == 'ACTIVE')
                                                  Text(
                                                    'R${bookings[index]['status']}',
                                                    textAlign:
                                                    TextAlign
                                                        .left,
                                                    style:
                                                    TextStyle(
                                                      color: Colors.lightGreenAccent,
                                                      fontFamily:
                                                      "Arial",
                                                      fontWeight:
                                                      FontWeight
                                                          .w400,
                                                      fontSize: mediaQuery
                                                          .size
                                                          .height *
                                                          0.02,
                                                    ),
                                                  ),
                                                if (bookings[index]['status'] == 'PENDING')
                                                  Text(
                                                    'R${bookings[index]['status']}',
                                                    textAlign:
                                                    TextAlign
                                                        .left,
                                                    style:
                                                    TextStyle(
                                                      color: Colors.amberAccent,
                                                      fontFamily:
                                                      "Arial",
                                                      fontWeight:
                                                      FontWeight
                                                          .w400,
                                                      fontSize: mediaQuery
                                                          .size
                                                          .height *
                                                          0.02,
                                                    ),
                                                  ),
                                                if (bookings[index]['status'] == 'CANCELLED')
                                                  Text(
                                                    'R${bookings[index]['status']}',
                                                    textAlign:
                                                    TextAlign
                                                        .left,
                                                    style:
                                                    TextStyle(
                                                      color: Colors.redAccent,
                                                      fontFamily:
                                                      "Arial",
                                                      fontWeight:
                                                      FontWeight
                                                          .w400,
                                                      fontSize: mediaQuery
                                                          .size
                                                          .height *
                                                          0.02,
                                                    ),
                                                  ),
                                                if (bookings[index]['status'] == 'DONE')
                                                  Text(
                                                    'R${bookings[index]['status']}',
                                                    textAlign:
                                                    TextAlign
                                                        .left,
                                                    style:
                                                    TextStyle(
                                                      color: Colors.lightBlueAccent,
                                                      fontFamily:
                                                      "Arial",
                                                      fontWeight:
                                                      FontWeight
                                                          .w400,
                                                      fontSize: mediaQuery
                                                          .size
                                                          .height *
                                                          0.02,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                        Alignment.topLeft,
                                        child: Container(
                                          width: mediaQuery
                                              .size.width *
                                              0.85,
                                          margin: EdgeInsets.only(
                                              left: mediaQuery
                                                  .size
                                                  .width *
                                                  0.05,
                                              bottom: mediaQuery
                                                  .size
                                                  .height *
                                                  0.005),
                                          child: Text(
                                            bookings[index]['cut']
                                            ['description'],
                                            style: TextStyle(
                                              color: Colors
                                                  .black26,
                                              fontFamily:
                                              "Arial",
                                              fontWeight:
                                              FontWeight
                                                  .w400,
                                              fontSize: mediaQuery
                                                  .size
                                                  .height *
                                                  0.02,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (bookings[index]['status'] == 'ACTIVE')
                                        Align(
                                          alignment:
                                          Alignment.topCenter,
                                          child: Container(
                                            width: mediaQuery
                                                .size.width *
                                                0.75,
                                            height: mediaQuery
                                                .size.height *
                                                0.035,
                                            decoration:
                                            BoxDecoration(
                                              gradient: Gradients
                                                  .primaryGradient,
                                              border: Border
                                                  .fromBorderSide(
                                                  Borders
                                                      .primaryBorder),
                                              boxShadow: [
                                                Shadows
                                                    .primaryShadow,
                                              ],
                                              borderRadius: Radii
                                                  .k10pxRadius,
                                            ),
                                            child: FlatButton(
                                              child: Text(
                                                'Cancel',
                                                textAlign:
                                                TextAlign
                                                    .left,
                                                style: TextStyle(
                                                  color: AppColors
                                                      .primaryText,
                                                  fontFamily:
                                                  "Arial",
                                                  fontWeight:
                                                  FontWeight
                                                      .w400,
                                                  fontSize: mediaQuery
                                                      .size
                                                      .height *
                                                      0.025,
                                                ),
                                              ),
                                              onPressed:
                                                  () async {
                                                _submit(
                                                    manageBookingsMutation,
                                                    '',
                                                    '');
                                              },
                                            ),
                                          ),
                                        ),
                                      if (bookings[index]['status'] == 'PENDING')
                                        Align(
                                          alignment:
                                          Alignment.topCenter,
                                          child: Container(
                                            width: mediaQuery
                                                .size.width *
                                                0.75,
                                            height: mediaQuery
                                                .size.height *
                                                0.035,
                                            decoration:
                                            BoxDecoration(
                                              gradient: Gradients
                                                  .primaryGradient,
                                              border: Border
                                                  .fromBorderSide(
                                                  Borders
                                                      .primaryBorder),
                                              boxShadow: [
                                                Shadows
                                                    .primaryShadow,
                                              ],
                                              borderRadius: Radii
                                                  .k10pxRadius,
                                            ),
                                            child: FlatButton(
                                              child: Text(
                                                'Refresh',
                                                textAlign:
                                                TextAlign
                                                    .left,
                                                style: TextStyle(
                                                  color: AppColors
                                                      .primaryText,
                                                  fontFamily:
                                                  "Arial",
                                                  fontWeight:
                                                  FontWeight
                                                      .w400,
                                                  fontSize: mediaQuery
                                                      .size
                                                      .height *
                                                      0.025,
                                                ),
                                              ),
                                              onPressed:
                                                  () async {
                                                _submit(
                                                    manageBookingsMutation,
                                                    '',
                                                    '');
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          );
        }
    );
  }
}
