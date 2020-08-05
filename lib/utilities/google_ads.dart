import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class AdManager {
  static String get appId {
//    return FirebaseAdMob.testAppId;
    return 'ca-app-pub-6276155927126955~6625406579';
  }

  static String get bannerAdUnitId {
//    return BannerAd.testAdUnitId;
    return 'ca-app-pub-6276155927126955/7555344860';
  }

  static String get interstitialAdUnitId {
//    return InterstitialAd.testAdUnitId;
    return 'ca-app-pub-6276155927126955/5777576370';
  }
}

//Banner Ad
class BannerAdPage extends StatefulWidget {
  @override
  _BannerAdPageState createState() => _BannerAdPageState();
}

class _BannerAdPageState extends State<BannerAdPage> {
  BannerAd myBanner;
  String myAdId = AdManager.bannerAdUnitId;

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: myAdId,
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show(anchorType: AnchorType.bottom);
          }
        });
  }

  @override
  void initState() {
    super.initState();

    final String appId = AdManager.appId;

    FirebaseAdMob.instance.initialize(appId: appId);
    myBanner = buildBannerAd()..load();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
