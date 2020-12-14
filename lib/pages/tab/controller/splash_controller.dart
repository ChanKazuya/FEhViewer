import 'dart:async';
import 'dart:io';

import 'package:FEhViewer/common/global.dart';
import 'package:FEhViewer/route/navigator_util.dart';
import 'package:FEhViewer/route/routes.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class SplashController extends GetxController {
  StreamSubscription _intentDataStreamSubscription;
  String sharedText;

  @override
  void onInit() {
    super.onInit();
    if (!Platform.isIOS && !Platform.isAndroid) {
      Future<void>.delayed(const Duration(milliseconds: 500), () {
        Get.offNamed(EHRoutes.home);
      });
    } else {
      // For sharing or opening urls/text coming from outside the app while the app is in the memory
      _intentDataStreamSubscription =
          ReceiveSharingIntent.getTextStream().listen((String value) {
        Global.logger.i('value(memory): $value');
        sharedText = value;
        Global.logger.i('Shared: $sharedText');
        startHome(sharedText);
      }, onError: (err) {
        Global.logger.e('getLinkStream error: $err');
      });

      // For sharing or opening urls/text coming from outside the app while the app is closed
      ReceiveSharingIntent.getInitialText().then((String value) {
        Global.logger.i('value(closed): $value');
        sharedText = value;
        Global.logger.i('Shared: $sharedText');
        startHome(sharedText);
      });
    }
  }

  Future<void> startHome(String url) async {
    if (url != null && url.isNotEmpty) {
      Global.logger.i('open $url');
      await Future<void>.delayed(const Duration(milliseconds: 300), () {
        NavigatorUtil.goGalleryDetailReplace(Get.context, url: url);
      });
    } else {
      Global.logger.i('url is Empty,jump to home');
      await Future<void>.delayed(const Duration(milliseconds: 500), () {
        Get.offNamed(EHRoutes.home);
      });
    }
  }
}