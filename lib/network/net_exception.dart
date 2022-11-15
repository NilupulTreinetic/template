// ignore_for_file: constant_identifier_names

import 'dart:convert';

class FirebaseExceptions {
  static const String EMAIL_IN_USE = "email-already-in-use";
  static const String USER_NOT_FOUND = "user-not-found";
}

class AuthException {
  static const String TOKEN_NOT_FOUND = "token-not-found";
  static const String USER_NOT_FOUND = "user does not exists";
  static const String INVALID_USER_CREDENTIALS = "Invalid user credentials";
  static const String TOKEN_EXPIRED = "Token is Expired";
}

class CommonMessages {
  static const String EMPTY_DATA = "No data found";
  static const String EMAIL_SEND_ERROR = "Email Send Error";
  static const String INVALID_USER_CREDENTIALS = "Invalid user credentials";
  static const String SERVER_UNDER_MAINTENANCE =
      "Server is currently under maintenance";
  static const String UNAUTHORIZED_ACCESS = "Unauthorized access";
  static const String ENDPOINT_NOT_FOUND = "Something went wrong";
  static const String WENT_WRONG = "Something went wrong";
  static const String LOGIN_ERROR = "Login Error";
}

class ExceptionCode {
  static const int CODE_400 = 400;
  static const int CODE_000 = 000;
}

class CommonMessageId {
  static const String EMPTY_DATA_ID = "EMPTY_DATA";
  static const String INVALID_USER_CRED_ID = "INVALID_REQUEST";
  static const String SERVICE_UNAVAILABLE = "SERVICE_UNAVAILABLE";
  static const String UNAUTHORIZED = "UNAUTHORIZED";
  static const String NOT_FOUND = "NOT_FOUND";
  static const String SOMETHING_WENT_WRONG = "SOMETHING_WENT_WRONG";
  static const String LOGIN_ERROR = "LOGIN_NOT_SUCCESS";
}

NetException netExceptionFromJson(String str) =>
    NetException.fromJson(json.decode(str));

String netExceptionToJson(NetException data) => json.encode(data.toJson());

class NetException {
  String? error;
  String? message;
  String? messageId;
  int? code;

  NetException({
    this.error,
    this.message,
    this.messageId,
    this.code,
  });

  factory NetException.fromJson(Map<String, dynamic> json) => NetException(
        error: json["error"],
        messageId: json["message_id"],
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message_id": messageId,
        "message": message,
        "code": code,
      };
}
