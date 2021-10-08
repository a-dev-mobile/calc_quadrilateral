import 'package:calc_quadrilateral/app/admob/ad_helper.dart';
import 'package:calc_quadrilateral/app/features/calculate/view/trapezoid/2/trapezoid_main_w.dart';

import 'package:flutter/material.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class CalculateTrapezoidPage extends StatefulWidget {
  const CalculateTrapezoidPage({Key? key}) : super(key: key);

  @override
  _CalculateTrapezoidPageState createState() => _CalculateTrapezoidPageState();
}

class _CalculateTrapezoidPageState extends State<CalculateTrapezoidPage> {
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? SizedBox(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
          : null,
      // body: SafeArea(child: RightquadrilateralInputWidget()),
      body: const SafeArea(child: TrapezoidMain()),
    );
  }
}
