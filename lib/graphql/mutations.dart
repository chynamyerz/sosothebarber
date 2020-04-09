/*
*  mutations.dart
*  Mutation
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

class Mutations {
  String get signUp {
    return '''
      mutation SIGNUP_MUTATION (
        \$email: String!
        \$displayName: String!
        \$password: String!
        \$phoneNumber: String!
      ){
        signup(
          email: \$email
          displayName: \$displayName
          password: \$password
          phoneNumber: \$phoneNumber
        ){
          message
        }
      }
    ''';
  }

  String get signIn {
    return '''
      mutation SIGNIN_MUTATION (
        \$email: String!
        \$password: String!
      ){
        signin(
          email: \$email
          password: \$password
        ){
          token
        }
      }
    ''';
  }

  String get updateUser {
    return '''
      mutation USER_UPDATE_MUTATION (
        \$email: String
        \$displayName: String
        \$newPassword: String
        \$password: String!
        \$phoneNumber: String
      ) {
        updateUser(
          email: \$email
          displayName: \$displayName
          newPassword: \$newPassword
          password: \$password
          phoneNumber: \$phoneNumber
        ) {
          message
        }
      }
    ''';
  }

  String get requestPasswordReset {
    return '''
      mutation REQUEST_PASSWORD_RESET_MUTATION (
        \$email: String!
      ) {
        requestPasswordReset(
          email: \$email
        ) {
          message
        }
      }
    ''';
  }

  String get resetPassword {
    return '''
      mutation RESET_PASSWORD_MUTATION (
        \$oneTimePin: String!
        \$password: String!
      ) {
        resetPassword(
          oneTimePin: \$oneTimePin
          password: \$password
        ) {
          message
        }
      }
    ''';
  }

  String get bookPending {
    return '''
      mutation BOOK_PENDING_MUTATION (
        \$userId: ID!
        \$cutId: ID!
        \$dayTime: String!
      ) {
        bookPending (
          userId: \$userId
          cutId: \$cutId
          dayTime: \$dayTime
        ) {
          message
        }
      }
    ''';
  }

  String get bookSucceed {
    return '''
      mutation BOOK_SUCCEED_MUTATION (
        \$bookingId: ID!
        \$status: Boolean!
      ) {
        bookSucceed (
          bookingId: \$bookingId
          status: \$status
        ) {
          message
        }
      }
    ''';
  }

  String get cancelBooking {
    return '''
      mutation CANCEL_BOOKING_MUTATION (
        \$bookingId: ID!
      ) {
        cancelBooking (
          bookingId: \$bookingId
        ) {
          message
        }
      }
    ''';
  }

  String get manageBooking {
    return '''
      mutation MANAGE_BOOKING_MUTATION (
        \$bookingId: ID!
        \$action: String!
      ) {
        manageBooking (
          bookingId: \$bookingId
          action: \$action
        ) {
          message
        }
      }
    ''';
  }
}