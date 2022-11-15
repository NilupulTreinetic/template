class URL {
  static String SERVER = "https://dev-getin-api.treinetic.xyz/api/v1.0";

  static String SIGN_UP =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/register";

  static String SIGN_IN =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/login";

  static String FORGOT_PASSWORD =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/forget-password";

  static String GET_USER_PROFILE =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/init";
  static String GET_HOME_INFO =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/home";

  static String CREATE_PROFILE =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/profile";

  static String LOGIN_WITH_SOCIAL =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/login/social";

  static String REQUEST_OTP =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/otp/request";

  static String REQUEST_NEW_OTP =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/new-otp/request";

  static String VERIFY_OTP =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/otp/verify";

  static String RESET_PASSWORD =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/reset-password";

  static String RECOVER_PASSWORD =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/recover-password";

  static String VERIFY_VEHICLE =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/vehicle";

  static String GET_VEHICLES =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/vehicle";

  static String UPDATE_VEHICLE =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/vehicle/update";

  static String UPDATE_PROFILE =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/profile/update";

  static String DELETE_VEHICLE =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/vehicle/{id}";

  static String GET_RIDE_DETAILS =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/ride/{id}/details";

  static String ACCEPT_RIDE = "https://dev-getin-api.treinetic.xyz/api/v1.0" +
      "/ride/details/{rideDetailsId}/accept";

  static String LEAVE_ACCEPTED_RIDE =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/ride/{id}/leave";

  static String CANCEL_RIDE =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/ride/{id}/cancel";

  static String START_RIDE =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/ride/{id}/start";

  static String CREATE_RIDE =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/ride";

  static String GET_JOINED_RIDES =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/ride/joined/list";

  static String GET_YOUR_RIDES =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/ride/{status}";

  static String FIND_RIDES = "https://dev-getin-api.treinetic.xyz/api/v1.0" +
      "/ride/find/{from}/{to}/{lat}/{long}";

  static String JOIN_RIDES =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/ride/{id}/attend";

  static String GET_RIDE_NOTIFICATIONS =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/ride-notifications";

  static String ACCEPT_JOIN_REQUEST =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" +
          "/ride/details/{rideDetailsId}/accept";

  static String DECLINE_JOIN_REQUEST =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" +
          "/ride/details/{rideDetailsId}/reject";

  static String ADD_NEW_LOCATION =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/location";

  static String FIND_LOCATION =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/location/{name}";

  static String ADD_MID_LOCATIONS =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/mid-locations";

  static String UPDATE_DRIVER_CURRENT_LOCATION =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" +
          "/current-location/ride/{rideId}";

  static String GET_POLYLINE_DATA_BY_RIDE_ID =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" +
          "/ride/{rideId}/polyline";

  static String GET_DRIVER_LIVE_LOCATION_BY_RIDE_ID =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" +
          "/live-location/ride/{rideId}";

  static String PICKUP_DROPOFF_BY_DRIVER =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" +
          "/ride/picked-dropped/driver";

  static String PICKUP_DROPOFF_BY_PASSENGER =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" +
          "/ride/picked-dropped/passenger";

  static String GET_TOPICS =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/topics";

  static String GET_INAPP_NOTIFICATIONS =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/in-app/notifications";

  static String SEND_RATING =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/feedback";
  static String COMPLETE_RIDE_BY_RIDE_ID =
      "https://dev-getin-api.treinetic.xyz/api/v1.0" + "/ride/{rideId}/finish";
}
