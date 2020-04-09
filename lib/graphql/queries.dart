/*
*  queries.dart
*  Queries
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

class Queries {
  String get user {
    return '''
      query USER_QUERY {
        user {
          id
          email
          displayName
          phoneNumber
          role
        }
      }
    ''';
  }

  String get userWithBookings {
    return '''
      query USER_WITH_BOOKINGS_QUERY {
        user {
          id
          email
          displayName
          phoneNumber
          role
          bookings {
            id
            status
            date
            time
            cut {
              id
              tittle
              image
              description
              price
            }
          }
        }
      }
    ''';
  }

  String get cuts {
    return '''
      query CUTS_QUERY {
        cuts {
          id
          title
          image
          description
          price
        }
      }
    ''';
  }

  String get bookings {
    return '''
      query BOOKINGS_QUERY {
        bookings {
          id
          status
          date
          time
          cut {
            id
            tittle
            image
            description
            price
          }
        }
      }
    ''';
  }

  String get bookingsWithUser {
    return '''
      query BOOKINGS_QUERY {
        bookings {
          id
          status
          date
          time
          cut {
            id
            title
            image
            description
            price
          }
          user {
            id
            email
            displayName
            phoneNumber
            role
          }
        }
      }
    ''';
  }
}