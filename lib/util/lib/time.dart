import 'package:azzoa_grocery/constants.dart';
import 'package:intl/intl.dart';

class TimeUtil {
  static String getFormattedDate(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  static String getFormattedDateFromText(
    String dateTime,
    String givenFormat,
    String desiredFormat,
  ) {
    if (dateTime == null) return kDefaultString;

    DateTime receivedDateTime = DateFormat(givenFormat, "en").parse(dateTime);
    return DateFormat(desiredFormat).format(receivedDateTime);
  }

  static DateTime firstClickTime;

  static bool isRedundentClick(DateTime currentTime) {
    if (firstClickTime == null) {
      firstClickTime = currentTime;
      print("first click");
      return false;
    }
    print('diff is ${currentTime.difference(firstClickTime).inSeconds}');
    if (currentTime.difference(firstClickTime).inSeconds < 3) {
      //set this difference time in seconds
      return true;
    }

    firstClickTime = currentTime;
    return false;
  }
}
