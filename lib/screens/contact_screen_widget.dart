/*
*  contact_screen_widget.dart
*  ContactScreen
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sosothebarber/values/colors.dart';
import 'package:sosothebarber/widgets/top_bar_shape_widget.dart';

import '../widgets/app_drawer.dart';

class ContactScreenWidget extends StatefulWidget {
  static final String routeName = '/contact';

  @override
  _ContactScreenWidgetState createState() => _ContactScreenWidgetState();
}

class _ContactScreenWidgetState extends State<ContactScreenWidget> {
  String errorMessage;

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
                bottom: mediaQuery.size.height * 0.02,
              ),
              child: Text(
                "Contact",
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

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (errorMessage != null)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: mediaQuery.size.width * 0.085,
                          right: mediaQuery.size.width * 0.05,
                        ),
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontFamily: "Arial",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  Card(
                    elevation: 8,
                    child: GestureDetector(
                      child: ListTile(
                        leading: FaIcon(FontAwesomeIcons.instagramSquare, color: Colors.pinkAccent,),
                        title: Text(
                          'soso-da-barber',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (await canLaunch('https://instagram.com/soso_da_barber')) {
                          await launch('https://instagram.com/soso_da_barber');
                          setState(() {
                            errorMessage = null;
                          });
                        } else {
                          setState(() {
                            errorMessage = 'Could not launch instagram';
                          });
                        }
                      },
                    ),
                  ),
                  Divider(),
                  Card(
                    elevation: 8,
                    child: GestureDetector(
                      child: ListTile(
                        leading: FaIcon(FontAwesomeIcons.whatsappSquare, color: Colors.lightGreen,),
                        title: Text(
                          '+27 76 186 5013',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (await canLaunch('https://api.whatsapp.com/send?phone=+27761865013')) {
                          await launch('https://api.whatsapp.com/send?phone=+27761865013');
                          setState(() {
                            errorMessage = null;
                          });
                        } else {
                          setState(() {
                            errorMessage = 'Could not launch whatsapp';
                          });
                        }
                      },
                    ),
                  ),
                  Divider(),
                  Card(
                    elevation: 8,
                    child: GestureDetector(
                      child: ListTile(
                        leading: FaIcon(FontAwesomeIcons.facebookSquare, color: Colors.lightBlueAccent,),
                        title: Text(
                          'Soso-The-Barber',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                        onTap: () async {
                          if (await canLaunch('https://facebook.com/soso.moica.1')) {
                            await launch('https://facebook.com/soso.moica.1');
                            setState(() {
                              errorMessage = null;
                            });
                          } else {
                            setState(() {
                              errorMessage = 'Could not launch facebook';
                            });
                          }
                        },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
