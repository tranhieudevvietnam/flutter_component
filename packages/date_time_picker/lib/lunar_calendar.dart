import 'dart:math';

class LunarCalendar {
  static const timeZone = 7.0;
  static int _jdFromDate(int dd, int mm, int yy) {
    int a, y, m, jd;
    // ignore: division_optimization
    a = ((14 - mm) / 12).toInt();
    y = yy + 4800 - a;
    m = mm + 12 * a - 3;
    // ignore: division_optimization
    jd = dd + ((153 * m + 2) / 5).toInt() + 365 * y + (y / 4).toInt() - (y / 100).toInt() + (y / 400).toInt() - 32045;
    if (jd < 2299161) {
      // ignore: division_optimization
      jd = dd + ((153 * m + 2) / 5).toInt() + 365 * y + (y / 4).toInt() - 32083;
    }
    return jd;
  }

  static int _getLeapMonthOffset(a11) {
    var k, last, arc;

    k = ((a11 - 2415021.076998695) / 29.530588853 + 0.5).toInt();
    last = 0;
    int i = 1; // We start with the month following lunar month 11
    arc = _getSunLongitude(_getNewMoonDay(k + i));
    do {
      last = arc;
      i++;
      arc = _getSunLongitude(_getNewMoonDay(k + i));
    } while (arc != last && i < 14);
    return i - 1;
  }

  static int _getSunLongitude(jdn) {
    var T, T2, dr, M, L0, DL, L;
    int;
    T = (jdn - 2451545.5 - timeZone / 24) / 36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
    T2 = T * T;
    dr = pi / 180; // degree to radian
    M = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048 * T * T2; // mean anomaly, degree
    L0 = 280.46645 + 36000.76983 * T + 0.0003032 * T2; // mean longitude, degree
    DL = (1.914600 - 0.004817 * T - 0.000014 * T2) * sin(dr * M);
    DL = DL + (0.019993 - 0.000101 * T) * sin(dr * 2 * M) + 0.000290 * sin(dr * 3 * M);
    L = L0 + DL; // true longitude, degree
    L = L * dr;
    L = L - pi * 2 * ((L / (pi * 2)).toInt()); // Normalize to (0, 2*PI)
    return (L / pi * 6).toInt();
  }

  static _getLunarMonth11(yy) {
    int nm, sunLong;
    int off = _jdFromDate(31, 12, yy) - 2415021;
    // ignore: division_optimization
    int k = (off / 29.530588853).toInt();
    nm = _getNewMoonDay(k);
    sunLong = _getSunLongitude(nm); // sun longitude at local midnight
    if (sunLong >= 9) {
      nm = _getNewMoonDay(k - 1);
    }
    return nm;
  }

  static int _getNewMoonDay(k) {
    double T, T2, T3, dr, Jd1, M, Mpr, F, C1, deltat, JdNew;
    T = k / 1236.85; // Time in Julian centuries from 1900 January 0.5
    T2 = T * T;
    T3 = T2 * T;
    dr = pi / 180;
    Jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * T2 - 0.000000155 * T3;
    Jd1 = Jd1 + 0.00033 * sin((166.56 + 132.87 * T - 0.009173 * T2) * dr); // Mean new moon
    M = 359.2242 + 29.10535608 * k - 0.0000333 * T2 - 0.00000347 * T3; // Sun's mean anomaly
    Mpr = 306.0253 + 385.81691806 * k + 0.0107306 * T2 + 0.00001236 * T3; // Moon's mean anomaly
    F = 21.2964 + 390.67050646 * k - 0.0016528 * T2 - 0.00000239 * T3; // Moon's argument of latitude
    C1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M);
    C1 = C1 - 0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr);
    C1 = C1 - 0.0004 * sin(dr * 3 * Mpr);
    C1 = C1 + 0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + Mpr));
    C1 = C1 - 0.0074 * sin(dr * (M - Mpr)) + 0.0004 * sin(dr * (2 * F + M));
    C1 = C1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006 * sin(dr * (2 * F + Mpr));
    C1 = C1 + 0.0010 * sin(dr * (2 * F - Mpr)) + 0.0005 * sin(dr * (2 * Mpr + M));
    if (T < -11) {
      deltat = 0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3 - 0.000000081 * T * T3;
    } else {
      deltat = -0.000278 + 0.000265 * T + 0.000262 * T2;
    }
    JdNew = Jd1 + C1 - deltat;
    return (JdNew + 0.5 + timeZone / 24).toInt();
  }

  static List<int> convertSolar2Lunar(DateTime dateTime) {
    int a11, b11, lunarDay, lunarMonth, lunarYear, lunarLeap;
    int dayNumber = _jdFromDate(dateTime.day, dateTime.month, dateTime.year);
    // ignore: division_optimization
    int k = ((dayNumber - 2415021.076998695) / 29.530588853).toInt();
    int monthStart = _getNewMoonDay(k + 1);
    if (monthStart > dayNumber) {
      monthStart = _getNewMoonDay(k);
    }
    a11 = _getLunarMonth11(dateTime.year);
    b11 = a11;
    if (a11 >= monthStart) {
      lunarYear = dateTime.year;
      a11 = _getLunarMonth11(dateTime.year - 1);
    } else {
      lunarYear = dateTime.year + 1;
      b11 = _getLunarMonth11(dateTime.year + 1);
    }
    lunarDay = dayNumber - monthStart + 1;
    // ignore: division_optimization
    int diff = ((monthStart - a11) / 29).toInt();
    lunarLeap = 0;
    lunarMonth = diff + 11;
    if (b11 - a11 > 365) {
      int leapMonthDiff = _getLeapMonthOffset(a11);
      if (diff >= leapMonthDiff) {
        lunarMonth = diff + 10;
        if (diff == leapMonthDiff) {
          lunarLeap = 1;
        }
      }
    }
    if (lunarMonth > 12) {
      lunarMonth = lunarMonth - 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
      lunarYear -= 1;
    }

    return [lunarDay, lunarMonth, lunarYear];
  }

  static String getChiYear(int value) {
    // ignore: division_optimization
    final chiValue = (value - (60 * (value / 60).toInt())).abs().toInt();
    int aaa = chiValue;
    // ignore: division_optimization
    while ((aaa / 10).toInt() != 0) {
      aaa = aaa % 10;
    }
    // final aaa = value.toString().substring(value.toString().length-1);

    switch (aaa) {
      case 0:
        return "Canh";
      case 1:
        return "Tân";
      case 2:
        return "Nhâm";
      case 3:
        return "Quý";
      case 4:
        return "Giáp";
      case 5:
        return "Ất";
      case 6:
        return "Bính";
      case 7:
        return "Đinh";
      case 8:
        return "Mậu";
      case 9:
        return "Kỷ";
      default:
        return "none";
    }
  }

  static String getCanYear(int value) {
    // ignore: division_optimization
    final chiValue = (value - (60 * (value / 60).toInt())).abs().toInt();
    late int aaa = chiValue;
    while (aaa - 12 > 0) {
      aaa = aaa - 12;
    }
    switch (aaa) {
      case 4:
        return "tý";
      case 5:
        return "sửu";
      case 6:
        return "dần";
      case 7:
        return "mão";
      case 8:
        return "thìn";
      case 9:
        return "tỵ";
      case 10:
        return "ngọ";
      case 11:
        return "mùi";
      case 0:
        return "thân";
      case 1:
        return "dậu";
      case 2:
        return "tuất";
      case 3:
        return "hợi";
      default:
        return "none";
    }
  }

  static String getChiCanMonth(int month, int year) {
    String value = "";
    final chiYear = getChiYear(year);

    switch (month) {
      case 1:
        value = "Dần";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Bính $value";
            break;
          case "Ất":
          case "Canh":
            value = "Mậu $value";
            break;
          case "Bính":
          case "Tân":
            value = "Canh $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Nhâm $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Giáp $value";
            break;
          default:
            value = "none";
        }
        break;
      case 2:
        value = "Mão";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Đinh $value";
            break;
          case "Ất":
          case "Canh":
            value = "Kỷ $value";
            break;
          case "Bính":
          case "Tân":
            value = "Tân $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Quý $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Ất $value";
            break;
          default:
            value = "none";
        }

        break;
      case 3:
        value = "Thìn";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Mậu $value";
            break;
          case "Ất":
          case "Canh":
            value = "Canh $value";
            break;
          case "Bính":
          case "Tân":
            value = "Nhâm $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Giáp $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Bính $value";
            break;
          default:
            value = "none";
        }
        break;
      case 4:
        value = "Tỵ";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Kỷ $value";
            break;
          case "Ất":
          case "Canh":
            value = "Tân $value";
            break;
          case "Bính":
          case "Tân":
            value = "Quý $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Ất $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Đinh $value";
            break;
          default:
            value = "none";
        }
        break;
      case 5:
        value = "Ngọ";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Canh $value";
            break;
          case "Ất":
          case "Canh":
            value = "Nhâm $value";
            break;
          case "Bính":
          case "Tân":
            value = "Giáp $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Bính $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Mậu $value";
            break;
          default:
            value = "none";
        }
        break;
      case 6:
        value = "Mùi";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Tân $value";
            break;
          case "Ất":
          case "Canh":
            value = "Quý $value";
            break;
          case "Bính":
          case "Tân":
            value = "Ất $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Đinh $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Kỷ $value";
            break;
          default:
            value = "none";
        }
        break;
      case 7:
        value = "Thân";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Nhâm $value";
            break;
          case "Ất":
          case "Canh":
            value = "Giáp $value";
            break;
          case "Bính":
          case "Tân":
            value = "Bính $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Mậu $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Canh $value";
            break;
          default:
            value = "none";
        }
        break;
      case 8:
        value = "Dậu";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Quý $value";
            break;
          case "Ất":
          case "Canh":
            value = "Ất $value";
            break;
          case "Bính":
          case "Tân":
            value = "Đinh $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "kỷ $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Tân $value";
            break;
          default:
            value = "none";
        }
        break;
      case 9:
        value = "Tuất";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Giáp $value";
            break;
          case "Ất":
          case "Canh":
            value = "Bính $value";
            break;
          case "Bính":
          case "Tân":
            value = "Mậu $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Canh $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Nhâm $value";
            break;
          default:
            value = "none";
        }
        break;
      case 10:
        value = "Hợi";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Ất $value";
            break;
          case "Ất":
          case "Canh":
            value = "Đinh $value";
            break;
          case "Bính":
          case "Tân":
            value = "Kỷ $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Tân $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Quý $value";
            break;
          default:
            value = "none";
        }
        break;
      case 11:
        value = "Tý";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Bính $value";
            break;
          case "Ất":
          case "Canh":
            value = "Mậu $value";
            break;
          case "Bính":
          case "Tân":
            value = "Canh $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Nhâm $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Giáp $value";
            break;
          default:
            value = "none";
        }
        break;
      case 12:
        value = "Sửu";
        switch (chiYear) {
          case "Giáp":
          case "Kỷ":
            value = "Đinh $value";
            break;
          case "Ất":
          case "Canh":
            value = "Kỷ $value";
            break;
          case "Bính":
          case "Tân":
            value = "Tân $value";
            break;
          case "Đinh":
          case "Nhâm":
            value = "Quý $value";
            break;
          case "Mậu":
          case "Quý":
            value = "Ất $value";
            break;
          default:
            value = "none";
        }
        break;
      default:
    }

    // value = "${getChiYear(year)} $value";
    return value;
  }
}
