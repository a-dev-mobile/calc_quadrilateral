class AppUtilsMap {
  /* 
    var updateMap = updateValues(activeParamMap, oldValue, newValue)
      .cast<int, Scalenequadrilateral>();

  var updateMap2 = updateValues(activeParamMap2, oldValue2, newValue2)
      .cast<int, Rightquadrilateral>();
     */

  static Map<int, dynamic> updateValues(
      {required Map<int, dynamic> oldMap,
      required var oldValue,
      required var newValue}) {
    Map<int, dynamic> newMap = {}..addAll(oldMap);
    List<int> keyList = [];

    for (var e in oldMap.entries) {
      if (e.value == oldValue) {
        keyList.add(e.key);
      }
    }
    for (var key in keyList) {
      newMap[key] = newValue;
    }
    return newMap;
  }

  static Map<int, dynamic> moveValue(
      {required Map<int, dynamic> oldMap,
      required var moveValue,
      required bool isPositionStart}) {
    // if (!oldMap.containsValue(moveValue) || oldMap.isEmpty) {
    //   throw Exception(
    //       "{{{{{{{{{{ map empty or not contains value = $moveValue }}}}}}}}}}");
    // }

    Map<int, dynamic> mapWithoutMoveValue = {};
    List<int> keyListMoveValue = [];

    int i = 1;

    for (var e in oldMap.entries) {
      if (e.value == moveValue) {
        keyListMoveValue.add(e.key);
      } else {
        mapWithoutMoveValue[i] = e.value;
        i++;
      }
    }
    Map<int, dynamic> mapWithMoveValue = {};
    i = 1;

    if (isPositionStart) {
      for (var key in keyListMoveValue) {
        mapWithMoveValue[i] = moveValue;
        i++;
      }
      for (var e in mapWithoutMoveValue.entries) {
        mapWithMoveValue[i] = e.value;
        i++;
      }
    } else {
      for (var e in mapWithoutMoveValue.entries) {
        mapWithMoveValue[i] = e.value;
        i++;
      }
      for (var key in keyListMoveValue) {
        mapWithMoveValue[i] = moveValue;
        i++;
      }
    }

    return mapWithMoveValue;
  }
}
