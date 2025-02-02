import 'dart:developer';

import 'package:calculator/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NetworkServices {
  static Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      log('URL not opened');
      throw 'Could not open $url';
    }
  }

  static Future<void> openPlayStore() async {
    await openUrl(Constants.appUrl);
  }

  static Future<void> openPrivacyPolicy() async {
    await openUrl(Constants.privacyPolicyUrl);
  }
}
