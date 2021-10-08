import 'package:calc_quadrilateral/app/config/theme/app_style.dart';
import 'package:calc_quadrilateral/app/services/global_serv.dart';
import 'package:calc_quadrilateral/app/translations/translate_helper.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingLaunchScreenWidget extends StatelessWidget {
  const SettingLaunchScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SwitchListTile(
        value: GlobalServ.to.isShowLaunchScreen.value,
        onChanged: (val) {
          GlobalServ.to.changeShowLaunchScreen();
        },
        title: Text(
          TranslateHelper.showStartupScreen,
          style: AppStyleText.titleText(context),
        ),
        subtitle: Text(
          GlobalServ.to.isShowLaunchScreen.value
              ? TranslateHelper.yes
              : TranslateHelper.no,
          style: AppStyleText.subText(context),
        ),
      );
    });
  }
}
