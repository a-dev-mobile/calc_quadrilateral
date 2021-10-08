import 'package:calc_quadrilateral/app/config/routes/app_page.dart';
import 'package:calc_quadrilateral/app/config/theme/app_color.dart';
import 'package:calc_quadrilateral/app/config/theme/app_size.dart';
import 'package:calc_quadrilateral/app/config/theme/app_style.dart';
import 'package:calc_quadrilateral/app/constants/const_assets.dart';
import 'package:calc_quadrilateral/app/constants/const_number.dart';
import 'package:calc_quadrilateral/app/constants/const_string.dart';

import 'package:calc_quadrilateral/app/services/global_serv.dart';
import 'package:calc_quadrilateral/app/shared_components/app_widgets.dart';
import 'package:calc_quadrilateral/app/shared_components/change_theme_w.dart';
import 'package:calc_quadrilateral/app/shared_components/setting_launch_screen_w.dart';

import 'package:calc_quadrilateral/app/translations/translate_helper.dart';

import 'package:calc_quadrilateral/app/utils/local_torage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: ConstNumber.defaultPadding),
              child: Text(
                TranslateHelper.settingFirstLaunch,
                style: AppStyleText.titleText(context),
              ),
            ),
            SizedBox(
              height: 0.80.sh,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 0.3.sh,
                      child: const ImageAppWidget(),
                    ),
                    // RightquadrilateralImageInfoWidget(),
                    WelcomeAppTitle(
                      fontSize: AppSize.fontSizeHeadline4(context),
                    ),
                    AppWidgets.dividerWelcome(),
                    const ChangeThemeWidget(),
                    AppWidgets.dividerWelcome(),
                    const SliderPrecisionResultWidget(),
                    const SettingLaunchScreenWidget(),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
                width: 0.8.sw, height: 0.05.sh, child: const WelcomeBtnStart()),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class SliderPrecisionResultWidget extends StatelessWidget {
  const SliderPrecisionResultWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String precision = '';
    String title = TranslateHelper.selectedPrecisionResult;
    return Obx(() {
      int precisionResult = GlobalServ.to.precisionResult.value;
      // int precisionResult =  GlobalServ.to.precisionResult.value;
      switch (precisionResult) {
        case 1:
          precision = '0.0';
          break;
        case 2:
          precision = '0.00';
          break;
        case 3:
          precision = '0.000';
          break;
        case 4:
          precision = '0.0000';
          break;
        case 5:
          precision = '0.00000';
          break;
        case 0:

        default:
          precision = '0';
      }
      return Column(
        children: [
          RichText(
            text:
                TextSpan(style: DefaultTextStyle.of(context).style, children: [
              TextSpan(text: title, style: AppStyleText.titleText(context)),
              TextSpan(text: precision, style: AppStyleText.subText(context)),
            ]),
          ),
          Slider(
              value: GlobalServ.to.precisionResult.value.toDouble(),
              min: 0,
              divisions: 5,
              max: 5,
              onChanged: (double value) {
                GlobalServ.to.precisionResult.value = value.toInt();
              }),
        ],
      );
    });
  }
}

class ImageAppWidget extends StatelessWidget {
  const ImageAppWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ConstAssetsImageRaster.rightquadrilateralInfo,
      fit: BoxFit.contain,
      color: AppColors.contentRevers(context),

      // Image.asset(
      //   ConstAssets.scalenequadrilateralInfo,
      //   fit: BoxFit.contain,
      //   color: AppColors.contentRevers(context),
      // ),
    );
  }
}

class WelcomeBtnStart extends StatelessWidget {
  const WelcomeBtnStart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.offAllNamed(Routes.selectShape);

// сохраняем если перый запуск
        if (GlobalServ.to.isFirstStartApp) {
          LocalStorage().setItemBool(ConstString.keyIsFirstStartApp, false);
        }
      },
      child: Text(TranslateHelper.launch, style: AppStyleButton.start(context)),
    );
  }
}

class WelcomeAppTitle extends StatelessWidget {
  const WelcomeAppTitle({
    Key? key,
    required this.fontSize,
  }) : super(key: key);

  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          TranslateHelper.appName,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.text(context),
            letterSpacing: 2.0,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            shadows: Get.isDarkMode == true
                //тень взависимости от темы
                ? <Shadow>[
                    const Shadow(
                      offset: Offset(5.0, 5.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(25, 255, 255, 255),
                    ),
                    const Shadow(
                      offset: Offset(5.0, 5.0),
                      blurRadius: 5.0,
                      color: Color.fromARGB(25, 0, 0, 255),
                    ),
                  ]
                : <Shadow>[
                    const Shadow(
                      offset: Offset(5.0, 5.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(25, 0, 0, 0),
                    ),
                    const Shadow(
                      offset: Offset(5.0, 5.0),
                      blurRadius: 5.0,
                      color: Color.fromARGB(25, 0, 0, 255),
                    ),
                  ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            TranslateHelper.appNameSub,
            textAlign: TextAlign.center,
            style: TextStyle(
                letterSpacing: 1.5,
                color: AppColors.text(context).withOpacity(0.8)),
          ),
        ),
      ],
    );
  }
}
