
import 'dart:io';

import 'package:flutter/foundation.dart';

/// [Platforms] is a class that is used to get the platform name and other information.
class Platforms {

  static String injectToUrl(String url) {
    return Uri.parse(url).replace(queryParameters: {
      "platform": platformName,
      "operatingSystem": operatingSystem,
      "operatingSystemVersion": operatingSystemVersion,
    }).toString();
  }

  static String get operatingSystem =>
      !isWeb ? Platform.operatingSystem : "Web";
  static String get operatingSystemVersion =>
      !isWeb ? Platform.operatingSystemVersion : "Web";

  static get isWeb => kIsWeb;

  static get isAndroid => !isWeb && Platform.isAndroid;
  static get isIOS => !isWeb && Platform.isIOS;
  static get isWindows => !isWeb && Platform.isWindows;
  static get isLinux => !isWeb && Platform.isLinux;
  static get isMacOS => !isWeb && Platform.isMacOS;
  static get isFuchsia => !isWeb && Platform.isFuchsia;

  static String get platformName {
    if (isWeb) return "Web";
    if (isAndroid) return "Android";
    if (isIOS) return "IOS";
    if (isWindows) return "Windows";
    if (isLinux) return "Linux";
    if (isMacOS) return "MacOS";
    if (isFuchsia) return "Fuchsia";
    return "Unknown";
  }
}