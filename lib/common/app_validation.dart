class AppValidator {
  static final AppValidator _singleton = AppValidator._internal();

  factory AppValidator() {
    return _singleton;
  }

  AppValidator._internal();

  String? validatePassword(
      {required String input, required String errorMessage}) {
    var pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(input)) {
      return errorMessage;
    }
    return null;
  }

  String? validateEmail({
    required String input,
  }) {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (input.isEmpty) {
      return 'Email is required';
    }
    if (!regex.hasMatch(input.trim())) {
      return "Enter a valid email";
    }
    return null;
  }

  String? validateFirstName(String value) {
    if (value.isEmpty) {
      return 'First name is required';
    }

    if (value.length < 4 || value.length > 50) {
      return 'Name should be between 4 and 50 characters';
    }

    if (RegExp(r'^[0-9\W]+$').hasMatch(value)) {
      return 'Name should not contain only numbers or special characters';
    }

    return null;
  }

  String? validateLastName(String value) {
    if (value.isEmpty) {
      return 'Last name is required';
    }

    if (value.length < 4 || value.length > 50) {
      return 'Name should be between 4 and 50 characters';
    }

    if (RegExp(r'^[0-9\W]+$').hasMatch(value)) {
      return 'Name should not contain only numbers or special characters';
    }

    return null;
  }

  String? validateUSZipCode(String input) {
    RegExp usZipCodePattern = RegExp(r'^\d{5}(?:[-\s]\d{4})?$');
    if (input.isEmpty) {
      return 'Zip Code is required';
    }
    if (!usZipCodePattern.hasMatch(input)) {
      return 'Enter valid Zip Code';
    }
    return null;
  }

  validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10 && phoneNumber.startsWith('0')) {
      return true;
    } else {
      return false;
    }
  }
}
