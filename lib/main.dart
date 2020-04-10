/*
*  main.dart
*  SigninScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sosothebarber/screens/book_screen_widget.dart';
import 'package:sosothebarber/screens/bookings_management_screen_widget.dart';
import 'package:sosothebarber/screens/client_bookings_screen_widget.dart';
import 'package:sosothebarber/screens/request_reset_password_screen_widget.dart';
import 'package:sosothebarber/screens/reset_password_screen_widget.dart';
import 'package:sosothebarber/screens/signup_screen_widget.dart';
import 'package:sosothebarber/screens/update_user_screen_widget.dart';
import 'package:sosothebarber/utils/auth_util.dart';

import './screens/home_screen_widget.dart';
import './screens/signin_screen_widget.dart';

Future main() async {
  await DotEnv().load('.env');
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: 'http://192.168.1.35:4000/',
//      uri: 'https://sosothebarber-api.now.sh/',
    );

    String token;

    final AuthLink authLink = AuthLink(
      getToken: () async {
        token = await AuthUtil().getToken();

        return token != null ? 'Bearer $token' : null;
      },
    );

    final Link link = authLink.concat(httpLink);

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: link,
      ),
    );

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Soso the barber',
        theme: ThemeData(primaryColor: Color.fromARGB(255, 247, 255, 255)),
        home: SignInScreenWidget(),
        routes: {
          HomeScreenWidget.routeName: (_) => HomeScreenWidget(),
          SignInScreenWidget.routeName: (_) => SignInScreenWidget(),
          SignUpScreenWidget.routeName: (_) => SignUpScreenWidget(),
          RequestResetPasswordWidget.routeName: (_) => RequestResetPasswordWidget(),
          ResetPasswordWidget.routeName: (_) => ResetPasswordWidget(),
          UpdateUserScreenWidget.routeName: (_) => UpdateUserScreenWidget(),
          BookScreenWidget.routeName: (_) => BookScreenWidget(),
          BookingsManagementScreenWidget.routeName: (_) => BookingsManagementScreenWidget(),
        },
      ),
    );
  }
}
