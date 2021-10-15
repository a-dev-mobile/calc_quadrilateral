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
  dSide,
  hHeight,
  aAngle,
  bAngle,
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
  var dSide = startLengthValue.obs;
  var hHeight = startLengthValue.obs;
  var aAngle = startAngleValue.obs;
  var bAngle = startAngleValue.obs;
  var kComp = startLengthValue.obs;
  var mComp = startLengthValue.obs;

  double aSideD = 0.0;
  double bSideD = 0.0;
  double cSideD = 0.0;
  double dSideD = 0.0;
  double kCompD = 0.0;
  double mCompD = 0.0;
  double hHeightD = 0.0;
  double aAngleD = 0.0;
  double bAngleD = 0.0;
  double yAngleD = 0.0;

  var area = "".obs;
  var perimeter = "".obs;
  var xSPoint = "".obs;
  var ySPoint = "".obs;

  double areaD = 0.0;
  double perimeterD = 0.0;
  double xSPointD = 0.0;
  double ySPointD = 0.0;

  var isDeg = true.obs;

  var isaAngle = false.obs;
  var isbAngle = false.obs;

  var isaSide = false.obs;
  var isbSide = false.obs;
  var iscSide = false.obs;
  var isdSide = false.obs;
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
    if (isAngleOver90(keySymbol)) {
      log.e('isAngleOver180');
      showSnack(TranslateHelper.messageAngleOver90);
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
    } else if (isdSide.value) {
      oldInput = dSide.value;

      // при вводе удаляю стартовый символ
      oldInput == startLengthValue ? oldInput = '' : oldInput = oldInput;

      sumInput = oldInput + newInput;
      sumInput = AppUtilsString.addZeroIsFirstDecimal(sumInput);

      dSide.value = sumInput;
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
        ${activeParamMap[1]} ${activeParamMap[2]} ${activeParamMap[3]} ${activeParamMap[4]}

        $aSideD | ${aSide.value} aSide 
        $bSideD | ${bSide.value} bSide 
        $cSideD | ${cSide.value} cSide 
        $dSideD | ${dSide.value} dSide 
        $hHeightD | ${hHeight.value} Height
        $aAngleD | ${aAngle.value} aAngle 
        $bAngleD | ${bAngle.value} bAngle

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
    } else if (isdSide.value) {
      if (ValidationUtils.isTwoDecimalPoint(dSide.value + keySymbol.value)) {
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
    }
    return false;
  }

  void resetActiveParams() {
    activeParamMap.value = <int, Trapezoid>{
      1: Trapezoid.empty,
      2: Trapezoid.empty,
      3: Trapezoid.empty,
      4: Trapezoid.empty,
    };
  }

  void resetActiveInput() {
//начальное значение при запуске
    isaSide.value = true;
    isbSide.value = false;
    iscSide.value = false;
    isdSide.value = false;
    ishHeight.value = false;

    isaAngle.value = false;
    isbAngle.value = false;
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
      if (activeParamMap.containsValue(Trapezoid.dSide)) {
        dSideD = double.parse(dSide.value);
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
    } catch (e) {
      log.e('initValue error to double');
      resetAllValue();
      resetActiveParams();
    }
    // }
  }

  void calcAreaAndPerimKnowAsideBSideCSideDSidedeHhei() {
    areaD = ((aSideD + cSideD) * hHeightD) / 2;
    area.value = AppUtilsNumber.getFormatNumber(areaD, precisionResult);

    perimeterD = aSideD + bSideD + cSideD + dSideD;
    perimeter.value =
        AppUtilsNumber.getFormatNumber(perimeterD, precisionResult);
  }

  calcHheiKnowDsideAang() {
    hHeightD = dSideD * sin(AppConvert.toRadian(aAngleD));
    hHeight.value = AppUtilsNumber.getFormatNumber(hHeightD, precisionResult);
  }

  calcHheiKnowBsideBang() {
    hHeightD = bSideD * sin(AppConvert.toRadian(bAngleD));
    hHeight.value = AppUtilsNumber.getFormatNumber(hHeightD, precisionResult);
  }

  calcBsideKnowHheiBang() {
    bSideD = hHeightD / sin(AppConvert.toRadian(bAngleD));
    bSide.value = AppUtilsNumber.getFormatNumber(bSideD, precisionResult);
  }

  calcDsideKnowHheiAang() {
    dSideD = hHeightD / sin(AppConvert.toRadian(aAngleD));
    dSide.value = AppUtilsNumber.getFormatNumber(dSideD, precisionResult);
  }

  calcKcompKnowAsideCsideMcomp() {
    kCompD = aSideD - mCompD - cSideD;
    kComp.value = AppUtilsNumber.getFormatNumber(kCompD, precisionResult);
  }

  calcMcompKnowAsideCsideKcomp() {
    mCompD = aSideD - kCompD - cSideD;
    mComp.value = AppUtilsNumber.getFormatNumber(mCompD, precisionResult);
  }

  calcBAngleKnowHheiBside() {
    bAngleD = AppConvert.toDegree(asin(hHeightD / bSideD));
    bAngle.value = AppUtilsNumber.getFormatNumber(bAngleD, precisionResult);
  }

  calcAangleKnowHheiDside() {
    aAngleD = AppConvert.toDegree(asin(hHeightD / dSideD));
    aAngle.value = AppUtilsNumber.getFormatNumber(aAngleD, precisionResult);
  }

  calcBangleKnowHheiBside() {
    bAngleD = AppConvert.toDegree(asin(hHeightD / bSideD));
    bAngle.value = AppUtilsNumber.getFormatNumber(bAngleD, precisionResult);
  }

  calcDsideKnowAsideBsideCsideBAngle() {
    dSideD = sqrt(pow(aSideD, 2) -
        2 * aSideD * bSideD * cos(AppConvert.toRadian(bAngleD)) -
        2 * aSideD * cSideD +
        pow(bSideD, 2) +
        2 * bSideD * cSideD * cos(AppConvert.toRadian(bAngleD)) +
        pow(cSideD, 2));
    dSide.value = AppUtilsNumber.getFormatNumber(dSideD, precisionResult);
  }
 calcCsideKnowAsideBsideAangBang() {
    cSideD = (aSideD*sin(AppConvert.toRadian(aAngleD))-bSideD*sin(AppConvert.toRadian(-aAngleD-bAngleD+180)))/(sin(AppConvert.toRadian(aAngleD)));
    cSide.value = AppUtilsNumber.getFormatNumber(cSideD, precisionResult);
  }
  calcBangleKnowASideBSideCsideAangle() {
    bAngleD = -aAngleD -
        AppConvert.toDegree((asin((aSideD * sin(AppConvert.toRadian(aAngleD)) -
                cSideD * sin(AppConvert.toRadian(aAngleD))) /
            bSideD))) +
        180;
    bAngle.value = AppUtilsNumber.getFormatNumber(bAngleD, precisionResult);
  }

  calcAangleKnowASideBSideCsideDside() {
    var top = pow(aSideD, 2) -
        2 * aSideD * cSideD -
        pow(bSideD, 2) +
        pow(cSideD, 2) +
        pow(dSideD, 2);
    var bottom = 2 * dSideD * (aSideD - cSideD);
    aAngleD = AppConvert.toDegree(acos(top / bottom));
    aAngle.value = AppUtilsNumber.getFormatNumber(aAngleD, precisionResult);
  }

  void calculate() {
    if (isOnlyTwoParamEmpty()) return;
    if (isOnlyOneParamEmpty()) return;
    if (isOnlyThreeParamEmpty()) return;
    log.i('start calculate');
    printElements();
    Trapezoid param1;
    Trapezoid param2;
    Trapezoid param3;
    Trapezoid param4;

// aSide bSide cSide hHeight ==ok
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.cSide;
    param4 = Trapezoid.hHeight;

    if (isAvailableFourParams(param1, param2, param3, param4)) {
      calcBAngleKnowHheiBside();
      calcDsideKnowAsideBsideCsideBAngle();
      calcAangleKnowHheiDside();

      calcAreaAndPerimKnowAsideBSideCSideDSidedeHhei();
    }

// aSide bSide cSide dSide == ok
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.cSide;
    param4 = Trapezoid.dSide;

    if (isAvailableFourParams(param1, param2, param3, param4)) {
      calcAangleKnowASideBSideCsideDside();
      calcBangleKnowASideBSideCsideAangle();
      calcHheiKnowBsideBang();

      calcAreaAndPerimKnowAsideBSideCSideDSidedeHhei();
    }

// aSide bSide cSide aAngle
    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.cSide;
    param4 = Trapezoid.aAngle;

    if (isAvailableFourParams(param1, param2, param3, param4)) {
      calcBangleKnowASideBSideCsideAangle();
      calcDsideKnowAsideBsideCsideBAngle();
      calcHheiKnowBsideBang();
      calcAreaAndPerimKnowAsideBSideCSideDSidedeHhei();
    }

// aSide bSide cSide bAngle

    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.cSide;
    param4 = Trapezoid.bAngle;

    if (isAvailableFourParams(param1, param2, param3, param4)) {
      calcHheiKnowBsideBang();
      calcAangleKnowHheiDside();
      calcDsideKnowAsideBsideCsideBAngle();
      calcAreaAndPerimKnowAsideBSideCSideDSidedeHhei();
    }

// aSide bSide hHeight dSide

    param1 = Trapezoid.aSide;
    param2 = Trapezoid.bSide;
    param3 = Trapezoid.hHeight;
    param4 = Trapezoid.dSide;

    if (isAvailableFourParams(param1, param2, param3, param4)) {
      calcAangleKnowHheiDside();
      calcBAngleKnowHheiBside();
      calcCsideKnowAsideBsideAangBang();
      calcAreaAndPerimKnowAsideBSideCSideDSidedeHhei();
    }

// aSide bSide hHeight aAngle
// aSide bSide hHeight bAngle
// aSide bSide dSide aAngle
// aSide bSide dSide bAngle
// aSide bSide aAngle bAngle
// aSide cSide hHeight dSide
// aSide cSide hHeight aAngle
// aSide cSide hHeight bAngle
// aSide cSide dSide aAngle
// aSide cSide dSide bAngle
// aSide cSide aAngle bAngle
// aSide hHeight dSide aAngle
// aSide hHeight dSide bAngle
// aSide hHeight aAngle bAngle
// aSide dSide aAngle bAngle
// bSide cSide hHeight dSide
// bSide cSide hHeight aAngle
// bSide cSide hHeight bAngle
// bSide cSide dSide aAngle
// bSide cSide dSide bAngle
// bSide cSide aAngle bAngle
// bSide hHeight dSide aAngle
// bSide hHeight dSide bAngle
// bSide hHeight aAngle bAngle
// bSide dSide aAngle bAngle
// cSide hHeight dSide aAngle
// cSide hHeight dSide bAngle
// cSide hHeight aAngle bAngle
// cSide dSide aAngle bAngle
// hHeight dSide aAngle bAngle

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
    if (ValidationUtils.isNumberNanAndInfinity(dSideD)) {
      dSide.value = startLengthValue;
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

    activeInput = isdSide.value;
    valueActiveInput = dSide.value;
    if (activeInput && valueActiveInput == startLengthValue) {
      oldValue = Trapezoid.dSide;

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

    return false;
  }

  void setActiveParam() {
    log.v(
        '1 ${activeParamMap[1]} 2 ${activeParamMap[2]} 3 ${activeParamMap[3]} 4 ${activeParamMap[4]} start active param');

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
    } else if (isdSide.value) {
      paramActive = Trapezoid.dSide;
      paramLastLenght = Trapezoid.dSide;
    } else if (ishHeight.value) {
      paramActive = Trapezoid.hHeight;
      paramLastLenght = Trapezoid.hHeight;
    } else if (isaAngle.value) {
      paramActive = Trapezoid.aAngle;
    } else if (isbAngle.value) {
      paramActive = Trapezoid.bAngle;
    }

    moveEmptyValueToStartInParameters();
    //если уже есть данный параметр переместить его наверх
    if (isAvailableOneParam(paramActive)) {
      moveValueToEndInParameters(paramActive);
      return;
    }

//если последний параметр похож на активный
    if (activeParamMap[4] == paramActive) return;

    if (activeParamMap[4] != Trapezoid.empty) {
      activeParamMap[1] = activeParamMap[2]!;
      activeParamMap[2] = activeParamMap[3]!;
      activeParamMap[2] = activeParamMap[4]!;
    }

    activeParamMap[4] = paramActive;
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

  bool isAvailableFourParams(
    Trapezoid param1,
    Trapezoid param2,
    Trapezoid param3,
    Trapezoid param4,
  ) {
    if (activeParamMap.containsValue(param1) &&
        activeParamMap.containsValue(param2) &&
        activeParamMap.containsValue(param3) &&
        activeParamMap.containsValue(param4)) {
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

    // если есть пустой параметр
    // если есть пустой параметр
    if (isOnlyFourParamEmpty()) {
      showSnack(TranslateHelper.enterFourParameters);
      return;
    }
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
    if (isAvailableTwoParams(
      Trapezoid.aSide,
      Trapezoid.cSide,
    )) {
      if (iscSide.value) {
        result = aSideD;
        if (!(cSideD <= result)) {
          showSnack(
              '${TranslateHelper.base} c ${TranslateHelper.must_be} < = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
          return;
        }
      }

      if (isaSide.value) {
        result = cSideD;
        if (!(aSideD >= result)) {
          showSnack(
              '${TranslateHelper.base} a ${TranslateHelper.must_be} > = ${AppUtilsNumber.getFormatNumber(result, precisionResult)}');
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

  bool isLeatOneParamEmpty() {
    if (activeParamMap.containsValue(Trapezoid.empty)) {
      return true;
    }
    return false;
  }

  bool isAngleOver90(KeySymbol keySymbol) {
    String newInput = keySymbol.value;
    initValue();
    double sum = 0;
    if (isaAngle.value) {
      sum = double.parse(
          AppUtilsString.removeLastCharacter(aAngle.value) + newInput);
      if (90 < sum) return true;
    } else if (isbAngle.value) {
      sum = double.parse(
          AppUtilsString.removeLastCharacter(bAngle.value) + newInput);
      if (90 < sum) return true;
    }
    return false;
  }

  bool isOnlyOneParamEmpty() {
    if (activeParamMap[1] == Trapezoid.empty &&
            activeParamMap[2] != Trapezoid.empty &&
            activeParamMap[3] != Trapezoid.empty &&
            activeParamMap[4] != Trapezoid.empty ||
        activeParamMap[1] != Trapezoid.empty &&
            activeParamMap[2] == Trapezoid.empty &&
            activeParamMap[3] != Trapezoid.empty &&
            activeParamMap[4] != Trapezoid.empty ||
        activeParamMap[1] != Trapezoid.empty &&
            activeParamMap[2] != Trapezoid.empty &&
            activeParamMap[3] == Trapezoid.empty &&
            activeParamMap[4] != Trapezoid.empty ||
        activeParamMap[1] != Trapezoid.empty &&
            activeParamMap[2] != Trapezoid.empty &&
            activeParamMap[3] != Trapezoid.empty &&
            activeParamMap[4] == Trapezoid.empty) {
      return true;
    }
    return false;
  }

  bool isOnlyTwoParamEmpty() {
    if (activeParamMap[1] == Trapezoid.empty &&
            activeParamMap[2] == Trapezoid.empty ||
        activeParamMap[1] == Trapezoid.empty &&
            activeParamMap[3] == Trapezoid.empty ||
        activeParamMap[1] == Trapezoid.empty &&
            activeParamMap[4] == Trapezoid.empty ||
        activeParamMap[2] == Trapezoid.empty &&
            activeParamMap[3] == Trapezoid.empty ||
        activeParamMap[2] == Trapezoid.empty &&
            activeParamMap[4] == Trapezoid.empty ||
        activeParamMap[3] == Trapezoid.empty &&
            activeParamMap[4] == Trapezoid.empty) {
      return true;
    }
    return false;
  }

  bool isOnlyThreeParamEmpty() {
    if (activeParamMap[1] == Trapezoid.empty &&
            activeParamMap[2] == Trapezoid.empty &&
            activeParamMap[3] == Trapezoid.empty ||
        activeParamMap[1] == Trapezoid.empty &&
            activeParamMap[2] == Trapezoid.empty &&
            activeParamMap[4] == Trapezoid.empty ||
        activeParamMap[1] == Trapezoid.empty &&
            activeParamMap[3] == Trapezoid.empty &&
            activeParamMap[4] == Trapezoid.empty ||
        activeParamMap[2] == Trapezoid.empty &&
            activeParamMap[3] == Trapezoid.empty &&
            activeParamMap[4] == Trapezoid.empty) {
      return true;
    }
    return false;
  }

  bool isOnlyFourParamEmpty() {
    if (activeParamMap[1] == Trapezoid.empty &&
        activeParamMap[2] == Trapezoid.empty &&
        activeParamMap[3] == Trapezoid.empty &&
        activeParamMap[4] == Trapezoid.empty) {
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
    } else if (isdSide.value) {
      value = dSide.value;
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
    if (activeParamMap[4] == Trapezoid.aSide &&
        aSide.value == startLengthValue) {
      activeParamMap[4] = Trapezoid.empty;
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

    if (activeParamMap[4] == Trapezoid.bSide &&
        bSide.value == startLengthValue) {
      activeParamMap[4] = Trapezoid.empty;
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
    if (activeParamMap[4] == Trapezoid.cSide &&
        cSide.value == startLengthValue) {
      activeParamMap[4] = Trapezoid.empty;
    }

//===============================================
    if (activeParamMap[1] == Trapezoid.dSide &&
        dSide.value == startLengthValue) {
      activeParamMap[1] = Trapezoid.empty;
    }

    if (activeParamMap[2] == Trapezoid.dSide &&
        dSide.value == startLengthValue) {
      activeParamMap[2] = Trapezoid.empty;
    }
    if (activeParamMap[3] == Trapezoid.dSide &&
        dSide.value == startLengthValue) {
      activeParamMap[3] = Trapezoid.empty;
    }
    if (activeParamMap[4] == Trapezoid.dSide &&
        dSide.value == startLengthValue) {
      activeParamMap[4] = Trapezoid.empty;
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
  }

  void prevElement() {
    // переключение  между widgets

    _isNext(false);
  }

  void convertDMSToDeg() {
    aAngle.value = AppConvert.convertDMStoDeg(aAngle.value, precisionResult);
    bAngle.value = AppConvert.convertDMStoDeg(bAngle.value, precisionResult);
  }

  void convertDegToDMS() {
// если мы в минутах то переводим углы
    aAngle.value = AppConvert.convertDegToDMS(aAngleD, precisionResult);
    bAngle.value = AppConvert.convertDegToDMS(bAngleD, precisionResult);
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
    } else if (isdSide.value) {
      cSide.value = startLengthValue;
    } else if (ishHeight.value) {
      hHeight.value = startLengthValue;
    } else if (isaAngle.value) {
      aAngle.value = startAngleValue;
    } else if (isbAngle.value) {
      bAngle.value = startAngleValue;
    }

    initValue();
    setActiveParam();
    log.v(
        '1 ${activeParamMap[1]} 2 ${activeParamMap[2]} 3 ${activeParamMap[3]} 4 ${activeParamMap[4]} longBackspace active param  ');

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
    } else if (isdSide.value) {
      oldInput = dSide.value;
      newInput = AppUtilsString.removeLastCharacter(oldInput);
      //если пусто устанавливаем стартовое значение
      if (newInput.isEmpty) {
        dSideD = 0;
        newInput = startLengthValue;
        resetNotActiveValue();
      }
      dSide.value = newInput;
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
    dSide.value = startLengthValue;

    hHeight.value = startLengthValue;

    aAngle.value = startAngleValue;
    bAngle.value = startAngleValue;

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
    if (!isAvailableOneParam(Trapezoid.dSide)) {
      dSide.value = startLengthValue;
      dSideD = 0;
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
  }

  void _isNext(bool isNext) {
    if (isNext) {
      if (isaSide.value) {
        isaAngle.value = true;
        isaSide.value = false;
      } else if (isaAngle.value) {
        isbAngle.value = true;
        isaAngle.value = false;
      } else if (isbAngle.value) {
        isbSide.value = true;
        isbAngle.value = false;
      } else if (isbSide.value) {
        isbSide.value = false;
        ishHeight.value = true;
      } else if (ishHeight.value) {
        ishHeight.value = false;
        isdSide.value = true;
      } else if (isdSide.value) {
        isdSide.value = false;
        iscSide.value = true;
      } else if (iscSide.value) {
        isaSide.value = true;
        iscSide.value = false;
      }
    } else {
      if (isaSide.value) {
        iscSide.value = true;
        isaSide.value = false;
      } else if (iscSide.value) {
        isdSide.value = true;
        iscSide.value = false;
      } else if (isdSide.value) {
        ishHeight.value = true;
        isdSide.value = false;
      } else if (ishHeight.value) {
        isbSide.value = true;
        ishHeight.value = false;
      } else if (isbSide.value) {
        isbSide.value = false;
        isbAngle.value = true;
      } else if (isbAngle.value) {
        isaAngle.value = true;
        isbAngle.value = false;
      } else if (isaAngle.value) {
        isaAngle.value = false;
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
