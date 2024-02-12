import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../helpers/app_logger.dart';
import '../../helpers/navigation_service.dart';

class PushNotificationService {
  static final PushNotificationService _singleton =
      PushNotificationService._internal();

  factory PushNotificationService() {
    return _singleton;
  }

  PushNotificationService._internal();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  BuildContext? context = NavigationService.navigatorKey.currentContext;

  Future<void> requestNotificationPermission() async {
    await firebaseMessaging.requestPermission();
  }

  Future<void> subscribeToUid(String topicId) async {
    await firebaseMessaging.subscribeToTopic(topicId);

    // save the topic id in local storage
    // LocalStorage().setSubId(topicId);
    Log.info("uid sub success for --> $topicId");
  }

  Future<void> unSubscribeToUid(String topicId) async {
    await firebaseMessaging.unsubscribeFromTopic(topicId);

    // empty the topic id in local storage
    // LocalStorage().setSubId(topicId);
    Log.info("uid unsubscribe success for --> $topicId");
  }

  Future<void> getPushNotification() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleNavigation(initialMessage, forceNav: true);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Log.debug('Got a message whilst in the foreground!');
      showNotifyInForeground(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Log.debug(
          '---message---${message.notification!.title}--${message.notification!.body}--${message.data.toString()}');
      handleNavigation(message);
      Log.debug('A new onMessageOpenedApp event was published!');
    });
  }

  showNotifyInForeground(RemoteMessage message) {
    bool isTapHandled = false;

    Log.debug(
        '------showNotifyInForeground-----${message.data['type']}-- ${message.data}--${message.data['data']}');
    //setPushStatus(message);

    return showOverlayNotification(
      (context) {
        return GestureDetector(
          onTap: () {
            if (!isTapHandled) {
              handleNavigation(message);
              isTapHandled = true;
            }
          },
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(15, 45, 15, 15),
              decoration: const BoxDecoration(
                color: Colors.amber,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.75))
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${message.notification?.title}",
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${message.notification?.body}",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      duration: const Duration(seconds: 3),
    );
  }

  void handleNavigation(RemoteMessage message, {bool forceNav = false}) {
    //     try {
    //   if (message.data.containsKey('type')) {
    //     String? orderId;
    //     String? priceRequestId;
    //     bool isNavigateToChatPage = false;

    //     Log.debug(
    //         '------push notify type-----${message.data["type"]}--${message.data['data']}');

    //     Map<String, dynamic> payload = json.decode(message.data['data']);

    //     if (message.data["type"] == NotificationType.ADMIN_CHAT &&
    //         payload.containsKey('quotation_id') &&
    //         payload.containsKey('status')) {
    //       String orderStatus = payload['status'];
    //       if (orderStatus == OrderStatus.DELIVERED.stringValue ||
    //           orderStatus == OrderStatus.INACTIVE.stringValue ||
    //           orderStatus == OrderStatus.CUSTOMER_REJECTED.stringValue) {
    //         isNavigateToChatPage = true;
    //       } else {
    //         isNavigateToChatPage = false;
    //       }
    //     }

    //     if (payload.containsKey('quotation_id')) {
    //       orderId = payload['quotation_id'];
    //     } else if (payload.containsKey('price_request_id')) {
    //       priceRequestId = payload['price_request_id'];
    //     }

    //     switch (message.data['type']) {
    //       case NotificationType.ORDER_CREATE:
    //       case NotificationType.ORDER_UPDATE:
    //         getNotificationUpdates();
    //         navigateToAdminOrderDetailsPage(
    //             orderId: orderId, forceNav: forceNav);
    //         break;

    //       case NotificationType.PRICE_REQUEST_CREATE:
    //         getNotificationUpdates();
    //         navigateToAdminPriceRequestPage(
    //             priceRequest:
    //                 PriceRequestItem.fromJson(processInitialData(message)),
    //             forceNav: forceNav);
    //         break;

    //       case NotificationType.CANCEL_ORDER: // to admin
    //         getNotificationUpdates();
    //         navigateToAdminOrderDetailsPage(
    //             orderId: orderId, forceNav: forceNav);
    //         break;

    //       case NotificationType.SET_CUTOFF_DATE:
    //       case NotificationType.ADMIN_CANCEL_ORDER: // to customer
    //         getNotificationUpdates();
    //         navigateToCurrentOrderTab(
    //             orderId: orderId!, forceNav: forceNav, isForCustomer: true);
    //         break;

    //       case NotificationType.ORDER_DELIVERED:
    //         getNotificationUpdates();
    //         navigateToCustomerOrderDetailsPage(
    //             orderId: orderId!, forceNav: forceNav, isForCustomer: true);
    //         break;

    //       case NotificationType.ADMIN_CHAT: // to customer
    //         getNotificationUpdates();

    //         var data = processInitialData(message);
    //         if (data.containsKey('request_number')) {
    //           navigateToAdminPriceRequestPage(
    //             priceRequest:
    //                 PriceRequestItem.fromJson(processInitialData(message)),
    //             forceNav: forceNav,
    //             isNavigateToChat: true,
    //             isForCustomer: true,
    //           );
    //         } else {
    //           if (isNavigateToChatPage) {
    //             navigateToCustomerOrderDetailsPage(
    //                 orderId: orderId!,
    //                 forceNav: forceNav,
    //                 isForCustomer: true,
    //                 isNavigateToChat: true);
    //           } else {
    //             navigateToCurrentOrderTab(
    //                 orderId: orderId!,
    //                 forceNav: forceNav,
    //                 isNavigateToChat: true,
    //                 isForCustomer: true);
    //           }
    //         }
    //         break;
    //       case NotificationType.ORDER_REMINDER:
    //         getNotificationUpdates();
    //         navigateToCurrentOrderTab(
    //           orderId: orderId!,
    //           forceNav: forceNav,
    //           isForCustomer: true,
    //         );
    //         break;
    //       case NotificationType.CUSTOMER_CHAT: // to admin
    //         getNotificationUpdates();
    //         var data = processInitialData(message);
    //         if (data.containsKey('request_number')) {
    //           navigateToAdminPriceRequestPage(
    //             priceRequest:
    //                 PriceRequestItem.fromJson(processInitialData(message)),
    //             forceNav: forceNav,
    //             isNavigateToChat: true,
    //           );
    //         } else {
    //           navigateToAdminOrderDetailsPage(
    //               orderId: orderId, forceNav: forceNav, isNavigateToChat: true);
    //         }

    //         break;
    //       default:
    //         break;
    //     }
    //   }
    // } catch (err) {
    //   Log.err('push notification $err');
    // }
  }

// Navigate to screens
  void navigateToCustomerOrderDetailsPage({
    required String orderId,
    bool forceNav = false,
    bool isNavigateToChat = false,
    bool isForCustomer = false,
  }) {
    if (context == null) return;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Navigator.pushNamed(context!, OrderDetailPage.routeName, arguments: {
    //     "orderId": orderId,
    //     "isFromPushNotify": forceNav ? true : false,
    //     "isNavigateToChat": isNavigateToChat,
    //     "isForCustomer": isForCustomer,
    //   });
    // });
  }

  Map<String, dynamic> processInitialData(RemoteMessage message) {
    int startIndex = message.data['data'].indexOf('{');
    int endIndex = message.data['data'].lastIndexOf('}');
    String jsonSubstring =
        message.data['data'].substring(startIndex, endIndex + 1);

    return json.decode(jsonSubstring);
  }
}
