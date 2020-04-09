/*
*  general_util.dart
*  GeneralUtil
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

class GeneralUtil {
  String twoDigitWholeNumber(int number) {
    return number.abs() < 10 ? '0$number' : number.toString();
  }

  String graphQLError(String errorMessage) {
    return errorMessage
        .replaceAll('GraphQL Errors:', '')
        .replaceAll(': Undefined location', '')
        .replaceAll('Network Errors:', '');
  }
}
