import 'dart:io';

import 'package:calc_quadrilateral/app/constants/const_number.dart';
import 'package:calc_quadrilateral/app/constants/const_string.dart';
import 'package:calc_quadrilateral/app/features/select_shape/select_shape_p.dart';
import 'package:calc_quadrilateral/app/utils/local_torage.dart';
import 'package:calc_quadrilateral/app/utils/logger.dart';

import 'package:get/get.dart';

class GlobalServ extends GetxService {
  static GlobalServ get to => Get.find();

  var isDarkTheme = false.obs;
  var isFirstStartApp = false;
  var appLocale = ConstString.localeEn.obs;
  var isShowLaunchScreen = false.obs;

  //что бы не доставать локально, сохраним в глоб сервисе

  var precisionResult = ConstNumber.defPrecisionResult.obs;
  late Shape aciveShape;
// ========================================

  void setStorageIsDarkTheme(bool isDark) async {
    isDarkTheme.value = isDark;
  }

// ========================================
  void setDefaultLocale() {
    appLocale.value = Platform.localeName == 'ru_RU'
        ? ConstString.localeRu
        : ConstString.localeEn;
  }

  void setStorageLocale(String locale) {
    appLocale.value = locale;
  }

// ========================================
  void setNonFirstStartApp() async {
    isFirstStartApp = false;
  }

// ========================================

  void changeShowLaunchScreen() {
    isShowLaunchScreen.value = !isShowLaunchScreen.value;
  }

  void startIfCloseSetiing() async {
    LocalStorage().setItemBool(ConstString.keyIsShowLaunchScreen,
        GlobalServ.to.isShowLaunchScreen.value);
    LocalStorage()
        .setItemString(ConstString.keyLocaleApp, GlobalServ.to.appLocale.value);
    LocalStorage().setItemBool(
        ConstString.keyIsDarkTheme, GlobalServ.to.isDarkTheme.value);
    LocalStorage().setItemInt(
        ConstString.keyPrecisionResult, GlobalServ.to.precisionResult.value);
  }

  @override
  void onInit() async {
    logger.d('onInit global service');

    bool isNullFirstStartApp =
        await LocalStorage().isNull(ConstString.keyIsFirstStartApp);

    // если первый запуск
    if (isNullFirstStartApp) {
      isFirstStartApp = true;
      isShowLaunchScreen.value = false;
      isDarkTheme.value = false;
      setDefaultLocale();
    } else {
      // устанавливаем если не первый запуск
      isFirstStartApp = false;
      isShowLaunchScreen.value =
          await LocalStorage().getItemBool(ConstString.keyIsShowLaunchScreen);
      appLocale.value =
          await LocalStorage().getItemString(ConstString.keyLocaleApp);
      isDarkTheme.value =
          await LocalStorage().getItemBool(ConstString.keyIsDarkTheme);
      precisionResult.value =
          await LocalStorage().getItemInt(ConstString.keyPrecisionResult);
    }

    super.onInit();
  }
}
