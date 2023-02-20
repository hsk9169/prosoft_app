class NumberHandler {
  String addComma(String value) {
    String ret = '';
    List<String> temp = [];
    final count = value.length ~/ 3;
    if (count == 0) {
      ret = value;
    }
    final remainder = value.length % 3;
    for (int i = 0; i < count; i++) {
      temp.add(
          value.substring(value.length - 3 * (i + 1), value.length - 3 * i));
      if (i + 1 == count && remainder > 0) {
        temp.add(value.substring(0, remainder));
      }
    }
    temp.asMap().forEach((key, value) {
      ret = ret + temp[temp.length - key - 1];
      if (key < temp.length - 1) {
        ret += ',';
      }
    });
    return ret;
  }

  String getDateFromDatetime(String datetime) {
    String ret = '';
    String date = datetime.split(' ')[0];
    List<String> strSplit = date.split('-');
    for (int i = 0; i < strSplit.length; i++) {
      ret += strSplit[i];
      if (i < strSplit.length - 1) {
        ret += '.';
      }
    }
    return ret;
  }

  String getTimeFromDatetime(String datetime) {
    String time = datetime.split(' ')[1];
    return time.substring(0, 5);
  }
}
