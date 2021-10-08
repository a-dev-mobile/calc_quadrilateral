// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:calc_quadrilateral/app/constants/const_number.dart';
import 'package:calc_quadrilateral/app/services/global_serv.dart';
import 'package:calc_quadrilateral/app/shared_components/numpad/key.dart';
import 'package:calc_quadrilateral/app/shared_components/numpad/key_symbol.dart';
import 'package:calc_quadrilateral/app/translations/translate_helper.dart';

import 'package:calc_quadrilateral/app/utils/app_convert.dart';
import 'package:calc_quadrilateral/app/utils/app_utils.dart';
import 'package:calc_quadrilateral/app/utils/app_utils_map.dart';
import 'package:calc_quadrilateral/app/utils/logger.dart';
import 'package:calc_quadrilateral/app/utils/validation_utils.dart';

import 'package:get/get.dart';

enum Trapezoid {
  aSide,
  bSide,
  cSide,
  hHeight,
  aAngle,
  bAngle,
  yAngle,
  empty,
}

class TrapezoidController extends GetxController {
  static TrapezoidController get to => Get.find<TrapezoidController>();

  static const startAngleValue = '0°';
  static const startLengthValue = '0';
  static const ifErrorValue = '0';

  var activeParamMap = <int, Trapezoid>{}.obs;

  var aSide = startLengthValue.obs;
  var bSide = startLengthValue.obs;
  var cSide = startLengthValue.obs;
  var hHeight = startLengthValue.obs;
  var aAngle = startAngleValue.obs;
  var bAngle = startAngleValue.obs;
  var yAngle = startAngleValue.obs;
/////////////////////////////
  double aSideD = 0.0;
  double bSideD = 0.0;
  double cSideD = 0.0;
  double hHeightD = 0.0;
  double aAngleD = 0.0;
  double bAngleD = 0.0;
  double yAngleD = 0.0;
/////////////////////////////
  var area = "".obs;
  var perimeter = "".obs;
  var xSPoint = "".obs;
  var ySPoint = "".obs;
/////////////////////////////
  double areaD = 0.0;
  double perimeterD = 0.0;
  double xSPointD = 0.0;
  double ySPointD = 0.0;
/////////////////////////////

  var mA = "".obs;
  var mB = "".obs;
  var mC = "".obs;
  double mAd = 0.0;
  double mBd = 0.0;
  double mCd = 0.0;
/////////////////////////////

  var lA = "".obs;
  var lB = "".obs;
  var lC = "".obs;
  double lAd = 0.0;
  double lBd = 0.0;
  double lCd = 0.0;

  //// Radius of the inscribed circle
  var rInscribed = "".obs;
  var xr = "".obs;
  var yr = "".obs;
  double rd = 0.0;
  double xrd = 0.0;
  double yrd = 0.0;

  var Rcircum = "".obs;
  var xR = "".obs;
  var yR = "".obs;
  double Rd = 0.0;
  double xRd = 0.0;
  double yRd = 0.0;

/////////////////////////////

  var isDeg = true.obs;

  var isaAngle = false.obs;
  var isbAngle = false.obs;
  var isyAngle = false.obs;
  var isaSide = false.obs;
  var isbSide = false.obs;
  var iscSide = false.obs;
  var ishHeight = false.obs;

  var isActiveSnackBar = false.obs;
  var messageSnackBar = ''.obs;
  var isActiveImageInfo = false.obs;

  //что  бы не сбрасывать в методе
  var paramLastLenght = Trapezoid.empty;

  late int precisionResult;

  String message = "";
  bool isNotFormula = false;

  @override
  void onInit() {
    clearAll();
    showMessage();
    super.onInit();
  }

  void clickKey(KeySymbol keySymbol) {
    precisionResult = GlobalServ.to.precisionResult.value;

    log.w('start click ${keySymbol.value}');
    printElements();

    if (keySymbol == Keys.next) {
      nextElement();
      showMessage();
      return;
    }

    if (keySymbol == Keys.prev) {
      prevElement();
      showMessage();

      return;
    }

    //если нажалти на конвертацию
    if (keySymbol == Keys.deg || keySymbol == Keys.degMinSec) {
      clickConvertDeg();
      return;
    }

    //если у нас углы в минутах при нажатие любой кнопки далее очищаем ввод
    if (isDeg.isFalse) {
      resetAllValue();
      return;
    }
    if (keySymbol == Keys.clearAll) {
      clearAll();
      showMessage();
      return;
    }

    if (keySymbol == Keys.backspace) {
      backspace();
      setActiveParam();
      initValue();
      calculate();
      showMessage();

      return;
    }

    if (ifMaxNumberEnter()) {
      showSnack(TranslateHelper.message_max_number_entered);
      return;
    }

    // если две точки возврат
    if (isTwoDecimalPointRightquadrilateral(keySymbol)) {
      log.e('isTwoDecimalPointRightquadrilateral');

      return;
    }
    if (isAngleOver180(keySymbol)) {
      log.e('isAngleOver180');
      showSnack(TranslateHelper.messageAngleOver180);
      return;
    }

    String newInput = keySymbol.value;
    String oldInput;
    String sumInput;
    log.v('start input');
    if (isaSide.value) {
      oldInput = aSide.value;

      // при вводе удаляю стартовый символ
      oldInput == startLengthValue ? oldInput = '' : oldInput = oldInput;

      sumInput = oldInput + newInput;
      sumInput = AppUtilsString.addZeroIsFirstDecimal(sumInput);

      aSide.value = sumInput;
    } else if (isbSide.value) {
      oldInput = bSide.value;

      // при вводе удаляю стартовый символ
      oldInput == startLengthValue ? oldInput = '' : oldInput = oldInput;

      sumInput = oldInput + newInput;
      sumInput = AppUtilsString.addZeroIsFirstDecimal(sumInput);

      bSide.value = sumInput;
    } else if (iscSide.value) {
      oldInput = cSide.value;

      // при вводе удаляю стартовый символ
      oldInput == startLengthValue ? oldInput = '' : oldInput = oldInput;

      sumInput = oldInput + newInput;
      sumInput = AppUtilsString.addZeroIsFirstDecimal(sumInput);

      cSide.value = sumInput;
    } else if (ishHeight.value) {
      oldInput = hHeight.value;
      // при вводе удаляю стартовый символ
      oldInput == startLengthValue ? oldInput = '' : oldInput = oldInput;

      sumInput = oldInput + newInput;
      sumInput = AppUtilsString.addZeroIsFirstDecimal(sumInput);

      hHeight.value = sumInput;
    } else if (isaAngle.value) {
      oldInput = aAngle.value;

      // удаляю знак угла
      oldInput = AppUtilsString.removeLastCharacter(oldInput);

      oldInput == startLengthValue ? oldInput = '' : oldInput = oldInput;
      sumInput = oldInput + newInput;

      // если начинается ввод с точки
      sumInput = AppUtilsString.addZeroIsFirstDecimal(sumInput);

      aAngle.value = sumInput + "°";
    } else if (isbAngle.value) {
      oldInput = bAngle.value;

      // удаляю знак угла
      oldInput = AppUtilsString.removeLastCharacter(oldInput);
      //удаляю начальное значение при вводе
      oldInput == startLengthValue ? oldInput = '' : oldInput = oldInput;
      sumInput = oldInput + newInput;

      sumInput = AppUtilsString.addZeroIsFirstDecimal(sumInput);

      bAngle.value = sumInput + "°";
    } else if (isyAngle.value) {
      oldInput = yAngle.value;

      // удаляю знак угла
      oldInput = AppUtilsString.removeLastCharacter(oldInput);
      //удаляю начальное значение при вводе
      oldInput == startLengthValue ? oldInput = '' : oldInput = oldInput;
      sumInput = oldInput + newInput;

      sumInput = AppUtilsString.addZeroIsFirstDecimal(sumInput);

      yAngle.value = sumInput + "°";
    }

    log.v('end input');
    // setActiveParam();
    // showMessage();

    // if (isActiveOneParamEmpty()) return;

    setActiveParam();
    log.v(
        '1 ${activeParamMap[1]} 2 ${activeParamMap[2]} 3 ${activeParamMap[3]} click end active param');

    initValue();
    calculate();
    showMessage();

    printElements();
    log.w('end click ${keySymbol.value}');
  }

  void printElements() {
    log.v('''printElements
        ${activeParamMap[1]} ${activeParamMap[2]} ${activeParamMap[3]}

        $aSideD | ${aSide.value} aSide 
        $bSideD | ${bSide.value} bSide 
        $cSideD | ${cSide.value} cSide 
        $hHeightD | ${hHeight.value} Height
        $aAngleD | ${aAngle.value} aAngle 
        $bAngleD | ${bAngle.value} bAngle
        $yAngleD | ${yAngle.value} yAngle
       ''');
  }

  bool isTwoDecimalPointRightquadrilateral(KeySymbol keySymbol) {
    if (isaSide.value) {
      if (ValidationUtils.isTwoDecimalPoint(aSide.value + keySymbol.value)) {
        return true;
      }
    } else if (isbSide.value) {
      if (ValidationUtils.isTwoDecimalPoint(bSide.value + keySymbol.value)) {
        return true;
      }
    } else if (iscSide.value) {
      if (ValidationUtils.isTwoDecimalPoint(cSide.value + keySymbol.value)) {
        return true;
      }
    } else if (ishHeight.value) {
      if (ValidationUtils.isTwoDecimalPoint(hHeight.value + keySymbol.value)) {
        return true;
      }
    } else if (isaAngle.value) {
      if (ValidationUtils.isTwoDecimalPoint(aAngle.value + keySymbol.value)) {
        return true;
      }
    } else if (isbAngle.value) {
      if (ValidationUtils.isTwoDecimalPoint(bAngle.value + keySymbol.value)) {
        return true;
      }
    } else if (isyAngle.value) {
      if (ValidationUtils.isTwoDecimalPoint(yAngle.value + keySymbol.value)) {
        return true;
      }
    }
    return false;
  }

  void resetActiveParams() {
    activeParamMap.value = <int, Trapezoid>{
      1: Trapezoid.empty,
      2: Trapezoid.empty,
      3: Trapezoid.empty,
    };
  }

  void resetActiveInput() {
//начальное значение при запуске
    isaSide.value = true;
    isbSide.value = false;
    iscSide.value = false;
    ishHeight.value = false;

    isaAngle.value = false;
    isbAngle.value = false;
    isyAngle.value = false;
  }

  void initValue() {
    log.w('start initValue');

    if (isDeg.isFalse) {
      convertDMSToDeg();
    }

    // if (isValueChange()) {
    try {
      if (activeParamMap.containsValue(Trapezoid.aSide)) {
        aSideD = double.parse(aSide.value);
      }
      if (activeParamMap.containsValue(Trapezoid.bSide)) {
        bSideD = double.parse(bSide.value);
      }
      if (activeParamMap.containsValue(Trapezoid.cSide)) {
        cSideD = double.parse(cSide.value);
      }

      if (activeParamMap.containsValue(Trapezoid.hHeight)) {
        hHeightD = double.parse(hHeight.value);
      }

      if (activeParamMap.containsValue(Trapezoid.aAngle)) {
        aAngleD =
            double.parse(AppUtilsString.removeLastCharacter(aAngle.value));
      }

      if (activeParamMap.containsValue(Trapezoid.bAngle)) {
        bAngleD =
            double.parse(AppUtilsString.removeLastCharacter(bAngle.value));
      }

      if (activeParamMap.containsValue(Trapezoid.yAngle)) {
        yAngleD =
            double.parse(AppUtilsString.removeLastCharacter(yAngle.value));
      }
    } catch (e) {
      log.e('initValue error to double');
      resetAllValue();
      resetActiveParams();
    }
    // }
  }

  void calcYangKnowAangBang() {
    yAngleD = 180 - aAngleD - bAngleD;

    yAngle.value =
        AppUtilsNumber.getFormatNumber(yAngleD, precisionResult) + "°";
  }

  void calcAangKnowYangBang() {
    aAngleD = 180 - yAngleD - bAngleD;

    aAngle.value =
        AppUtilsNumber.getFormatNumber(aAngleD, precisionResult) + "°";
  }

  void calcBangKnowYangAang() {
    bAngleD = 180 - yAngleD - aAngleD;

    bAngle.value =
        AppUtilsNumber.getFormatNumber(bAngleD, precisionResult) + "°";
  }

  void calcHheiKnowCsideAang() {
    hHeightD = cSideD * sin(AppConvert.toRadian(aAngleD));
    hHeight.value = AppUtilsNumber.getFormatNumber(hHeightD, precisionResult);
  }

  void calcHheiKnowBsideBang() {
    hHeightD = bSideD * sin(AppConvert.toRadian(bAngleD));
    hHeight.value = AppUtilsNumber.getFormatNumber(hHeightD, precisionResult);
  }

  void calcBangKnowAsideBSideCside() {
    bAngleD = AppConvert.toDegree(acos(
        (pow(aSideD, 2) + pow(bSideD, 2) - pow(cSideD, 2)) /
            (2 * aSideD * bSideD)));
    bAngle.value = AppUtilsNumber.getFormatNumber(bAngleD, precisionResult);
  }

  void calcYangKnowAsideBsideCside() {
    yAngleD = AppConvert.toDegree(acos(
        (pow(bSideD, 2) + pow(cSideD, 2) - pow(aSideD, 2)) /
            (2 * cSideD * bSideD)));
    yAngle.value = AppUtilsNumber.getFormatNumber(yAngleD, precisionResult);
  }

  void calcAangKnowAsideBSideCside() {
    aAngleD = AppConvert.toDegree(acos(
        (pow(aSideD, 2) + pow(cSideD, 2) - pow(bSideD, 2)) /
            (2 * aSideD * cSideD)));
    aAngle.value = AppUtilsNumber.getFormatNumber(aAngleD, precisionResult);
  }

  void calcCsideKnowAsideBSideBang() {
    cSideD = sqrt(pow(aSideD, 2) +
        pow(bSideD, 2) -
        2 * aSideD * bSideD * cos(AppConvert.toRadian(bAngleD)));

    cSide.value = AppUtilsNumber.getFormatNumber(cSideD, precisionResult);
  }

  void calcBsideKnowAsideCSideAang() {
    bSideD = sqrt(pow(aSideD, 2) +
        pow(cSideD, 2) -
        2 * aSideD * cSideD * cos(AppConvert.toRadian(aAngleD)));

    bSide.value = AppUtilsNumber.getFormatNumber(bSideD, precisionResult);
  }

  void calcAsideKnowBsideCSideYang() {
    aSideD = sqrt(pow(bSideD, 2) +
        pow(cSideD, 2) -
        2 * bSideD * cSideD * cos(AppConvert.toRadian(yAngleD)));

    aSide.value = AppUtilsNumber.getFormatNumber(aSideD, precisionResult);
  }

  void calcCsideKnowAsideYangBang() {
    cSideD = (aSideD * sin(AppConvert.toRadian(bAngleD))) /
        sin(AppConvert.toRadian(yAngleD));
    cSide.value = AppUtilsNumber.getFormatNumber(cSideD, precisionResult);
  }

  void calcAreaKnowAsideHhei() {
    areaD = 0.5 * aSideD * hHeightD;
    area.value = AppUtilsNumber.getFormatNumber(areaD, precisionResult);
  }

  void calcPerimKnowAsideBsideCside() {
    perimeterD = aSideD + bSideD + cSideD;

    perimeter.value =
        AppUtilsNumber.getFormatNumber(perimeterD, precisionResult);
  }

  void calcXsPointKnowAsideCsideAang() {
    xSPointD = (aSideD + cSideD * cos(AppConvert.toRadian(aAngleD))) / 3;

    xSPoint.value = AppUtilsNumber.getFormatNumber(xSPointD, precisionResult);
  }

  void calcYsPointKnowCsideAang() {
    ySPointD = cSideD * sin(AppConvert.toRadian(aAngleD)) / 3;
    ySPoint.value = AppUtilsNumber.getFormatNumber(ySPointD, precisionResult);
  }

  void calcBangKnowHheiBside() {
    bAngleD = AppConvert.toDegree(asin(hHeightD / bSideD));
    bAngle.value =
        AppUtilsNumber.getFormatNumber(bAngleD, precisionResult) + "°";
  }

  void calcBSideKnowBangHhei() {
    bSideD = hHeightD / sin(AppConvert.toRadian(bAngleD));
    bSide.value = AppUtilsNumber.getFormatNumber(bSideD, precisionResult);
  }

  void calcYangKnowAsideBsideAang() {
    yAngleD = AppConvert.toDegree(
        asin(aSideD * sin(AppConvert.toRadian(aAngleD)) / bSideD));
    yAngle.value =
        AppUtilsNumber.getFormatNumber(yAngleD, precisionResult) + "°";
  }

  void calcYangKnowAsideCsideBang() {
    yAngleD = AppConvert.toDegree(
        asin(aSideD * sin(AppConvert.toRadian(bAngleD)) / cSideD));
    yAngle.value =
        AppUtilsNumber.getFormatNumber(yAngleD, precisionResult) + "°";
  }

  void calcBangKnowAsideCsideYang() {
    bAngleD = AppConvert.toDegree(
        (asin(cSideD * sin(AppConvert.toRadian(yAngleD)) / aSideD)));
    bAngle.value =
        AppUtilsNumber.getFormatNumber(bAngleD, precisionResult) + "°";
  }

  void calcAangKnowAsideBsideYang() {
    aAngleD = AppConvert.toDegree(
        asin(bSideD * sin(AppConvert.toRadian(yAngleD)) / aSideD));
    aAngle.value =
        AppUtilsNumber.getFormatNumber(aAngleD, precisionResult) + "°";
  }

  void calcBangKnowCsideBsideAang() {
    bAngleD = AppConvert.toDegree(
        asin(cSideD * sin(AppConvert.toRadian(aAngleD)) / bSideD));
    bAngle.value =
        AppUtilsNumber.getFormatNumber(bAngleD, precisionResult) + "°";
  }

  void calcAangKnowCsideBsideBang() {
    aAngleD = AppConvert.toDegree(
        asin(bSideD * sin(AppConvert.toRadian(bAngleD)) / cSideD));
    aAngle.value =
        AppUtilsNumber.getFormatNumber(aAngleD, precisionResult) + "°";
  }

  void calcCsideKnowBsideAangBang() {
    cSideD = (bSideD *
        sin(AppConvert.toRadian(bAngleD)) /
        sin(AppConvert.toRadian(aAngleD)));
    cSide.value = AppUtilsNumber.getFormatNumber(cSideD, precisionResult);
  }

  void calcAsideKnowBsideAangYang() {
    aSideD = (bSideD *
        sin(AppConvert.toRadian(yAngleD)) /
        sin(AppConvert.toRadian(aAngleD)));
    aSide.value = AppUtilsNumber.getFormatNumber(aSideD, precisionResult);
  }

  void calcAsideKnowCsideBangYang() {
    aSideD = (cSideD *
        sin(AppConvert.toRadian(yAngleD)) /
        sin(AppConvert.toRadian(bAngleD)));
    aSide.value = AppUtilsNumber.getFormatNumber(aSideD, precisionResult);
  }

  void calcCsideKnowHheiAang() {
    cSideD = hHeightD / (sin(AppConvert.toRadian(aAngleD)));
    cSide.value = AppUtilsNumber.getFormatNumber(cSideD, precisionResult);
  }

  void calcAanglKnowCsideHhei() {
    aAngleD = AppConvert.toDegree(asin(hHeightD / cSideD));

    aAngle.value =
        AppUtilsNumber.getFormatNumber(aAngleD, precisionResult) + "°";
  }

  void calcSubResultKnowAsideBsideCsideAangl() async {
    calcMedianKnowAsideBsideCside();
    calcBisectorKnowAsideBsideCside();
    //внут круг
    calcRIncenterKnowAsideBsideCside();
    //внеш круг
    calcRCircumCenterKnowAsideBsideCside();
    calcXSRCircumCenterKnowAside();
    calcYSrIncenter();
    //last
    calcXSrIncenterKnowAsideAanglBangl();
    calcYSRCircumCenterKnowRradAside();
  }

  void calcMedianKnowAsideBsideCside() {
    mAd =
        0.5 * (sqrt(2 * pow(cSideD, 2) + 2 * pow(bSideD, 2) - pow(aSideD, 2)));
    mBd =
        0.5 * (sqrt(2 * pow(cSideD, 2) + 2 * pow(aSideD, 2) - pow(bSideD, 2)));
    mCd =
        0.5 * (sqrt(2 * pow(aSideD, 2) + 2 * pow(bSideD, 2) - pow(cSideD, 2)));

    mA.value = AppUtilsNumber.getFormatNumber(mAd, precisionResult);
    mB.value = AppUtilsNumber.getFormatNumber(mBd, precisionResult);
    mC.value = AppUtilsNumber.getFormatNumber(mCd, precisionResult);
  }

  void calcBisectorKnowAsideBsideCside() {
    lBd = (sqrt(aSideD *
            bSideD *
            (cSideD + bSideD + aSideD) *
            (aSideD + bSideD - cSideD))) /
        (aSideD + bSideD);
    lCd = (sqrt(cSideD *
            aSideD *
            (cSideD + bSideD + aSideD) *
            (cSideD + aSideD - bSideD))) /
        (cSideD + aSideD);
    lAd = (sqrt(cSideD *
            bSideD *
            (cSideD + bSideD + aSideD) *
            (cSideD + bSideD - aSideD))) /
        (cSideD + bSideD);
    lA.value = AppUtilsNumber.getFormatNumber(lAd, precisionResult);
    lB.value = AppUtilsNumber.getFormatNumber(lBd, precisionResult);
    lC.value = AppUtilsNumber.getFormatNumber(lCd, precisionResult);
  }

  void calcRIncenterKnowAsideBsideCside() {
    double m = 0;

    m = (aSideD + bSideD + cSideD) / 2;

    rd = sqrt(((m - aSideD) * (m - bSideD) * (m - cSideD)) / m);

    rInscribed.value = AppUtilsNumber.getFormatNumber(rd, precisionResult);
  }

  void calcRCircumCenterKnowAsideBsideCside() {
    // Rd = bSideD / 2 * (sin(AppConvert.toRadian(aAngleD)));
    Rd = (aSideD * bSideD * cSideD) / (4 * areaD);
    Rcircum.value = AppUtilsNumber.getFormatNumber(Rd, precisionResult);
  }

  void calcYSrIncenter() {
    yr.value = rInscribed.value;
  }

  void calcXSRCircumCenterKnowAside() {
    xRd = aSideD / 2;
    xR.value = AppUtilsNumber.getFormatNumber(xRd, precisionResult);
  }

  void calcXSrIncenterKnowAsideAanglBangl() {
    xrd = (tan(AppConvert.toRadian(bAngleD / 2))) *
        aSideD /
        (tan(AppConvert.toRadian(aAngleD / 2)) +
            tan(AppConvert.toRadian(bAngleD / 2)));

    xr.value = AppUtilsNumber.getFormatNumber(xrd, precisionResult);
  }

  void calcYSRCircumCenterKnowRradAside() {
    yRd = sqrt(pow(Rd, 2) - (pow(aSideD, 2) / 4));

    yR.value = AppUtilsNumber.getFormatNumber(yRd, precisionResult);
  }

  void calculate() {
    if (isOnlyTwoParamEmpty()) return;
    log.i('start calculate');
    printElements();
    Trapezoid param1;
    Trapezoid param2;
    Trapezoid param3;

    // ==========================================
    // aAngle bAngle == ok
    // ==========================================
    param1 = Trapezoid.aAngle;
    param2 = Trapezoid.bAngle;
    if (isAvailableTwoParams(param1, param2)) {
      calcYangKnowAangBang();
    }

    // ==========================================
    // yAngle bAngle == ok
    // ==========================================
    param1 = Trapezoid.yAngle;
    param2 = Trapezoid.bAngle;
    if (isAvailableTwoParams(param1, param2)) {
      calcAangKnowYangBang();
    }

    // ==========================================
    // yAngle bAngle == ok
    // ==========================================
    param1 = Trapezoid.yAngle;
    param2 = Trapezoid.aAngle;
    if (isAvailableTwoParams(param1, param2)) {
      calcBangKnowYangAang();
    }

    // ==========================================
    //  //aSide bSide cSide == ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.cSide;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBangKnowAsideBSideCside();
      calcAangKnowAsideBSideCside();
      calcYangKnowAsideBsideCside();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

// ==========================================
    //  //aSide bSide hHeight = ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.hHeight;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBangKnowHheiBside();
      calcCsideKnowAsideBSideBang();
      calcAangKnowAsideBSideCside();
      calcYangKnowAangBang();
      calcPerimKnowAsideBsideCside();

      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    // //aSide bSide aAngle ==ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.aAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcYangKnowAsideBsideAang();
      calcBangKnowYangAang();
      calcCsideKnowAsideBSideBang();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //  // //aSide bSide bAngle==ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.bAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcCsideKnowAsideBSideBang();
      calcAangKnowAsideBSideCside();
      calcYangKnowAsideBsideCside();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //aSide bSide yAngle == ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAangKnowAsideBsideYang();

      calcBangKnowYangAang();

      calcCsideKnowAsideBSideBang();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //  // ////aSide cSide aAngle = ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.cSide;
    param3 = Trapezoid.aAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBsideKnowAsideCSideAang();
      calcBangKnowAsideBSideCside();
      calcYangKnowAsideBsideCside();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    // //aSide cSide bAngle == ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.cSide;
    param3 = Trapezoid.bAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcYangKnowAsideCsideBang();
      calcAangKnowYangBang();
      calcBsideKnowAsideCSideAang();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //aSide cSide yAngle ==ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.cSide;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBangKnowAsideCsideYang();
      calcAangKnowYangBang();
      calcBsideKnowAsideCSideAang();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //  //aSide aAngle bAngle ==ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.aAngle;
    param3 = Trapezoid.bAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcYangKnowAangBang();
      calcCsideKnowAsideYangBang();
      calcBsideKnowAsideCSideAang();

      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //  //aSide aAngle yAngle ==ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.aAngle;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBangKnowYangAang();
      calcCsideKnowAsideYangBang();
      calcBsideKnowAsideCSideAang();

      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //  //aSide bAngle yAngle ==ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bAngle;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAangKnowYangBang();

      calcCsideKnowAsideYangBang();
      calcBsideKnowAsideCSideAang();

      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //bSide cSide aAngle == ok
    // ==========================================
    param1 = Trapezoid.bSide;
    param2 = Trapezoid.cSide;
    param3 = Trapezoid.aAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBangKnowCsideBsideAang();
      calcBangKnowCsideBsideAang();

      calcYangKnowAangBang();

      calcAsideKnowBsideCSideYang();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //bSide cSide bAngle = ok
    // ==========================================
    param1 = Trapezoid.bSide;
    param2 = Trapezoid.cSide;
    param3 = Trapezoid.bAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAangKnowCsideBsideBang();
      calcYangKnowAangBang();
      calcAsideKnowBsideCSideYang();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //  // bSide cSide yAngle ==ok
    // ==========================================
    param1 = Trapezoid.bSide;
    param2 = Trapezoid.cSide;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAsideKnowBsideCSideYang();
      calcBangKnowAsideBSideCside();
      calcAangKnowAsideBSideCside();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //bSide aAngle bAngle == ok
    // ==========================================
    param1 = Trapezoid.bSide;
    param2 = Trapezoid.aAngle;
    param3 = Trapezoid.bAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcYangKnowAangBang();
      calcCsideKnowBsideAangBang();
      calcAsideKnowBsideAangYang();

      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //bSide aAngle yAngle ==ok
    // ==========================================
    param1 = Trapezoid.bSide;
    param2 = Trapezoid.aAngle;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBangKnowYangAang();
      calcCsideKnowBsideAangBang();
      calcAsideKnowBsideAangYang();

      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //bSide bAngle yAngle = ok
    // ==========================================
    param1 = Trapezoid.bSide;
    param2 = Trapezoid.bAngle;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAangKnowYangBang();
      calcCsideKnowBsideAangBang();
      calcAsideKnowBsideAangYang();

      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //cSide aAngle bAngle ==ok
    // ==========================================
    param1 = Trapezoid.cSide;
    param2 = Trapezoid.bAngle;
    param3 = Trapezoid.aAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcYangKnowAangBang();
      calcAsideKnowCsideBangYang();
      calcBsideKnowAsideCSideAang();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();

      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //cSide aAngle yAngle ==ok
    // ==========================================
    param1 = Trapezoid.cSide;
    param2 = Trapezoid.aAngle;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBangKnowYangAang();
      calcAsideKnowCsideBangYang();
      calcBsideKnowAsideCSideAang();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //cSide bAngle yAngle ==ok
    // ==========================================
    param1 = Trapezoid.cSide;
    param2 = Trapezoid.bAngle;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAangKnowYangBang();
      calcAsideKnowCsideBangYang();
      calcBsideKnowAsideCSideAang();
      calcPerimKnowAsideBsideCside();
      calcHheiKnowBsideBang();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //hHeight aAngle bAngle = ok
    // ==========================================
    param1 = Trapezoid.hHeight;
    param2 = Trapezoid.aAngle;
    param3 = Trapezoid.bAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAangKnowYangBang();
      calcCsideKnowHheiAang();
      calcAsideKnowCsideBangYang();
      calcBsideKnowAsideCSideAang();

      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //hHeight aAngle yAngle ==ok
    // ==========================================
    param1 = Trapezoid.hHeight;
    param2 = Trapezoid.aAngle;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBangKnowYangAang();
      calcCsideKnowHheiAang();
      calcAsideKnowCsideBangYang();
      calcBsideKnowAsideCSideAang();

      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //hHeight bAngle yAngle ==ok
    // ==========================================
    param1 = Trapezoid.hHeight;
    param2 = Trapezoid.bAngle;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAangKnowYangBang();
      calcCsideKnowHheiAang();
      calcAsideKnowCsideBangYang();
      calcBsideKnowAsideCSideAang();

      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //bSide hHeight aAngle ==ok
    // ==========================================
    param1 = Trapezoid.hHeight;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.aAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcCsideKnowHheiAang();
      calcBangKnowCsideBsideAang();
      calcYangKnowAangBang();
      calcAsideKnowBsideAangYang();
      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //bSide hHeight yAngle ==ok
    // ==========================================
    param1 = Trapezoid.hHeight;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBangKnowHheiBside();
      calcAangKnowYangBang();
      calcCsideKnowHheiAang();
      calcAsideKnowBsideAangYang();

      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //aSide hHeight aAngle ==ok
    // ==========================================
    param1 = Trapezoid.hHeight;
    param2 = Trapezoid.aSide;
    param3 = Trapezoid.aAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcCsideKnowHheiAang();
      calcBsideKnowAsideCSideAang();
      calcBangKnowCsideBsideAang();
      calcYangKnowAangBang();

      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //aSide cSide hHeight ==ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.cSide;
    param3 = Trapezoid.hHeight;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAanglKnowCsideHhei();
      calcBsideKnowAsideCSideAang();
      calcYangKnowAsideBsideAang();
      calcBangKnowYangAang();

      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
      // isNotFormula = true;
    }

    // ==========================================
//cSide hHeight bAngle == ok
    // ==========================================
    param1 = Trapezoid.bAngle;
    param2 = Trapezoid.cSide;
    param3 = Trapezoid.hHeight;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAanglKnowCsideHhei();
      calcYangKnowAangBang();
      calcAsideKnowCsideBangYang();
      calcBsideKnowAsideCSideAang();
      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
//cSide hHeight yAngle == ok
    // ==========================================
    param1 = Trapezoid.cSide;
    param2 = Trapezoid.hHeight;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcAanglKnowCsideHhei();
      calcBangKnowYangAang();
      calcAsideKnowCsideBangYang();

      calcBsideKnowAsideCSideAang();
      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================s
    //aSide hHeight bAngle ==ok
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.hHeight;
    param3 = Trapezoid.bAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBSideKnowBangHhei();
      calcCsideKnowAsideBSideBang();
      calcAangKnowAsideBSideCside();
      calcYangKnowAangBang();

      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //bSide cSide hHeight ==ok
    // ==========================================
    param1 = Trapezoid.bSide;
    param2 = Trapezoid.cSide;
    param3 = Trapezoid.hHeight;
    if (isAvailableThreeParams(param1, param2, param3)) {
      calcBangKnowHheiBside();
      calcAangKnowCsideBsideBang();
      calcYangKnowAangBang();
      calcAsideKnowBsideAangYang();

      calcPerimKnowAsideBsideCside();
      calcAreaKnowAsideHhei();
      calcXsPointKnowAsideCsideAang();
      calcYsPointKnowCsideAang();
      calcSubResultKnowAsideBsideCsideAangl();
    }

    // ==========================================
    //aSide hHeight yAngle
    // ==========================================
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.hHeight;
    param3 = Trapezoid.yAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      isNotFormula = true;
    }

    // ==========================================
    //bSide hHeight bAngle
    // ==========================================
    param1 = Trapezoid.bSide;
    param2 = Trapezoid.hHeight;
    param3 = Trapezoid.bAngle;
    if (isAvailableThreeParams(param1, param2, param3)) {
      isNotFormula = true;
    }

    // ==========================================
//cSide hHeight aAngle
    // ==========================================
    param1 = Trapezoid.cSide;
    param2 = Trapezoid.aAngle;
    param3 = Trapezoid.hHeight;
    if (isAvailableThreeParams(param1, param2, param3)) {
      isNotFormula = true;

      // calcCsideKnowHheiAang();

    }

    isNumberNaN();

    printElements();
    log.i('end calculate');
  }

  bool isNumberNaN() {
    bool isNan = false;
//если углы имеют 180 гр то тоже является ошибкой
    if (aAngleD == 180 || bAngleD == 180 || yAngleD == 180) {
      isNan = true;
    }

    if (ValidationUtils.isNumberNanAndInfinity(aSideD)) {
      aSide.value = startLengthValue;
      isNan = true;
    }
    if (ValidationUtils.isNumberNanAndInfinity(bSideD)) {
      bSide.value = startLengthValue;
      isNan = true;
    }
    if (ValidationUtils.isNumberNanAndInfinity(cSideD)) {
      cSide.value = startLengthValue;
      isNan = true;
    }
    if (ValidationUtils.isNumberNanAndInfinity(hHeightD)) {
      hHeight.value = startLengthValue;
      isNan = true;
    }

    if (ValidationUtils.isNumberNanAndInfinity(aAngleD)) {
      aAngle.value = startAngleValue;
      isNan = true;
    }

    if (ValidationUtils.isNumberNanAndInfinity(bAngleD)) {
      bAngle.value = startAngleValue;
      isNan = true;
    }
    if (ValidationUtils.isNumberNanAndInfinity(yAngleD)) {
      yAngle.value = startAngleValue;
      isNan = true;
    }

    return isNan;
  }

  void moveEmptyValueToStartInParameters() {
    activeParamMap.addAll(AppUtilsMap.moveValue(
            oldMap: activeParamMap,
            moveValue: Trapezoid.empty,
            isPositionStart: true)
        .cast<int, Trapezoid>());
  }

  void moveValueToEndInParameters(var value) {
    activeParamMap.addAll(AppUtilsMap.moveValue(
            oldMap: activeParamMap, moveValue: value, isPositionStart: false)
        .cast<int, Trapezoid>());
  }

// если значение при удалении равно 0 то обнуляем активный параметр
  bool isInputStartValue() {
    bool activeInput;
    String valueActiveInput;

    activeInput = isaSide.value;
    valueActiveInput = aSide.value;
    Trapezoid oldValue;
    var newValue = Trapezoid.empty;

    if (activeInput && valueActiveInput == startLengthValue) {
      oldValue = Trapezoid.aSide;

      activeParamMap.value = AppUtilsMap.updateValues(
              oldMap: activeParamMap, oldValue: oldValue, newValue: newValue)
          .cast<int, Trapezoid>();

      return true;
    }

    activeInput = isbSide.value;
    valueActiveInput = bSide.value;
    if (activeInput && valueActiveInput == startLengthValue) {
      oldValue = Trapezoid.bSide;

      activeParamMap.value = AppUtilsMap.updateValues(
              oldMap: activeParamMap, oldValue: oldValue, newValue: newValue)
          .cast<int, Trapezoid>();

      return true;
    }

    activeInput = iscSide.value;
    valueActiveInput = cSide.value;
    if (activeInput && valueActiveInput == startLengthValue) {
      oldValue = Trapezoid.cSide;

      activeParamMap.value = AppUtilsMap.updateValues(
              oldMap: activeParamMap, oldValue: oldValue, newValue: newValue)
          .cast<int, Trapezoid>();

      return true;
    }

    activeInput = ishHeight.value;
    valueActiveInput = hHeight.value;
    if (activeInput && valueActiveInput == startLengthValue) {
      oldValue = Trapezoid.hHeight;

      activeParamMap.value = AppUtilsMap.updateValues(
              oldMap: activeParamMap, oldValue: oldValue, newValue: newValue)
          .cast<int, Trapezoid>();

      return true;
    }

    activeInput = isaAngle.value;
    valueActiveInput = aAngle.value;
    if (activeInput && valueActiveInput == startAngleValue) {
      oldValue = Trapezoid.aAngle;

      activeParamMap.value = AppUtilsMap.updateValues(
              oldMap: activeParamMap, oldValue: oldValue, newValue: newValue)
          .cast<int, Trapezoid>();

      return true;
    }

    activeInput = isbAngle.value;
    valueActiveInput = bAngle.value;
    if (activeInput && valueActiveInput == startAngleValue) {
      oldValue = Trapezoid.bAngle;

      activeParamMap.value = AppUtilsMap.updateValues(
              oldMap: activeParamMap, oldValue: oldValue, newValue: newValue)
          .cast<int, Trapezoid>();

      return true;
    }

    activeInput = isyAngle.value;
    valueActiveInput = yAngle.value;
    if (activeInput && valueActiveInput == startAngleValue) {
      oldValue = Trapezoid.yAngle;

      activeParamMap.value = AppUtilsMap.updateValues(
              oldMap: activeParamMap, oldValue: oldValue, newValue: newValue)
          .cast<int, Trapezoid>();

      return true;
    }
    return false;
  }

  void setActiveParam() {
    log.v(
        '1 ${activeParamMap[1]} 2 ${activeParamMap[2]} 3 ${activeParamMap[3]} start active param');

    Trapezoid paramActive = Trapezoid.empty;

    if (isInputStartValue()) return;

    if (isaSide.value) {
      paramActive = Trapezoid.aSide;
      paramLastLenght = Trapezoid.aSide;
    } else if (isbSide.value) {
      paramActive = Trapezoid.bSide;
      paramLastLenght = Trapezoid.bSide;
    } else if (iscSide.value) {
      paramActive = Trapezoid.cSide;
      paramLastLenght = Trapezoid.cSide;
    } else if (ishHeight.value) {
      paramActive = Trapezoid.hHeight;
      paramLastLenght = Trapezoid.hHeight;
    } else if (isaAngle.value) {
      paramActive = Trapezoid.aAngle;
    } else if (isbAngle.value) {
      paramActive = Trapezoid.bAngle;
    } else if (isyAngle.value) {
      paramActive = Trapezoid.yAngle;
    }

//если один параметр пустой заменяем его
    // if (isOnlyOneParamEmpty()) {
    //   activeParamMap.value = AppUtilsMap.updateValues(
    //           oldMap: activeParamMap,
    //           oldValue: Trapezoid.empty,
    //           newValue: paramActive)
    //       .cast<int, Trapezoid>();

    //   return;
    // }

    moveEmptyValueToStartInParameters();
    //если уже есть данный параметр переместить его наверх
    if (isAvailableOneParam(paramActive)) {
      moveValueToEndInParameters(paramActive);
      return;
    }

//если последний параметр похож на активный
    if (activeParamMap[3] == paramActive) return;

    if (activeParamMap[3] != Trapezoid.empty) {
      activeParamMap[1] = activeParamMap[2]!;
      activeParamMap[2] = activeParamMap[3]!;
    }

    activeParamMap[3] = paramActive;
  }

  bool isAvailableOneParam(
    Trapezoid param1,
  ) {
    if (activeParamMap.containsValue(param1)) {
      return true;
    }
    return false;
  }

  bool isAvailableTwoParams(
    Trapezoid param1,
    Trapezoid param2,
  ) {
    if (activeParamMap.containsValue(param1) &&
        activeParamMap.containsValue(param2)) {
      return true;
    }
    return false;
  }

  bool isAvailableThreeParams(
    Trapezoid param1,
    Trapezoid param2,
    Trapezoid param3,
  ) {
    if (activeParamMap.containsValue(param1) &&
        activeParamMap.containsValue(param2) &&
        activeParamMap.containsValue(param3)) {
      return true;
    }
    return false;
  }

  void showMessage() {
    double result = 0.0;

    log.w('start showMessage');

    if (isNotFormula) {
      log.w('isNotFormula');
      showSnack(TranslateHelper.messageFormulaNotFound);
      isNotFormula = false;
      return;
    }

    // если активные углы то сбрасываем один выбор до последнй длины
    if (isActiveParamAngles()) {
      showSnack(TranslateHelper.messageEnterAnyLength);
      return;
    }
    // если есть пустой параметр
    if (isOnlyThreeParamEmpty()) {
      showSnack(TranslateHelper.enterThreeParameters);
      return;
    }
    if (isOnlyTwoParamEmpty()) {
      showSnack(TranslateHelper.enterTwoParameters);
      return;
    }
    if (isOnlyOneParamEmpty()) {
      showSnack(TranslateHelper.enterOneParameters);
      return;
    }

    //если активны данные параметры и выбор стороны
    if (isAvailableThreeParams(
      Trapezoid.aSide,
      Trapezoid.bSide,
      Trapezoid.cSide,
    )) {
      if (iscSide.value) {
        result = aSideD + bSideD;
        if (!(cSideD < result)) {
          showSnack(
              '${TranslateHelper.side} c ${TranslateHelper.must_be} < (a+b) = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }

        result = bSideD - aSideD;
        if (!(cSideD > result)) {
          showSnack(
              '${TranslateHelper.side} c ${TranslateHelper.must_be} > (b-a) = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
        result = aSideD - bSideD;
        if (!(cSideD > result)) {
          showSnack(
              '${TranslateHelper.side} c ${TranslateHelper.must_be} > (a-b) = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
      }
      ///////////////////////////////
      if (isaSide.value) {
        result = cSideD - bSideD;
        if (!(aSideD > result)) {
          showSnack(
              '${TranslateHelper.side} a ${TranslateHelper.must_be} > (c-b) = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
        result = bSideD - cSideD;
        if (!(aSideD > result)) {
          showSnack(
              '${TranslateHelper.side} a ${TranslateHelper.must_be} > (b-c) = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
        result = bSideD + cSideD;
        if (!(aSideD < result)) {
          showSnack(
              '${TranslateHelper.side} a ${TranslateHelper.must_be} < (b+c) = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
      }
      ///////////////////////////////
      if (isbSide.value) {
        result = cSideD - aSideD;
        if (!(bSideD > result)) {
          showSnack(
              '${TranslateHelper.side} b ${TranslateHelper.must_be} > (c-a) = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
        result = aSideD - cSideD;
        if (!(bSideD > result)) {
          showSnack(
              '${TranslateHelper.side} b ${TranslateHelper.must_be} > (a-c) = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
        result = aSideD + cSideD;
        if (!(bSideD < result)) {
          showSnack(
              '${TranslateHelper.side} b ${TranslateHelper.must_be} < (a+c) = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
      }
    }
    // если доступны данные параметры неважно с каким углом
    if (isAvailableTwoParams(
      Trapezoid.bSide,
      Trapezoid.hHeight,
    )) {
      if (isbSide.value) {
        result = hHeightD;
        if (!(bSideD > result)) {
          showSnack(
              '${TranslateHelper.side} b ${TranslateHelper.must_be} > h or b > ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
      }
      if (ishHeight.value) {
        result = bSideD;
        if (!(hHeightD < result)) {
          showSnack(
              '${TranslateHelper.height} h ${TranslateHelper.must_be} < b or h < ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
      }
    }

    if (isAvailableTwoParams(
      Trapezoid.cSide,
      Trapezoid.hHeight,
    )) {
      if (iscSide.value) {
        result = hHeightD;
        if (!(cSideD > result)) {
          showSnack(
              '${TranslateHelper.side} c ${TranslateHelper.must_be} > h or c > ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
      }
      if (ishHeight.value) {
        result = cSideD;
        if (!(hHeightD < result)) {
          showSnack(
              '${TranslateHelper.height} h ${TranslateHelper.must_be} < c or h < ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
      }
    }

    if (isNumberNaN()) {
      log.w('isNumberNaN');
      showSnack(TranslateHelper.message_calc_error_chang_value);
      return;
    }

    endSnack();
    // showSnack('OK');
  }

  bool isAngleOver180(KeySymbol keySymbol) {
    String newInput = keySymbol.value;
    initValue();
    double sum = 0;
    if (isaAngle.value) {
      sum = double.parse(
          AppUtilsString.removeLastCharacter(aAngle.value) + newInput);
      if (180 <= sum) {
        return true;
      } else if (180 <= yAngleD + bAngleD) {
        return true;
      }
    } else if (isbAngle.value) {
      sum = double.parse(
          AppUtilsString.removeLastCharacter(bAngle.value) + newInput);
      if (180 <= sum) {
        return true;
      } else if (180 <= yAngleD + aAngleD) {
        return true;
      }
    } else if (isyAngle.value) {
      sum = double.parse(
          AppUtilsString.removeLastCharacter(yAngle.value) + newInput);
      if (180 <= sum) {
        return true;
      } else if (180 <= yAngleD + bAngleD) {
        return true;
      }
    }

    return false;
  }

  bool isActiveParamAngles() {
    bool condition1 = activeParamMap.containsValue(Trapezoid.aAngle);
    bool condition2 = activeParamMap.containsValue(Trapezoid.bAngle);
    bool condition3 = activeParamMap.containsValue(Trapezoid.yAngle);

    if (condition1 && condition2 && condition3) {
      logger.e('isActiveThreeParamAngles');
      return true;
    }

    return false;
  }

  bool isLeatOneParamEmpty() {
    if (activeParamMap.containsValue(Trapezoid.empty)) {
      return true;
    }
    return false;
  }

  bool isOnlyOneParamEmpty() {
    if (activeParamMap[1] == Trapezoid.empty &&
            activeParamMap[2] != Trapezoid.empty &&
            activeParamMap[3] != Trapezoid.empty ||
        activeParamMap[1] != Trapezoid.empty &&
            activeParamMap[2] == Trapezoid.empty &&
            activeParamMap[3] != Trapezoid.empty ||
        activeParamMap[1] != Trapezoid.empty &&
            activeParamMap[2] != Trapezoid.empty &&
            activeParamMap[3] == Trapezoid.empty) {
      return true;
    }
    return false;
  }

  bool isOnlyTwoParamEmpty() {
    if (activeParamMap[1] == Trapezoid.empty &&
            activeParamMap[2] == Trapezoid.empty &&
            activeParamMap[3] != Trapezoid.empty ||
        activeParamMap[1] == Trapezoid.empty &&
            activeParamMap[2] != Trapezoid.empty &&
            activeParamMap[3] == Trapezoid.empty ||
        activeParamMap[1] != Trapezoid.empty &&
            activeParamMap[2] == Trapezoid.empty &&
            activeParamMap[3] == Trapezoid.empty) {
      return true;
    }
    return false;
  }

  bool isOnlyThreeParamEmpty() {
    if (activeParamMap[1] == Trapezoid.empty &&
        activeParamMap[2] == Trapezoid.empty &&
        activeParamMap[3] == Trapezoid.empty) {
      return true;
    }
    return false;
  }

  bool isActiveTwoParamAngles() {
    bool condition1 = activeParamMap.containsValue(Trapezoid.aAngle);
    bool condition2 = activeParamMap.containsValue(Trapezoid.bAngle);
    bool condition3 = activeParamMap.containsValue(Trapezoid.yAngle);

    if (condition1 && condition2) {
      logger.e('isActiveTwoParamAngles');
      return true;
    }

    if (condition1 && condition3) {
      logger.e('isActiveTwoParamAngles');
      return true;
    }

    if (condition2 && condition3) {
      logger.e('isActiveTwoParamAngles');
      return true;
    }
    return false;
  }

  bool isMaxNumberAfterPoint(String value) {
    return ValidationUtils.isMoreAccuracy(
        value, ConstNumber.maxNumberAfterPoint);
  }

  bool isMaxNumberInput(String value) {
    double number = double.parse(value);
    if (number > ConstNumber.maxValueInput) {
      return true;
    }
    return false;
  }

  bool ifMaxNumberEnter() {
    String value;

    if (isaSide.value) {
      value = aSide.value;
      if (isMaxNumberInput(value) || isMaxNumberAfterPoint(value)) {
        return true;
      }
    } else if (isbSide.value) {
      value = bSide.value;
      if (isMaxNumberInput(value) || isMaxNumberAfterPoint(value)) {
        return true;
      }
    } else if (iscSide.value) {
      value = cSide.value;
      if (isMaxNumberInput(value) || isMaxNumberAfterPoint(value)) {
        return true;
      }
    } else if (ishHeight.value) {
      value = hHeight.value;
      if (isMaxNumberInput(value) || isMaxNumberAfterPoint(value)) {
        return true;
      }
    } else if (isaAngle.value) {
      value = AppUtilsString.removeLastCharacter(aAngle.value);
      if (isMaxNumberInput(value) || isMaxNumberAfterPoint(value)) {
        return true;
      }
    } else if (isbAngle.value) {
      value = AppUtilsString.removeLastCharacter(bAngle.value);
      if (isMaxNumberInput(value) || isMaxNumberAfterPoint(value)) {
        return true;
      }
    } else if (isyAngle.value) {
      value = AppUtilsString.removeLastCharacter(yAngle.value);
      if (isMaxNumberInput(value) || isMaxNumberAfterPoint(value)) {
        return true;
      }
    }
    return false;
  }

  void endSnack() {
    isActiveSnackBar.value = false;
  }

  void showSnack(String message) {
    isActiveSnackBar.value = true;
    messageSnackBar.value = message;
  }

  void nextElement() {
    // переключение вперед между widgets backspace

    _isNext(true);
  }

  void restartActiveParamIfZeroValue() {
    if (activeParamMap[1] == Trapezoid.aSide &&
        aSide.value == startLengthValue) {
      activeParamMap[1] = Trapezoid.empty;
    }

    if (activeParamMap[2] == Trapezoid.aSide &&
        aSide.value == startLengthValue) {
      activeParamMap[2] = Trapezoid.empty;
    }
    if (activeParamMap[3] == Trapezoid.aSide &&
        aSide.value == startLengthValue) {
      activeParamMap[3] = Trapezoid.empty;
    }

//===============================================
    if (activeParamMap[1] == Trapezoid.bSide &&
        bSide.value == startLengthValue) {
      activeParamMap[1] = Trapezoid.empty;
    }

    if (activeParamMap[2] == Trapezoid.bSide &&
        bSide.value == startLengthValue) {
      activeParamMap[2] = Trapezoid.empty;
    }
    if (activeParamMap[3] == Trapezoid.bSide &&
        bSide.value == startLengthValue) {
      activeParamMap[3] = Trapezoid.empty;
    }
//===============================================
    if (activeParamMap[1] == Trapezoid.cSide &&
        cSide.value == startLengthValue) {
      activeParamMap[1] = Trapezoid.empty;
    }

    if (activeParamMap[2] == Trapezoid.cSide &&
        cSide.value == startLengthValue) {
      activeParamMap[2] = Trapezoid.empty;
    }
    if (activeParamMap[3] == Trapezoid.cSide &&
        cSide.value == startLengthValue) {
      activeParamMap[3] = Trapezoid.empty;
    }

//===============================================
    if (activeParamMap[1] == Trapezoid.hHeight &&
        hHeight.value == startLengthValue) {
      activeParamMap[1] = Trapezoid.empty;
    }

    if (activeParamMap[2] == Trapezoid.hHeight &&
        hHeight.value == startLengthValue) {
      activeParamMap[2] = Trapezoid.empty;
    }
    if (activeParamMap[3] == Trapezoid.hHeight &&
        hHeight.value == startLengthValue) {
      activeParamMap[3] = Trapezoid.empty;
    }

//===============================================
    if (activeParamMap[1] == Trapezoid.aAngle &&
        aAngle.value == startAngleValue) {
      activeParamMap[1] = Trapezoid.empty;
    }

    if (activeParamMap[2] == Trapezoid.aAngle &&
        aAngle.value == startAngleValue) {
      activeParamMap[2] = Trapezoid.empty;
    }

    if (activeParamMap[3] == Trapezoid.aAngle &&
        aAngle.value == startAngleValue) {
      activeParamMap[3] = Trapezoid.empty;
    }
//===============================================

    if (activeParamMap[1] == Trapezoid.bAngle &&
        bAngle.value == startAngleValue) {
      activeParamMap[1] = Trapezoid.empty;
    }

    if (activeParamMap[2] == Trapezoid.bAngle &&
        bAngle.value == startAngleValue) {
      activeParamMap[2] = Trapezoid.empty;
    }

    if (activeParamMap[3] == Trapezoid.bAngle &&
        bAngle.value == startAngleValue) {
      activeParamMap[3] = Trapezoid.empty;
    }

//===============================================

    if (activeParamMap[1] == Trapezoid.yAngle &&
        yAngle.value == startAngleValue) {
      activeParamMap[1] = Trapezoid.empty;
    }

    if (activeParamMap[2] == Trapezoid.yAngle &&
        yAngle.value == startAngleValue) {
      activeParamMap[2] = Trapezoid.empty;
    }

    if (activeParamMap[3] == Trapezoid.yAngle &&
        yAngle.value == startAngleValue) {
      activeParamMap[3] = Trapezoid.empty;
    }
  }

  void prevElement() {
    // переключение  между widgets

    _isNext(false);
  }

  void convertDMSToDeg() {
    aAngle.value = AppConvert.convertDMStoDeg(aAngle.value, precisionResult);
    bAngle.value = AppConvert.convertDMStoDeg(bAngle.value, precisionResult);
    yAngle.value = AppConvert.convertDMStoDeg(yAngle.value, precisionResult);
  }

  void convertDegToDMS() {
// если мы в минутах то переводим углы
    aAngle.value = AppConvert.convertDegToDMS(aAngleD, precisionResult);
    bAngle.value = AppConvert.convertDegToDMS(bAngleD, precisionResult);
    yAngle.value = AppConvert.convertDegToDMS(yAngleD, precisionResult);
  }

  void clickConvertDeg() {
    isDeg.value = !(isDeg.value);

    isDeg.value ? convertDMSToDeg() : convertDegToDMS();
  }

  void longBackspace() {
// взависимости от активного ввода
    if (isaSide.value) {
      aSide.value = startLengthValue;
    } else if (isbSide.value) {
      bSide.value = startLengthValue;
    } else if (iscSide.value) {
      cSide.value = startLengthValue;
    } else if (ishHeight.value) {
      hHeight.value = startLengthValue;
    } else if (isaAngle.value) {
      aAngle.value = startAngleValue;
    } else if (isbAngle.value) {
      bAngle.value = startAngleValue;
    } else if (isyAngle.value) {
      yAngle.value = startAngleValue;
    }

    initValue();
    setActiveParam();
    log.v(
        '1 ${activeParamMap[1]} 2 ${activeParamMap[2]} 3 ${activeParamMap[3]} longBackspace active param  ');

    calculate();
    showMessage();
    restartActiveParamIfZeroValue();
  }

  void backspace() {
    String oldInput;
    String newInput;

// взависимости от активного ввода
    if (isaSide.value) {
      oldInput = aSide.value;
      newInput = AppUtilsString.removeLastCharacter(oldInput);
      //если пусто устанавливаем стартовое значение
      if (newInput.isEmpty) {
        aSideD = 0;

        newInput = startLengthValue;

        resetNotActiveValue();
      }
      aSide.value = newInput;
    } else if (isbSide.value) {
      oldInput = bSide.value;
      newInput = AppUtilsString.removeLastCharacter(oldInput);
      //если пусто устанавливаем стартовое значение
      if (newInput.isEmpty) {
        bSideD = 0;
        newInput = startLengthValue;
        resetNotActiveValue();
      }
      bSide.value = newInput;
    } else if (iscSide.value) {
      oldInput = cSide.value;
      newInput = AppUtilsString.removeLastCharacter(oldInput);
      //если пусто устанавливаем стартовое значение
      if (newInput.isEmpty) {
        cSideD = 0;
        newInput = startLengthValue;
        resetNotActiveValue();
      }
      cSide.value = newInput;
    } else if (ishHeight.value) {
      oldInput = hHeight.value;
      newInput = AppUtilsString.removeLastCharacter(oldInput);

      if (newInput.isEmpty) {
        hHeightD = 0;
        newInput = startLengthValue;
        resetNotActiveValue();
      }
      hHeight.value = newInput;
    } else if (isaAngle.value) {
      oldInput = aAngle.value;

      if (AppUtilsString.getLastCharacter(oldInput) == '°') {
        oldInput = AppUtilsString.removeLastCharacter(oldInput);
      }
      newInput = AppUtilsString.removeLastCharacter(oldInput);

      if (newInput.isEmpty) {
        aAngleD = 0;
        newInput = startLengthValue;
        resetNotActiveValue();
      }
      aAngle.value = newInput + '°';
    } else if (isbAngle.value) {
      oldInput = bAngle.value;

      if (AppUtilsString.getLastCharacter(oldInput) == '°') {
        oldInput = AppUtilsString.removeLastCharacter(oldInput);
      }
      newInput = AppUtilsString.removeLastCharacter(oldInput);
      if (newInput.isEmpty) {
        bAngleD = 0;
        newInput = startLengthValue;
        resetNotActiveValue();
      }
      bAngle.value = newInput + '°';
    } else if (isyAngle.value) {
      oldInput = yAngle.value;

      if (AppUtilsString.getLastCharacter(oldInput) == '°') {
        oldInput = AppUtilsString.removeLastCharacter(oldInput);
      }
      newInput = AppUtilsString.removeLastCharacter(oldInput);
      if (newInput.isEmpty) {
        yAngleD = 0;
        newInput = startLengthValue;
        resetNotActiveValue();
      }
      yAngle.value = newInput + '°';
    }
  }

  void clearAll() {
    //устанавливаем начальные значения
    log.v(' start clearAll');
    printElements();
    resetAllValue();

    resetActiveInput();
    resetActiveParams();

    printElements();
    log.v(' end clearAll');
  }

  void resetAllValue() {
    //устанавливаем начальные значения
    aSide.value = startLengthValue;
    bSide.value = startLengthValue;
    cSide.value = startLengthValue;

    hHeight.value = startLengthValue;

    aAngle.value = startAngleValue;
    bAngle.value = startAngleValue;
    yAngle.value = startAngleValue;

    perimeter.value = startLengthValue;
    area.value = startLengthValue;

    xSPoint.value = startLengthValue;
    ySPoint.value = startLengthValue;
    aSideD = 0;
    bSideD = 0;
    cSideD = 0;
    hHeightD = 0;

    aAngleD = 0;
    bAngleD = 0;
    yAngleD = 0;

    areaD = 0;
    perimeterD = 0;

    ySPointD = 0;
    xSPointD = 0;

    mA.value = mB.value = mC.value = startLengthValue;
    mAd = mBd = mCd = 0.0;
/////////////////////////////
    lA.value = lB.value = lC.value = startLengthValue;
    lAd = lBd = lCd = 0.0;

    rInscribed.value = xr.value = yr.value = startLengthValue;
    rd = xrd = yrd = 0.0;

    Rcircum.value = xR.value = yR.value = startLengthValue;
    Rd = xRd = yRd = 0.0;

    isDeg.value = true;
  }

  void resetNotActiveValue() {
    areaD = 0;
    perimeterD = 0;
    area.value = startLengthValue;
    perimeter.value = startLengthValue;

    ySPointD = 0;
    xSPointD = 0;
    xSPoint.value = startLengthValue;
    ySPoint.value = startLengthValue;

    mA.value = mB.value = mC.value = startLengthValue;
    mAd = mBd = mCd = 0.0;
/////////////////////////////
    lA.value = lB.value = lC.value = startLengthValue;
    lAd = lBd = lCd = 0.0;

    rInscribed.value = xr.value = yr.value = startLengthValue;
    rd = xrd = yrd = 0.0;

    Rcircum.value = xR.value = yR.value = startLengthValue;
    Rd = xRd = yRd = 0.0;

    if (!isAvailableOneParam(Trapezoid.aSide)) {
      aSide.value = startLengthValue;
      aSideD = 0;
    }
    if (!isAvailableOneParam(Trapezoid.bSide)) {
      bSide.value = startLengthValue;
      bSideD = 0;
    }
    if (!isAvailableOneParam(Trapezoid.cSide)) {
      cSide.value = startLengthValue;
      cSideD = 0;
    }

    if (!isAvailableOneParam(Trapezoid.hHeight)) {
      hHeight.value = startLengthValue;
      hHeightD = 0;
    }
    if (!isAvailableOneParam(Trapezoid.aAngle)) {
      aAngle.value = startAngleValue;
      aAngleD = 0;
    }
    if (!isAvailableOneParam(Trapezoid.bAngle)) {
      bAngle.value = startAngleValue;
      bAngleD = 0;
    }
    if (!isAvailableOneParam(Trapezoid.yAngle)) {
      yAngle.value = startAngleValue;
      yAngleD = 0;
    }
  }

  void _isNext(bool isNext) {
    if (isNext) {
      if (isaSide.value) {
        isbAngle.value = true;
        isaSide.value = false;
      } else if (isbAngle.value) {
        isaAngle.value = true;
        isbAngle.value = false;
      } else if (isaAngle.value) {
        ishHeight.value = true;
        isaAngle.value = false;
      } else if (ishHeight.value) {
        ishHeight.value = false;
        iscSide.value = true;
      } else if (iscSide.value) {
        iscSide.value = false;
        isbSide.value = true;
      } else if (isbSide.value) {
        isyAngle.value = true;
        isbSide.value = false;
      } else if (isyAngle.value) {
        isyAngle.value = false;
        isaSide.value = true;
      }
    } else {
      if (isaSide.value) {
        isyAngle.value = true;
        isaSide.value = false;
      } else if (isyAngle.value) {
        isbSide.value = true;
        isyAngle.value = false;
      } else if (isbSide.value) {
        iscSide.value = true;
        isbSide.value = false;
      } else if (iscSide.value) {
        ishHeight.value = true;
        iscSide.value = false;
      } else if (ishHeight.value) {
        ishHeight.value = false;
        isaAngle.value = true;
      } else if (isaAngle.value) {
        isbAngle.value = true;
        isaAngle.value = false;
      } else if (isbAngle.value) {
        isbAngle.value = false;
        isaSide.value = true;
      }
    }
  }

  @override
  void onClose() {
    clearAll();
    super.onClose();
  }
}
