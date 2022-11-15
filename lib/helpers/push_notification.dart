// import 'dart:async';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// import 'package:overlay_support/overlay_support.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import 'app_logger.dart';

// class PushNotification {
//   static final PushNotification _singleton = PushNotification._internal();

//   factory PushNotification() {
//     return _singleton;
//   }

//   PushNotification._internal();

//   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//   StreamSubscription iosSubscription;
//   BuildContext context;

//   setContext(context) {
//     this.context = context;
//   }

//   void getMessage() async {
//     if (Platform.isIOS) iOS_Permission();
//     RemoteMessage initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     if (initialMessage != null) {
//       handleNavigation(initialMessage);
//     }

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       Log.debug('Got a message whilst in the foreground!');
//       showNotifyInForeground(message);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       Log.debug(
//           '---message---${message.notification.title}--${message.notification.body}--${message.data.toString()}');
//       if (message != null) {
//         handleNavigation(message, forceNav: true);
//       }
//       Log.debug('A new onMessageOpenedApp event was published!');
//     });
//   }

//   void handleNavigation(RemoteMessage message, {bool forceNav = false}) async {
//     try {
//       if (message.data.containsKey('type')) {
//         Log.debug('------push notify type-----${message.data["type"]}');
//         if (message.data['type'] == NotificationType.DRIVER_ACCEPTED) {
//           navigateToJoinedRidesPage();
//         } else if (message.data['type'] == NotificationType.VEHICLE_REJECTED ||
//             message.data['type'] == NotificationType.VEHICLE_APPROVED) {
//           setPushStatus(message);
//           navigateToProfilePage();
//         } else if (message.data['type'] ==
//             NotificationType.PASSENGER_REQUESTED) {
//           navigateToNotificationPage();
//         } else if (message.data['type'] == NotificationType.DRIVER_PICKED) {
//           navigateToPassengerOngoingPage(isDriverDropped: false);
//         } else if (message.data['type'] == NotificationType.DRIVER_DROPPED) {
//           navigateToPassengerOngoingPage(isDriverDropped: true);
//         } else if (message.data['type'] == NotificationType.PASSENGER_DROPPED) {
//           navigateToDriverOngoingPage(
//               isPassengerDropped: true,
//               passenger: userFromJson(message.data['data']));
//         }
//       }
//     } catch (err) {
//       Log.debug(err);
//     }
//   }

//   setPushStatus(RemoteMessage message) {
//     if (message.data['type'] == NotificationType.VEHICLE_REJECTED) {
//       Provider.of<DriverProvider>(context, listen: false)
//           .setIsVehicleInactive(isVehicleInactive: true);
//     } else if (message.data['type'] == NotificationType.VEHICLE_APPROVED) {
//       Provider.of<DriverProvider>(context, listen: false)
//           .setIsVehicleInactive(isVehicleInactive: false);
//       Provider.of<DriverProvider>(context, listen: false)
//           .setIsVehicleActive(isVehicleActive: true);
//     } else if (message.data['type'] == NotificationType.DRIVER_DROPPED) {
//       Provider.of<DriverProvider>(context, listen: false)
//           .setIsPassengerDropedOff(isPassengerDroppedOff: true);
//     } else if (message.data['type'] == NotificationType.PASSENGER_DROPPED) {
//       // Provider.of<DriverProvider>(context, listen: false)
//       //     .setIsPassengerDropedOff(isPassengerDroppedOff: true);
//     }
//   }

//   showNotifyInForeground(RemoteMessage message) {
//     Log.debug(
//         '------showNotifyInForeground-----${message.data['type']}-- ${message.data}--${message.data['data']}');
//     setPushStatus(message);
//     return showOverlayNotification(
//       (context) {
//         return GestureDetector(
//           onTap: () => handleNavigation(message),
//           child: Material(
//             type: MaterialType.transparency,
//             child: Container(
//               width: double.infinity,
//               padding: EdgeInsets.fromLTRB(15, 60, 15, 15),
//               decoration: BoxDecoration(
//                 color:
//                     message.data['type'] == NotificationType.VEHICLE_REJECTED ||
//                             message.data['type'] ==
//                                 NotificationType.DRIVER_VERIFY_REJECTED
//                         ? AppColors.dangerAlertColor
//                         : AppColors.blueColor,
//                 boxShadow: <BoxShadow>[
//                   BoxShadow(
//                       color: Colors.black54,
//                       blurRadius: 15.0,
//                       offset: Offset(0.0, 0.75))
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.error,
//                     color: Colors.white,
//                   ),
//                   SizedBox(width: 20),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${message.notification.title}",
//                           style: CustomTextStyles.bold23BlackStyle()
//                               .copyWith(fontSize: 11.sp, color: Colors.white),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "${message.notification.body}",
//                           style: TextStyle(color: Colors.white, fontSize: 15),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//       duration: Duration(seconds: 5),
//     );
//   }

//   navigateToPassengerOngoingPage({bool isDriverDropped}) {
//     if (context == null) return;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Navigator.pushNamed(context, PassengerOngoingRide.routeName, arguments: {
//         'isNavigateFromPushNotify': true,
//         'isDropOffNotification': isDriverDropped
//       });
//     });
//   }

//   navigateToDriverOngoingPage({bool isPassengerDropped, User passenger}) {
//     if (context == null) return;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Navigator.pushNamed(context, DriverOngoingRide.routeName, arguments: {
//         'isNavigateFromPushNotify': true,
//         'isDropOffNotification': isPassengerDropped,
//         'passenger': passenger
//       });
//     });
//   }

//   navigateToJoinedRidesPage() {
//     if (context == null) return;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Navigator.pushNamed(context, JoinedRidesPage.routeName,
//           arguments: {'isNavigateFromPushNotify': true});
//     });
//   }

//   navigateToProfilePage() {
//     if (context == null) return;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Navigator.pushNamed(context, ProfilePage.routeName, arguments: 1);
//     });
//   }

//   navigateToNotificationPage() {
//     if (context == null) return;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Navigator.pushNamed(context, NotificationPage.routeName);
//     });
//   }

//   void iOS_Permission() async {
//     NotificationSettings settings = await firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//   }

//   register() {
//     firebaseMessaging.getToken().then((token) => Log.info(token));
//   }

//   subscribeToUid(Topic topic) async {
//     await firebaseMessaging
//         .subscribeToTopic("${topic.general}-${topic.userId}");
//     LocalStorage().setFirebaseSubId("${topic.general}-${topic.userId}");
//     Log.info("uid sub success for --> ${topic.general}-${topic.userId}");
//   }

//   unSubscribeToUid(Topic topic) async {
//     await firebaseMessaging
//         .unsubscribeFromTopic("${topic.general}-${topic.userId}");
//     LocalStorage().setFirebaseSubId("");
//     Log.info(
//         "uid unsubscribe success for --> ${topic.general}-${topic.userId}");
//   }

//   subscribe() async {
//     var topics = [];

//     for (var topic in topics) {
//       firebaseMessaging.subscribeToTopic("$topic");
//       Log.info("topics subscribe success for - $topic");
//     }
//   }
// }
