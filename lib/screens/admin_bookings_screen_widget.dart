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
import 'package:sosothebarber/screens/bookings_management_screen_widget.dart';
import 'package:sosothebarber/widgets/alert_dialog_widget.dart';
import 'package:sosothebarber/widgets/loading_widget.dart';

import '../widgets/app_drawer.dart';
import '../widgets/top_bar_shape_widget.dart';

import '../graphql/mutations.dart';

import '../utils/general_util.dart';

import '../values/values.dart';

class AdminBookingsScreenWidget extends StatelessWidget {
  Future<void> _submit(
      {Function manageBookingsMutation,
      String bookingId,
      String action}) async {
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
        options: QueryOptions(documentNode: gql(Queries().bookingsWithUser)),
        builder: (
          QueryResult bookingsQueryResult, {
          VoidCallback refetch,
          FetchMore fetchMore,
        }) {
          if (bookingsQueryResult.loading) {
            return LoadingWidget();
          }

          List<dynamic> bookings = bookingsQueryResult.data != null
              && bookingsQueryResult.data['bookingsWithUser'] != null ? bookingsQueryResult.data['bookingsWithUser']
              : [];

          return RefreshIndicator(
            onRefresh: refetch,
            child: Mutation(
              options: MutationOptions(
                documentNode: gql(Mutations().manageBookings),
                update: (Cache cache, QueryResult result) {
                  return cache;
                },
                onCompleted: (dynamic manageBookingsResultData) async {
                  if (manageBookingsResultData != null) {
                    String message =
                        manageBookingsResultData['manageBookings']['message'];
                    if (message.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialogWidget(
                            title: 'Completed',
                            message: message,
                            navigateTo: BookingsManagementScreenWidget.routeName,
                          );
                        },
                      );
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
                      .graphQLError(manageBookingsResult.exception.toString());
                }

                if (manageBookingsResult.loading) {
                  return LoadingWidget();
                }

                return RefreshIndicator(child: Column(
                  children: <Widget>[
                    if (bookings.length <= 0)
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            left: mediaQuery.size.width * 0.085,
                            right: mediaQuery.size.width * 0.085,
                            top: mediaQuery.size.height * 0.15,
                          ),
                          child: Text(
                            "Sorry!\nThere are no bookings made.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontFamily: "Arial Black",
                              fontWeight: FontWeight.w900,
                              fontSize: mediaQuery.size.height * 0.025,
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
                    if (bookings.length > 0)
                      Container(
                        height: mediaQuery.size.height * 0.45,
                        margin: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: bookings.length,
                          itemBuilder: (ctx, index) {
                            return Card(
                              elevation: 5,
                              color: Theme.of(context).primaryColor,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Booked by",
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Title",
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Description",
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Price",
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Status",
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              ":",
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              ":",
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              ":",
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              ":",
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              ":",
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${bookings[index]['user']['displayName'][0].toString().toUpperCase()}${bookings[index]['user']['displayName'].toString().substring(1)}',
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              bookings[index]['cut']['title'],
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              bookings[index]['cut']
                                              ['description'],
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              'R${bookings[index]['cut']['price']}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontFamily: "Arial",
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            if (bookings[index]['status'] ==
                                                'ACTIVE')
                                              Text(
                                                '${bookings[index]['status']}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.lightGreen,
                                                  fontFamily: "Arial",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (bookings[index]['status'] ==
                                                'PENDING')
                                              Text(
                                                '${bookings[index]['status']}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.amberAccent,
                                                  fontFamily: "Arial",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (bookings[index]['status'] ==
                                                'CANCELLED')
                                              Text(
                                                '${bookings[index]['status']}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontFamily: "Arial",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (bookings[index]['status'] ==
                                                'DONE')
                                              Text(
                                                '${bookings[index]['status']}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.lightBlueAccent,
                                                  fontFamily: "Arial",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (bookings[index]['status'] == 'ACTIVE')
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              height: 25,
                                              margin: EdgeInsets.only(
                                                  top: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.lightBlueAccent,
                                                border: Border.fromBorderSide(
                                                    Borders.primaryBorder),
                                                boxShadow: [
                                                  Shadows.primaryShadow,
                                                ],
                                                borderRadius: Radii.k10pxRadius,
                                              ),
                                              child: FlatButton(
                                                child: Text(
                                                  'Finished',
                                                  style: TextStyle(
                                                    color:
                                                    AppColors.primaryText,
                                                    fontFamily: "Arial",
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  _submit(
                                                      manageBookingsMutation:
                                                      manageBookingsMutation,
                                                      bookingId: bookings[index]
                                                      ['id'],
                                                      action: 'done');
                                                },
                                              )),
                                          Spacer(),
                                          Container(
                                              height: 25,
                                              margin: EdgeInsets.only(
                                                  top: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent,
                                                border: Border.fromBorderSide(
                                                    Borders.primaryBorder),
                                                boxShadow: [
                                                  Shadows.primaryShadow,
                                                ],
                                                borderRadius: Radii.k10pxRadius,
                                              ),
                                              child: FlatButton(
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color:
                                                    AppColors.primaryText,
                                                    fontFamily: "Arial",
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  _submit(
                                                      manageBookingsMutation:
                                                      manageBookingsMutation,
                                                      bookingId: bookings[index]
                                                      ['id'],
                                                      action: 'cancel');
                                                },
                                              )),
                                        ],
                                      ),
                                    if (bookings[index]['status'] == 'PENDING')
                                      Container(
                                        height: 25,
                                        margin:
                                        EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white60,
                                          border: Border.fromBorderSide(
                                              Borders.primaryBorder),
                                          boxShadow: [
                                            Shadows.primaryShadow,
                                          ],
                                          borderRadius: Radii.k10pxRadius,
                                        ),
                                        child: FlatButton(
                                          child: Text(
                                            'Refresh',
                                            style: TextStyle(
                                              color: AppColors.primaryText,
                                              fontFamily: "Arial",
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          onPressed: () async {
                                            _submit(
                                                manageBookingsMutation:
                                                manageBookingsMutation,
                                                bookingId: bookings[index]
                                                ['id'],
                                                action: 'refresh');
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
                ), onRefresh: refetch);
              },
            ),
          );
        });
  }
}
