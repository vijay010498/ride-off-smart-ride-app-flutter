class TextFormatHelper{

  static String maskPhoneNumber(String phoneNumber) {
    // Format: 905-783-5***
    if (phoneNumber.length >= 10) {
      return "${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6, 6)}***";
    } else {
      // Handle cases where the phone number is not long enough
      return phoneNumber;
    }
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Format: 905-783-5***
    if (phoneNumber.length >= 10) {
      return "${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6, 10)}";
    } else {
      // Handle cases where the phone number is not long enough
      return phoneNumber;
    }
  }
}