/*
*  book_screen_widget.dart
*  BookScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sosothebarber/screens/bookings_management_screen_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screens/home_screen_widget.dart';

import '../widgets/app_drawer.dart';

import '../graphql/mutations.dart';

class BookScreenWidget extends StatelessWidget {
  static final String routeName = '/book';

  @override
  Widget build(BuildContext context) {
    Completer<WebViewController> _webViewController =
        Completer<WebViewController>();

    final DotEnv dotEnv = DotEnv();
    final bool isProduction = bool.fromEnvironment('dart.vm.product');
    final String payFastUrl = isProduction
        ? dotEnv.env['PAYFAST_PROD']
        : dotEnv.env['PAYFAST_SANDBOX'];
    final String payFastMerchantId = isProduction
        ? dotEnv.env['MERCHANT_ID_PROD']
        : dotEnv.env['MERCHANT_ID_SANDBOX'];
    final String payFastMerchantKey = isProduction
        ? dotEnv.env['MERCHANT_KEY_PROD']
        : dotEnv.env['MERCHANT_KEY_SANDBOX'];
    final String successUrl = dotEnv.env['SUCCESS_URL'];
    final String cancelUrl = dotEnv.env['CANCEL_URL'];

    final Map arguments = ModalRoute.of(context).settings.arguments;
    final String itemName = arguments['itemName'];
    final String itemDescription = arguments['itemDescription'];
    final double itemPrice = arguments['itemPrice'];
    final String bookingId = arguments['bookingId'];

    final String url = Uri.encodeFull(
        '$payFastUrl?merchant_id=$payFastMerchantId&merchant_key=$payFastMerchantKey&item_name=$itemName&item_description=$itemDescription&amount=$itemPrice&return_url=$successUrl&cancel_url=$cancelUrl'
    );
        print(url);

    Future<void> _submit(Function bookMutation, bool status) async {
      try {
        final response = await bookMutation({
          'bookingId': bookingId,
          'status': status,
        });
      } catch (error) {
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Home'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Mutation(
          options: MutationOptions(
            documentNode: gql(Mutations().bookSucceed),
            update: (Cache cache, QueryResult result) {
              return cache;
            },
            onCompleted: (dynamic bookSucceedResultData) async {
              if (bookSucceedResultData != null) {
                String message =
                    bookSucceedResultData['bookSucceed']['message'];
                if (message.isNotEmpty) {
                  print('Done');
                }
              }
            },
          ),
          builder: (
            RunMutation bookSucceedMutation,
            QueryResult bookSucceedResult,
          ) {

            return WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) async {
                _webViewController.complete(webViewController);
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url == cancelUrl) {
                  _submit(bookSucceedMutation, false);
                  Navigator.of(context)
                      .pushReplacementNamed(HomeScreenWidget.routeName);
                }

                if (request.url == successUrl) {
                  _submit(bookSucceedMutation, true);
                  Navigator.of(context)
                      .pushReplacementNamed(BookingsManagementScreenWidget.routeName);
                }

                return NavigationDecision.navigate;
              },
            );
          },
        ),
      ),
    );
  }
}
