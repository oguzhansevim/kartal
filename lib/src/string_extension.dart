import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kartal/src/exception/package_info_exception.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/app_constants.dart';
import 'constants/input_formatter_constants.dart';
import 'constants/regex_constants.dart';
import 'utility/device_utility.dart';

extension StringColorExtension on String {
  Color get color => Color(int.parse('0xff$this'));
}

extension StringValidatorExtension on String {
  bool get isNullOrEmpty => this == null || isEmpty;
  bool get isNotNullOrNoEmpty => this != null && isNotEmpty;

  bool get isValidEmail => RegExp(RegexConstans.instance.emailRegex).hasMatch(this);
}

extension AuthorizationExtension on String {
  Map<String, dynamic> get beraer => {'Authorization': 'Bearer ${this}'};
}

extension LaunchExtension on String {
  Future<bool> get launchEmail => launch('mailto:$this');
  Future<bool> get launchPhone => launch('tel:$this');
  Future<bool> get launchWebsite => launch('$this');
}

extension ShareText on String {
  Future<void> shareWhatsApp() async {
    try {
      final isLaunch = await launch('${KartalAppConstants.WHATS_APP_PREFIX}$this');
      if (!isLaunch) await share();
    } catch (e) {
      await share();
    }
  }

  Future<void> shareMail(String title) async {
    final value = DeviceUtility.instance.shareMailText(title, this);
    final isLaunch = await launch(Uri.encodeFull(value));
    if (!isLaunch) await value.share();
  }

  Future<void> share() async {
    if (Platform.isIOS) {
      final isAppIpad = await DeviceUtility.instance.isIpad();
      if (isAppIpad) await Share.share(this, sharePositionOrigin: DeviceUtility.instance.ipadPaddingBottom);
    }

    await Share.share(this);
  }
}

extension FormatterExtension on String {
  String get phoneFormatValue => InputFormatter.instance.phoneFormatter.unmaskText(this);
  String get timeFormatValue => InputFormatter.instance.timeFormatter.unmaskText(this);
  String get timeOverlineFormatValue => InputFormatter.instance.timeFormatterOverLine.unmaskText(this);
}

extension PackageInfoExtension on String {
  String get appName {
    if (DeviceUtility.instance.packageInfo == null) {
      throw PackageInfoNotFound();
    } else {
      return DeviceUtility.instance.packageInfo.appName;
    }
  }

  String get packageName {
    if (DeviceUtility.instance.packageInfo == null) {
      throw PackageInfoNotFound();
    } else {
      return DeviceUtility.instance.packageInfo.packageName;
    }
  }

  String get version {
    if (DeviceUtility.instance.packageInfo == null) {
      throw PackageInfoNotFound();
    } else {
      return DeviceUtility.instance.packageInfo.version;
    }
  }

  String get buildNumber {
    if (DeviceUtility.instance.packageInfo == null) {
      throw PackageInfoNotFound();
    } else {
      return DeviceUtility.instance.packageInfo.buildNumber;
    }
  }
}
