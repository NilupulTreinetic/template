// ignore_for_file: non_constant_identifier_names

/*
  This file included the net urls that we used for API Request.

*/

class URL {
  static String SERVER = "https://dev-getin-api.treinetic.xyz/api/v1.0";

  static String SIGN_UP = "$SERVER/register";

  static String COMPLETE_RIDE_BY_RIDE_ID = "$SERVER/ride/{rideId}/finish";
}
